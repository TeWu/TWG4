module CrudLinksHelper

  def show_link(object, content = "Show")
    link_to(content, object) if soft_can? :show, object
  end

  def create_link(object, content = nil)
    if soft_can? :new, object
      model, super_model = object.is_a?(Array) ? object.reverse : object
      model_class = model.is_a?(Class) ? model : model.class
      content = "New #{model_class.name.humanize}" if content.blank?
      link_to(content, [:new, super_model, model_class.name.underscore.to_sym].compact)
    end
  end

  def edit_link(object, content = "Edit")
    link_to(content, [:edit, object].flatten) if soft_can? :edit, object
  end

  def destroy_button(object, **options, &block)
    if object.class == String or soft_can? :destroy, object
      content = options.delete(:content) || "Destroy"
      defaults = {method: :delete, data: {confirm: "Are you sure?"}, class: :destroy_button, form: {class: :destroy_button_form}}
      if block_given?
        button_to(object, defaults.deep_merge(options)) { yield block }
      else
        button_to(content, object, defaults.deep_merge(options))
      end
    end
  end

end
