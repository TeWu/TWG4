module ApplicationHelper

  def show_link(object, content = "Show")
    link_to(content, object) if can?(:show, object)
  end

  def create_link(object, content = nil)
    if can?(:new, object)
      object_class = (object.kind_of?(Class) ? object : object.class)
      content = "New #{object_class.name.humanize}" if content.blank?
      link_to(content, [:new, object_class.name.underscore.to_sym])
    end
  end

  def edit_link(object, content = "Edit")
    link_to(content, [:edit, object].flatten) if can?(:edit, object)
  end

  def destroy_link(object, content = "Destroy")
    link_to(content, object, method: :delete, data: {confirm: "Are you sure?"}) if can?(:destroy, object)
  end


  def field_set(title = nil, &block)
    render partial: 'field_set', locals: {title: title, content: capture(&block)}
  end

end
