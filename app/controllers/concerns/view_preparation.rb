module ViewPreparation
  extend ActiveSupport::Concern

  included do

    def prepare_and_render_view(view)
      if view.is_a? String and view.include? '/'
        c, action = view.split '/'
        controller = "#{c.capitalize}Controller".constantize
      end
      controller ||= self.class
      action ||= view

      controller.send("prepare_#{action.to_s}_view", self)
      render view
    end

  end

  class_methods do

    def view_preparation(action, &block)
      define_singleton_method "prepare_#{action.to_s}_view" do |controller|
        controller.instance_eval &block
      end
    end

  end

end
