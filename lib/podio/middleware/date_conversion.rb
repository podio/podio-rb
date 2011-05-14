module Podio
  module Middleware
    class DateConversion < Faraday::Response::Middleware
      def on_complete(env)
        convert_dates(env[:body]) if env[:body].is_a?(Hash)
      end

      # Converts all attributes ending with "_on" to datetime and ending with "date" to date
      def convert_dates(body)
        [body].flatten.compact.each do |hash|
          hash.each do |key, value|
            if value.is_a?(Hash)
              convert_dates(value)
            elsif value.is_a?(Array)
              value.each_with_index { |item, index| hash[key][index] = convert_field(key, item) }
            else
              hash[key] = convert_field(key, value)
            end
          end
        end
      end

    private

      def convert_field(key, value)
        if key.present?
          if key[-3..-1] == "_on"
            return value.try(:to_s).try(:to_datetime)
          elsif key[-4..-1] == "date"
            return value.try(:to_s).try(:to_date)
          end
        end
        value
      end
    end
  end
end
