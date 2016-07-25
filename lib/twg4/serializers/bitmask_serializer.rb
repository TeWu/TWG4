module TWG4
  module Serializers
    class BitmaskSerializer

      def initialize(bitval2obj, obj2bitval)
        @bitval2obj, @obj2bitval = bitval2obj, obj2bitval
      end

      def load(num)
        num = num.to_i # i.a. convert nil to 0
        arr = []
        bit_val = 1
        while bit_val <= num
          if num & bit_val == bit_val
            obj = @bitval2obj[bit_val]
            arr << obj if obj
          end
          bit_val *= 2
        end
        arr
      end

      def dump(arr)
        arr.inject(0) do |num, obj|
          num + @obj2bitval[obj].to_i # 'to_i' to convert nil to 0
        end
      end

    end
  end
end
