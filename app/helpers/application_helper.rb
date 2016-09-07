module ApplicationHelper

  def twg4
    "TWG<sup>4</sup>".html_safe
  end

  def glyphicon(name, **html_options)
    css_class = [html_options.delete(:class), "glyphicon", "glyphicon-#{name}"].compact * " "
    content_tag(:span, html_options.merge!(class: css_class)) {}
  end

  def icon_label(icon_name, text, **options)
    icon_position = options.delete(:icon_position) || :left
    icon_html = options.delete(:icon_html) || {}
    html_options = options.merge!(
        class: ["icon-label-#{icon_position == :right ? 'r' : 'l'}", options[:class]].compact * " ",
    )
    icon_elem = glyphicon(icon_name, icon_html)
    content_tag(:span, html_options) do
      (icon_position == :right ? text + icon_elem : icon_elem + text).html_safe
    end
  end

end
