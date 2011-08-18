require 'active_model'

# Extends the Ruby wrapper to behave a bit like ActiveRecord models
module ActivePodio
  class Base
    extend ActiveModel::Naming, ActiveModel::Callbacks
    include ActiveModel::Conversion
    
    class_inheritable_accessor :valid_attributes
    attr_accessor :attributes, :error_code, :error_message, :error_parameters

    def initialize(attributes = {})
      self.valid_attributes ||= []
      attributes ||= {}
      self.attributes = Hash[*self.valid_attributes.collect { |n| [n.to_sym, nil] }.flatten].merge(attributes.symbolize_keys)
      attributes.each do |key, value|
        if self.respond_to?("#{key}=".to_sym)
          self.send("#{key}=".to_sym, value) 
        elsif valid_attributes.include?(key.to_sym)
          self.send(:[]=, key.to_sym, value)
        end
      end
    end
    
    def persisted?
      ! self.new_record?
    end
    
    def new_record?
      ! (self.respond_to?(:id) && self.id.present?)
    end
    
    def to_param
      return self.id.try(:to_s) if self.respond_to?(:id)
    end
    
    def [](attribute)
      @attributes ||= {}
      @attributes[attribute.to_sym]
    end
    
    def []=(attribute, value)
      @attributes ||= {}
      @attributes[attribute.to_sym] = value
    end
    
    def ==(other)
      !self.nil? && !other.nil? && self.respond_to?(:id) && other.respond_to?(:id) && self.id == other.id
    end
    alias :eql? :==
    
    def hash
      self.id.hash if self.respond_to?(:id)
    end
    
    def as_json(options={})
      self.attributes
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

    class << self
      
      public
      
      # Defines the the supported attributes of the model
      def property(name, type = :string)
        self.valid_attributes ||= []
        self.valid_attributes << name
    
        case type
        when :datetime
          define_datetime_accessor(name)
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
        self.send(:define_method, name) do
          klass = klass_for_association(options)
          instance = self.instance_variable_get("@#{name}_has_one_instance")
          unless instance.present?
            property = options[:property] || name.to_sym
            if self[property].present?
              instance = klass.new(self[property])
              self.instance_variable_set("@#{name}_has_one_instance", instance)
            else
              instance = nil
            end
          end
          instance
        end
      end
    
      # Wraps a collection of hashes from the API to a collection of the given model
      def has_many(name, options = {})
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
        new(response)
      end
    
      # Returns a simple collection model instances
      def list(response)
        response.map! { |item| new(item) }
        response
      end
    
      # Returns a struct that includes:
      # * all: A collection model instances
      # * count: The number of returned records
      # * total_count: The total number of records matching the given conditions
      def collection(response)
        result = Struct.new(:all, :count, :total_count).new(response['items'], response['filtered'], response['total'])
        result.all.map! { |item| new(item) }
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
      # If a Podio::BadRequestError occurs, the method returns false and the error can be read from the error_message accessor
      # If another error occurs, it is still raised
      def handle_api_errors_for(*method_names)
        method_names.each do |method_name|
          self.send(:define_method, "#{method_name}_with_api_errors_handled") do |*args|
            success, code, message, parameters, result = nil
            begin
              result = self.send("#{method_name}_without_api_errors_handled", *args)
              success = true
            rescue Podio::BadRequestError, Podio::AuthorizationError => ex
              success = false
              code        = ex.response_body["error"]
              message     = ex.response_body["error_description"]
              parameters  = ex.response_body["error_parameters"]
            end
          
            if success
              return result || true
            else
              @error_code       = code
              @error_message    = message
              @error_parameters = parameters
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
    
        def define_datetime_accessor(name)
          self.send(:define_method, name) do
            self[name.to_sym].try(:to_datetime).try(:in_time_zone)
          end
    
          self.send(:define_method, "#{name}=") do |value|
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
              value.try(:to_s)
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
              self[name.to_sym] = array.reject(&:blank?) if array.respond_to?(:reject)
            end
          end
    
          self.send(:define_method, name.to_s.pluralize) do
            self[name.to_sym] || []
          end
    
          self.send(:define_method, "#{name.to_s.pluralize}=") do |array|
            self[name.to_sym] = array.reject(&:blank?) if array.respond_to?(:reject)
          end
    
          self.send(:define_method, "default_#{name.to_s.singularize}") do
            self[name.to_sym].try(:first).presence
          end
        end
    end
  end
end
