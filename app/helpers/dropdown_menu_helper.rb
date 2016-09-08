module DropdownMenuHelper

  def dropdown_menu(btn_icon_name, btn_text, menu_definition)
    DropdownMenuPresenter.new(self, btn_icon_name, btn_text, menu_definition).render
  end

end
