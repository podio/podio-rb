module Podio
  module Middleware
    class DateConversion < Faraday::Response::Middleware
      def self.register_on_complete(env)
        env[:response].on_complete do |finished_env|
          finished_env[:body] = convert_dates(finished_env[:body])
        end
      end
      
      # Converts all attributes ending with "_on" to datetime and ending with "date" to date
      def self.convert_dates(hash)
        hash.each do |key, value|
          if value.is_a?(Hash)
            self.convert_dates(value)
          elsif value.is_a?(Array)
            value.each { |item| item = self.convert_field(key, item) }
          else
            value = self.convert_field(key, value)
          end
        end
      end
      
      private
      
        def self.convert_field(key, value)
          if key.present?
            if key[-3..-1] == "_on"
              value.try(:to_s).try(:to_datetime)
            elsif key[-4..-1] == "date"
              value.try(:to_s).try(:to_date)
            end
          end
        end
      
    end
  end
end
