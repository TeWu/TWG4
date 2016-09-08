class BasePresenter

  def initialize(template, object = nil)
    @template = template
    @object = object
  end

  private

  def self.presents(name)
    define_method(name) do
      @object
    end
  end

  def h
    @template
  end

  def tag(name, **options, &block)
    return h.content_tag name, options, &block if block_given?
    h.tag name, options
  end

  def method_missing(method, *args, &block)
    @template.send(method, *args, &block)
  end

end
