module TWG4
  class MockUser
    def initialize(attrs)
      @attrs = attrs
    end
    def method_missing(method, *)
      @attrs[method]
    end
  end
end
