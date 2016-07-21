module ApplicationHelper

  def show_link(object, content = "Show")
    link_to(content, object) if possibly_nested_can? :show, object
  end

  def create_link(object, content = nil)
    if possibly_nested_can? :new, object
      model, super_model = object.is_a?(Array) ? object.reverse : object
      model_class = model.is_a?(Class) ? model : model.class
      content = "New #{model_class.name.humanize}" if content.blank?
      link_to(content, [:new, super_model, model_class.name.underscore.to_sym].compact)
    end
  end

  def edit_link(object, content = "Edit")
    link_to(content, [:edit, object].flatten) if possibly_nested_can? :edit, object
  end

  def destroy_link(object, content = "Destroy")
    link_to(content, object, method: :delete, data: {confirm: "Are you sure?"}) if possibly_nested_can? :destroy, object
  end


  def field_set(title = nil, &block)
    render partial: 'field_set', locals: {title: title, content: capture(&block)}
  end


  private

  def possibly_nested_can?(*args)
    can?(*args) or nested_can?(*args)
  end

  def possibly_nested_cannot?(*args)
    cannot?(*args) or nested_cannot?(*args)
  end

  def nested_can?(action, nested_subject, *extra_args)
    !!if nested_subject.is_a? Array and nested_subject.length == 2
        can? action, [nested_subject].to_h, extra_args
      end
  end

  def nested_cannot?(*args)
    !nested_can?(*args)
  end

end
