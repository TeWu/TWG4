module TWG4
  module Serializers
    class RolesBitmaskSerializer < BitmaskSerializer

      def initialize
        @bitval2obj = TWG4::CONFIG[:roles_values_inverse]
        @obj2bitval = lambda { |key| TWG4::CONFIG[:roles_values][key.to_sym] }
      end

      class << self
        def instance
          @instance ||= RolesBitmaskSerializer.new
        end

        delegate :load, :dump, to: :instance
      end

    end
  end
end
