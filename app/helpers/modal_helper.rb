module ModalHelper

  def modal(id:, title:, primary_btn:, &block)
    render layout: 'modal', locals: {
        id: id,
        title: title,
        primary_btn: primary_btn
    }, &block
  end

  def modal_form(id:, title:, resource:, form_options: {}, primary_btn: {}, &block)
    render layout: 'modal_form', locals: {
        id: id,
        title: title,
        resource: resource,
        form_options: form_options,
        primary_btn: primary_btn
    }, &block
  end

  def dropdown_link_to_modal(content, **options, &block)
    options.deep_merge!(modal: {defer_output: true})
    link_to_modal(content, options, &block)
  end

  def link_to_modal(content, **options, &block)
    modal_options = options.delete(:modal) || {}
    modal_options[:id] ||= modal_options[:title].dup.downcase.gsub(/[\s_]/, '-') + "-modal"
    maybe_open_modal_script = modal_options.delete(:auto_open) ? open_modal_script(modal_options[:id]) : ""
    defer_modal_output = modal_options.delete(:defer_output)

    link_and_possibly_deferred_modal(
        link_to(content, "#" + modal_options[:id], 'data-toggle': "modal"),
        modal(modal_options, &block) + maybe_open_modal_script,
        defer_modal_output
    )
  end

  def dropdown_link_to_modal_form_for(object, content = nil, **options, &block)
    options.deep_merge!(class: "", modal: {defer_output: true})
    link_to_modal_form_for(object, content, options, &block)
  end

  def link_to_modal_form_for(object, content = nil, **options, &block)
    if soft_can? :new, object
      resource = object.is_a?(Array) ? object.last : object
      is_ar_resource = resource.is_a? ActiveRecord::Base
      modal_options = options.delete(:modal) || {}
      modal_options[:title] ||= (resource.persisted? ? "Edit " : "Create a new ") + resource.model_name.human.downcase if is_ar_resource
      modal_id = modal_options[:title].dup.downcase!.gsub!(/[\s_]/, '-') + "-modal"
      maybe_open_modal_script = modal_options.delete(:auto_open) ? open_modal_script(modal_id) : ""
      defer_modal_output = modal_options.delete(:defer_output)
      form_options = options.delete(:form) || {}
      options.reverse_merge!(location: "#" + modal_id, 'data-toggle': "modal", skip_auth_check: true)

      link_elem = if is_ar_resource
                    resource.persisted? ? edit_link(object, content, options, &block) : create_link(object, content, options, &block)
                  else
                    link_to(content, options[:location], options)
                  end
      link_and_possibly_deferred_modal(
          link_elem,
          modal_form(modal_options.merge(resource: object, id: modal_id, form_options: form_options)) do |f|
            field_set { is_ar_resource ? render("#{resource.model_name.plural}/inputs", f: f) : yield(f) }
          end + maybe_open_modal_script,
          defer_modal_output
      )
    end
  end

  def deferred_modals
    (@deferred_modals * "\n").html_safe.tap { @deferred_modals.clear } if @deferred_modals
  end

  # -------

  def open_modal_script(modal_id)
    javascript_tag "$('##{modal_id}').modal('show');"
  end

  def link_and_possibly_deferred_modal(link_elem, modal_elem, defer_modal_output)
    if defer_modal_output
      @deferred_modals ||= []
      @deferred_modals << modal_elem
      link_elem
    else
      link_elem + modal_elem
    end
  end

end
