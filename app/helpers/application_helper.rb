module ApplicationHelper

  def twg4
    "TWG<sup>4</sup>".html_safe
  end

  def glyphicon(name, **html_options)
    css_class = [html_options.delete(:class), "glyphicon", "glyphicon-#{name}"].compact * " "
    content_tag(:span, html_options.merge!(class: css_class)) {}
  end

end
