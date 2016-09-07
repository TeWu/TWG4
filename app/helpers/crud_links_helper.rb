module CrudLinksHelper

  def show_link(object, content = "Show", **options, &block)
    if soft_can? :show, object
      if block_given?
        link_to(object, options) { yield block }
      else
        link_to(content, object, options)
      end
    end
  end

  def create_link(object, content = nil, **options, &block)
    if options.delete(:skip_auth_check) or soft_can? :new, object
      location = options.delete :location
      defaults = {role: 'button', class: "btn btn-create #{options[:add_class]}".strip}
      html_options = defaults.deep_merge(options)

      model, super_model = object.is_a?(Array) ? object.reverse : object
      content = "New #{model.model_name.human.downcase}" if content.blank?
      location_array = [:new, super_model, model.model_name.element.to_sym].compact

      if block_given?
        link_to(location || location_array, html_options) { yield block }
      else
        link_to(content, location || location_array, html_options)
      end
    end
  end

  def edit_link(object, content = nil, **options, &block)
    if options.delete(:skip_auth_check) or soft_can? :edit, object
      content = "Edit" if content.blank?
      defaults = {role: 'button', class: "btn btn-edit #{options[:add_class]}".strip}
      location = options.delete :location
      if block_given?
        link_to(location || [:edit, object].flatten, defaults.deep_merge!(options)) { yield block }
      else
        link_to(content, location || [:edit, object].flatten, defaults.deep_merge!(options))
      end
    end
  end

  def destroy_button(object, content = nil, **options, &block)
    if object.class == String or soft_can? :destroy, object
      confirm_msg = "Are you sure?"
      unless content
        maybe_resource_human_name = suppress(Exception) { (object.is_a?(Array) ? object.last : object).model_name.human.downcase }
        content = "Delete #{maybe_resource_human_name}".strip
        confirm_msg = "Are you sure you want to #{content.downcase}?" if maybe_resource_human_name
      end
      defaults = {method: :delete, data: {confirm: confirm_msg}, class: "btn btn-destroy #{options[:add_class]}".strip, form: {class: :single_button_form}}
      button_to(object, defaults.deep_merge!(options)) do
        block_given? ? yield : icon_label('trash', content)
      end
    end
  end

end
