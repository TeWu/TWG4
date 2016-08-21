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

  def link_to_modal_create_form(object, content = nil, **options, &block)
    if soft_can? :new, object
      resource_name = (object.is_a?(Array) ? object.last : object).model_name
      modal_options = options.delete(:modal) || {}
      modal_options[:title] ||= "Create a new #{resource_name.human.downcase}"
      modal_id = modal_options[:title].dup.downcase!.gsub!(/[\s_]/, '-') + "-modal"
      maybe_open_modal_script = modal_options.delete(:auto_open) ? open_modal_script(modal_id) : ""
      defer_modal_output = modal_options.delete(:defer_output)
      form_options = options.delete(:form) || {}
      options.reverse_merge!(location: "#" + modal_id, 'data-toggle': "modal", skip_auth_check: true)

      link_and_possibly_deferred_modal(
          create_link(object, content, options, &block),
          modal_form(modal_options.merge(resource: object, id: modal_id, form_options: form_options)) do |f|
            field_set { render "#{resource_name.plural}/inputs", f: f }
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
