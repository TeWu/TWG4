module ApplicationHelper

  def edit_link(object, content = "Edit")
    link_to(content, [:edit, object].flatten) # if can?(:edit, object)
  end

  def destroy_link(object, content = "Destroy")
    link_to(content, object, method: :delete, data: {confirm: "Are you sure?"}) # if can?(:destroy, object)
  end

  def field_set(title = nil, &block)
    render partial: 'field_set', locals: {title: title, content: capture(&block)}
  end

end
