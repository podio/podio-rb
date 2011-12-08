require 'active_model'

# Extends the Ruby wrapper to behave a bit like ActiveRecord models
module ActivePodio
  class Base
    extend ActiveModel::Naming, ActiveModel::Callbacks
    include ActiveModel::Conversion

    class_attribute :valid_attributes, :associations
    attr_accessor :attributes, :error_code, :error_message, :error_parameters, :error_propagate
    alias_method :propagate_error?, :error_propagate

    def initialize(attributes = {}, options = {})
      self.valid_attributes ||= []
      attributes ||= {}
      self.attributes = Hash[*self.valid_attributes.collect { |n| [n.to_sym, nil] }.flatten].merge(attributes.symbolize_keys)

      @values_from_api = options[:values_from_api] # Used to determine if date times should be converted from local to utc, or are already utc
      
      attributes.each do |key, value|
        if self.respond_to?("#{key}=".to_sym)
          self.send("#{key}=".to_sym, value)
        else
          is_association_hash = value.is_a?(Hash) && self.associations.present? && self.associations.has_key?(key.to_sym) && self.associations[key.to_sym] == :has_one && self.send(key.to_sym).respond_to?(:attributes)
          if valid_attributes.include?(key.to_sym) || is_association_hash
            # Initialize nested object to get correctly casted values set back, unless the given values are all blank
            if is_association_hash
              attributes = self.send(key.to_sym).attributes
              if any_values_present_recursive?(attributes.values)
                value = attributes
              else
                value = nil
              end
            end
            self.send(:[]=, key.to_sym, value)
          end
        end
      end

      @belongs_to = options[:belongs_to] # Allows has_one associations to communicate their changed content back to their parent model
      @values_from_api = false
    end
    
    def persisted?
      ! self.new_record?
    end
    
    def new_record?
      ! (self.respond_to?(:id) && self.id.present?)
    end
    
    def to_param
      local_id = self.id if self.respond_to?(:id)
      local_id = nil if local_id == self.object_id # Id still returns object_id in Ruby 1.8.7, JRuby and Rubinius
      local_id.try(:to_s)
    end
    
    def [](attribute)
      @attributes ||= {}
      @attributes[attribute.to_sym]
    end
    
    def []=(attribute, value)
      @attributes ||= {}
      @attributes[attribute.to_sym] = value
      if @belongs_to.present? && value.present?
        @belongs_to[:model][@belongs_to[:as]] ||= {}
        @belongs_to[:model][@belongs_to[:as]][attribute.to_sym] = value
      end
    end
    
    def ==(other)
      !self.nil? && !other.nil? && self.respond_to?(:id) && other.respond_to?(:id) && self.id == other.id
    end
    alias :eql? :==
    
    def hash
      self.id.hash if self.respond_to?(:id)
    end
    
    def as_json(options={})
      if self.respond_to?(:id)
        self.attributes.merge(:id => self.id)
      else
        self.attributes
       end
    end
    
    private
    
      def klass_for_association(options)
        klass_name = options[:class]
        raise "Missing class name of associated model. Provide with :class => 'MyClass'." unless klass_name.present?
        klass = nil
        begin
          klass = klass_name.constantize
        rescue
          klass = "Podio::#{klass_name}".constantize
        end
        return klass
      end
      
      def any_values_present_recursive?(values)
        values.any? do |value|
          if value.respond_to?(:values)
            any_values_present_recursive?(value.values)
          else
            value.present?
          end
        end
      end

    class << self
      
      public
      
      # Defines the the supported attributes of the model
      def property(name, type = :string, options = {})
        self.valid_attributes ||= []
        self.valid_attributes << name
    
        case type
        when :datetime
          define_datetime_accessor(name, options)
        when :date
          define_date_accessor(name)
        when :integer
          define_integer_accessor(name)
        when :boolean
          define_generic_accessor(name, :setter => false)
          define_boolean_accessors(name)
        when :array
          define_array_accessors(name)
        else
          define_generic_accessor(name)
        end
      end
    
      # Wraps a single hash provided from the API in the given model
      def has_one(name, options = {})
        self.associations ||= {}
        self.associations[name] = :has_one

        self.send(:define_method, name) do
          klass = klass_for_association(options)
          instance = self.instance_variable_get("@#{name}_has_one_instance")
          unless instance.present?
            property = options[:property] || name.to_sym
            if self[property].present?
              instance = klass.new(self[property], :belongs_to => { :model => self, :as => property })
              self.instance_variable_set("@#{name}_has_one_instance", instance)
            else
              instance = nil
            end
          end
          instance
        end

        self.send(:define_method, "clear_#{name}") do
          self.instance_variable_set("@#{name}_has_one_instance", nil)
        end
      end
    
      # Wraps a collection of hashes from the API to a collection of the given model
      def has_many(name, options = {})
        self.associations ||= {}
        self.associations[name] = :has_many

        self.send(:define_method, name) do
          klass = klass_for_association(options)
          instances = self.instance_variable_get("@#{name}_has_many_instances")
          unless instances.present?
            property = options[:property] || name.to_sym
            if self[property].present?
              instances = self[property].map { |attributes| klass.new(attributes) }
              self.instance_variable_set("@#{name}_has_many_instances", instances)
            else
              instances = []
            end
          end
          instances
        end
    
        self.send(:define_method, "#{name}?") do
          self.send(name).length > 0
        end
      end
    
      # Returns a single instance of the model
      def member(response)
        new(response, :values_from_api => true)
      end
    
      # Returns a simple collection model instances
      def list(response)
        response.map! { |item| new(item, :values_from_api => true) }
        response
      end
    
      # Returns a struct that includes:
      # * all: A collection model instances
      # * count: The number of returned records
      # * total_count: The total number of records matching the given conditions
      def collection(response)
        result = Struct.new(:all, :count, :total_count).new(response['items'], response['filtered'], response['total'])
        result.all.map! { |item| new(item, :values_from_api => true) }
        result
      end
    
      def delegate_to_hash(hash_name, *attribute_names)
        options = attribute_names.extract_options!
        options.reverse_merge!(:prefix => false, :setter => false)
        options.assert_valid_keys(:prefix, :setter)
        attribute_names.each do |attribute_name|
          hash_index = attribute_name.to_s.gsub(/[\?!]/, '')
          method_name = "#{options[:prefix] ? "#{hash_name}_" : ''}#{attribute_name}"
          self.send(:define_method, method_name) do
            self.send("#{hash_name}=", {}) unless self.send(hash_name)
            self.send(hash_name)[hash_index]
          end
          if options[:setter]
            self.send(:define_method, "#{method_name}=") do |value|
              self.send("#{hash_name}=", {}) unless self.send(hash_name)
              self.send(hash_name)[hash_index] = value
            end
          end
        end
      end
      
      # Wraps the given methods in a begin/rescue block
      # If no error occurs, the return value of the method, or true if nil is returned, is returned
      # If a Podio::PodioError occurs, the method returns false and the error can be read from the error_message accessor
      # If another error occurs, it is still raised
      def handle_api_errors_for(*method_names)
        method_names.each do |method_name|
          self.send(:define_method, "#{method_name}_with_api_errors_handled") do |*args|
            success, code, message, parameters, result = nil
            begin
              result = self.send("#{method_name}_without_api_errors_handled", *args)
              success = true
            rescue Podio::PodioError => ex
              success = false
              code        = ex.response_body["error"]
              message     = ex.response_body["error_description"]
              parameters  = ex.response_body["error_parameters"]
              propagate  = ex.response_body["error_propagate"]
            end
          
            if success
              return result || true
            else
              @error_code       = code
              @error_message    = message
              @error_parameters = parameters || {}
              @error_propagate  = propagate
              return false
            end
          end
        
          alias_method_chain method_name, :api_errors_handled
        end
      end
    
      private
    
        def define_generic_accessor(name, options = {})
          options.reverse_merge!(:getter => true, :setter => true)
    
          if(options[:getter])
            self.send(:define_method, name) do
              self[name.to_sym]
            end
          end
    
          if(options[:setter])
            self.send(:define_method, "#{name}=") do |value|
              self[name.to_sym] = value
            end
          end
        end
    
        def define_datetime_accessor(name, options = {})
          self.send(:define_method, name) do
            options[:convert_timezone] == false ? self[name.to_sym].try(:to_datetime) : self[name.to_sym].try(:to_datetime).try(:in_time_zone)
          end
    
          self.send(:define_method, "#{name}=") do |value|
            
            # TODO: This should eventually be done on all date times
            # This option is a temporary fix while API transitions to UTC only
            if options[:convert_incoming_local_datetime_to_utc] && value.present? && !@values_from_api
              value = value.try(:to_datetime) unless value.is_a?(DateTime)
              value = Time.zone.local_to_utc(value)
            end
            
            self[name.to_sym] = if value.is_a?(DateTime)
              value.try(:to_s, :db)
            else
              value.try(:to_s)
            end
          end
        end
    
        def define_date_accessor(name)
          self.send(:define_method, name) do
            self[name.to_sym].try(:to_date)
          end
    
          self.send(:define_method, "#{name}=") do |value|
            self[name.to_sym] = if value.is_a?(Date)
              value.try(:to_s, :db)
            else
              value = value.try(:to_s)
              if defined?(I18n) && value.present? && !(value =~ /^\d{4}-\d{2}-\d{2}$/) # If we have I18n available, assume that we are in Rails and try to convert the string to a date to convert it to ISO 8601
                value_as_date = Date.strptime(value, I18n.t('date.formats.default')) rescue nil
                value_as_date.nil? ? value.try(:to_s) : value_as_date.try(:to_s, :db)
              else
                value
              end
            end
          end
        end
    
        def define_integer_accessor(name)
          self.send(:define_method, name) do
            if self[name.to_sym].present?
              self[name.to_sym].to_i
            else
              nil
            end
          end
    
          self.send(:define_method, "#{name}=") do |value|
            if value.present?
              self[name.to_sym] = value.to_i
            else
              self[name.to_sym] = nil
            end
          end
        end
    
        def define_boolean_accessors(name)
          self.send(:define_method, "#{name}?") do
            if self[name.to_sym].present?
              %w{ true 1 yes }.include?(self[name.to_sym].to_s.strip.downcase)
            else
              nil
            end
          end
    
          self.send(:define_method, "#{name}=") do |value|
            if value == true || value == false
              self[name.to_sym] = value
            elsif value.present?
              self[name.to_sym] = %w{ true 1 yes }.include?(value.to_s.strip.downcase)
            else
              self[name.to_sym] = nil
            end
          end
        end
    
        def define_array_accessors(name)
          unless name.to_s == name.to_s.pluralize
            self.send(:define_method, name) do
              self[name.to_sym] || []
            end
    
            self.send(:define_method, "#{name}=") do |array|
              self[name.to_sym] = array.respond_to?(:reject) ? array.reject(&:blank?) : array
            end
          end
    
          self.send(:define_method, name.to_s.pluralize) do
            self[name.to_sym] || []
          end
    
          self.send(:define_method, "#{name.to_s.pluralize}=") do |array|
            self[name.to_sym] = array.respond_to?(:reject) ? array.reject(&:blank?) : array
          end
    
          self.send(:define_method, "default_#{name.to_s.singularize}") do
            self[name.to_sym].try(:first).presence
          end

          self.send(:define_method, "default_#{name.to_s.singularize}=") do |value|
            if self[name.to_sym].try(:first).present?
              self[name.to_sym][0] = value
            else
              self[name.to_sym] = [value]
            end

            self[name.to_sym].compact!

          end
        end
    end
  end
end
