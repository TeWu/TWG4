module ModalHelper

  def modal(id:, title:, primary_btn:, &block)
    render layout: 'modal', locals: {
        id: id,
        title: title,
        primary_btn: primary_btn
    }, &block
  end

  def modal_form(id:, title:, resource:, form_options: {}, &block)
    render layout: 'modal_form', locals: {
        id: id,
        title: title,
        resource: resource,
        form_options: form_options
    }, &block
  end

  def link_to_modal(content, **options, &block)
    modal_options = options.delete(:modal) || {}
    modal_options[:id] ||= modal_options[:title].dup.downcase.gsub(/[\s_]/, '-') + "-modal"
    open_modal_script = modal_options.delete(:auto_open) ? javascript_tag(%Q{$('##{modal_options[:id]}').modal('show');}) : ""
    defer_modal_output = modal_options.delete(:defer_output)

    link_elem = link_to content, "#" + modal_options[:id], 'data-toggle': "modal"
    modal_elem = modal(modal_options, &block) + open_modal_script
    if defer_modal_output
      @deferred_modals ||= []
      @deferred_modals << modal_elem
      link_elem
    else
      link_elem + modal_elem
    end
  end

  def deferred_modals
    (@deferred_modals * "\n").html_safe.tap { @deferred_modals.clear } if @deferred_modals
  end

end
