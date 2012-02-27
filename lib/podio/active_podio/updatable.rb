# Adds functionality related to updating to an +ActivePodio+ model
module ActivePodio
  module Updatable
    def update_attributes(attributes)
      attributes.each do |key, value|
        self.send("#{key}=".to_sym, value.presence)
      end
    end

    def remove_nil_values(input_hash)
      input_hash.inject({}) do |hash, (key, value)|
        hash[key] = value if value.present?
        hash
      end
    end
  end
end
