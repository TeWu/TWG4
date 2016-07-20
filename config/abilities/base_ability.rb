class BaseAbility
  include CanCan::Ability

  def initialize(user)
    create_action_aliases
    user ? draw(user) : draw_guest
  end


  protected

  def draw(user)
    logged_in(user)
    for role in user.roles
      self.send(role, user)
    end
  end

  def draw_guest; end

  def create_action_aliases
    clear_aliased_actions
    alias_actions(action_aliases)
  end

  def action_aliases; end


  # Allow hash style aliases, like: alias_action :modify => [:update, :destroy]
  # which is the same as:           alias_action :update, :destroy, to: :modify
  def alias_action(*args)
    return super(*args) if args.length > 1
    to, from = args[0].first
    super(*from, to: to)
  end

  def alias_actions(aliases)
    aliases.each { |from, to| alias_action from => to }
  end


  def banned_actions
    # Format = 'action_name: "Reason to ban"'
    {
        new: "It doesn't make sense to allow :new, but deny :create - use :create instead of :new",
        edit: "It doesn't make sense to allow :edit but deny :update - use :update instead of :edit"
    }
  end

  def can(action = nil, *args)
    msg = banned_actions[action.to_sym]
    raise "Action :#{action} is banned; you can't use it when defining abilities. Reason: #{msg}." if msg
    super(action, *args)
  end

end
