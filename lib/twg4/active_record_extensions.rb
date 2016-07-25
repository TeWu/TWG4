module TWG4
  module ActiveRecordExtensions
    extend ActiveSupport::Concern

    class_methods do

      def max_length(attribute)
        validators_on(attribute)
            .select { |v| v.is_a? ActiveRecord::Validations::LengthValidator }
            .map { |v| v.options[:maximum] }
            .first
      end

      def persisted
        select(&:persisted?)
      end

    end
  end
end
