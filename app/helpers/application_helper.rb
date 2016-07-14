module ApplicationHelper

  def field_set(title = nil, &block)
    render partial: 'field_set', locals: {title: title, content: capture(&block)}
  end

end
