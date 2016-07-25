module NestedAuthorizationCheckers
  extend ActiveSupport::Concern

  included do
    helper_method :nested_can?, :nested_cannot?, :possibly_nested_can?, :possibly_nested_cannot?

    def nested_can?(action, nested_subject, *extra_args)
      !!if nested_subject.is_a? Array and nested_subject.length == 2
          parent, subject = nested_subject
          return false unless parent.is_a? ActiveRecord::Base
          if subject.is_a? Module
            can?(action, [nested_subject].to_h, extra_args)
          else
            can?(action, subject, extra_args) and parent == subject.send(parent.class.name.underscore.to_sym)
          end
        end
    end

    def nested_cannot?(*args)
      !nested_can?(*args)
    end

    def possibly_nested_can?(action, subject, *extra_args)
      args = [action, subject, *extra_args]
      if subject.is_a? Array
        nested_can?(*args) or can?(*args)
      else
        can?(*args) or nested_can?(*args)
      end
    end

    def possibly_nested_cannot?(*args)
      !possibly_nested_can?(*args)
    end

  end
end
