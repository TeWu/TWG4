module NestedAuthorizationCheckers
  extend ActiveSupport::Concern

  included do
    helper_method :nested_can?, :nested_cannot?, :possibly_nested_can?, :possibly_nested_cannot?

    def nested_can?(action, nested_subject, *extra_args)
      !!if nested_subject.is_a? Array and nested_subject.length == 2
          can? action, [nested_subject].to_h, extra_args
        end
    end

    def nested_cannot?(*args)
      !nested_can?(*args)
    end

    def possibly_nested_can?(*args)
      can?(*args) or nested_can?(*args)
    end

    def possibly_nested_cannot?(*args)
      cannot?(*args) or nested_cannot?(*args)
    end

  end
end
