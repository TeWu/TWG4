module FormsHelper

  def field_set(title = nil, **html_options, &block)
    render partial: 'field_set', locals: {title: title, html_options: html_options, content: capture(&block)}
  end

end
