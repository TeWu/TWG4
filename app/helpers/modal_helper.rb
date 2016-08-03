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

end
