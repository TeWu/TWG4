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
      defaults = {class: "btn btn-create"}
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

  def link_to_modal_create_form(object, content = nil, **options, &block)
    if soft_can? :new, object
      resource_name = (object.is_a?(Array) ? object.last : object).model_name
      modal_options = options.delete(:modal) || {}
      modal_title = modal_options[:title] || "Create a new #{resource_name.human.downcase}"
      modal_id = modal_title.dup.downcase!.gsub!(/[\s_]/, '-') + "-modal"
      form_options = options.delete(:form) || {}
      options.reverse_merge!(location: "#" + modal_id, 'data-toggle': "modal", skip_auth_check: true)
      open_modal_script = modal_options[:auto_open] ? javascript_tag(%Q{$('##{modal_id}').modal('show');}) : ""

      modal_form(resource: object, id: modal_id, title: modal_title, form_options: form_options) do |f|
        field_set { render "#{resource_name.plural}/inputs", f: f }
      end + open_modal_script + create_link(object, content, options, &block)
    end
  end

  def edit_link(object, content = "Edit", **options, &block)
    if soft_can? :edit, object
      defaults = {role: 'button', class: 'btn btn-edit'}
      if block_given?
        link_to([:edit, object].flatten, defaults.deep_merge!(options)) { yield block }
      else
        link_to(content, [:edit, object].flatten, defaults.deep_merge!(options))
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
      defaults = {method: :delete, data: {confirm: confirm_msg}, class: 'btn btn-destroy', form: {class: :destroy_button_form}}
      if block_given?
        button_to(object, defaults.deep_merge!(options)) { yield block }
      else
        button_to(content, object, defaults.deep_merge!(options))
      end
    end
  end

end
