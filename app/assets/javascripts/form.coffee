$(document).on 'shown.bs.modal', ->
  $(ClientSideValidations.selectors.forms).validate();
