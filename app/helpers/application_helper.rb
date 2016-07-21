module ApplicationHelper

  def edit_link(object, content = "Edit")
    link_to(content, [:edit, object].flatten) # if can?(:edit, object)
  end

  def destroy_button(object, content = "Destroy", **options)
    defaults = {method: :delete, data: {confirm: "Are you sure?"}, class: :destroy_button, form: {class: :destroy_button_form}}
    button_to(content, object, defaults.deep_merge(options)) # if can?(:destroy, object)
  end

  def field_set(title = nil, &block)
    render partial: 'field_set', locals: {title: title, content: capture(&block)}
  end

end
