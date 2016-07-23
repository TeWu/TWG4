module AuthorizationHelper

  # This method can be more permissive than +can?+ and +nested_can?+, but allow
  # +subject+ to be Array, representing deeply nested model. Correctness of
  # nesting is not checked, and this method can be too permissive if Array
  # don't represent properly nested model e.g. when:
  #   +subject+ is [@project, @task, @subtask] AND
  #   @subtask.task != @task OR @task.project != @project.
  # WARNING: Don't use this in controllers! Use only as view layer security.
  def soft_can?(action, subject)
    possibly_nested_can? action, minimize_possible_nesting(subject)
  end

  def minimize_possible_nesting(nested_subject)
    *nesting, subject = nested_subject
    return [nesting.last, subject] if nesting.present? and nesting.none? { |s| s.is_a? Module }
    nested_subject
  end

end
