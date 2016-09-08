class DropdownMenuPresenter < BasePresenter

  def initialize(template, btn_icon_name, btn_text, menu_definition)
    super(template)
    @btn_icon_name, @btn_text, @menu_definition = btn_icon_name, btn_text, menu_definition
  end

  def elements
    @elements ||= begin
      @elements = []
      @menu_definition.each do |elem_def|
        @elements += [render_element(elem_def)].flatten.compact
      end
      @elements
    end
  end

  def render_element(elem_def)
    return nil unless elem_def.is_a? Hash
    if elem_def.has_key? :elem
      tag(:li) { elem_def[:elem] } if elem_def[:visible]
    else
      render_group_elements(elem_def)
    end
  end

  def render_group_elements(group_elem_defs)
    group_elem_defs.flat_map do |header, elem_defs|
      elems_in_group = elem_defs.map { |d| render_element(d) }
      if elems_in_group.any?
        [
            (tag(:li, class: 'divider', role: 'separator') if @elements.any?),
            tag(:li, class: 'dropdown-header') { header },
            *elems_in_group
        ]
      end
    end
  end

  def render
    if elements.any?
      h.render partial: 'dropdown_menu', locals: {
          dropdown_id: @btn_text.parameterize + "-btn",
          btn_label: icon_label(@btn_icon_name, @btn_text),
          elements: elements
      }
    end
  end

end
