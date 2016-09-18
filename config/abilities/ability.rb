class Ability < BaseAbility
  GRANTING_ACTIONS = [:assign_all_roles, :assign_nongranting_roles]
  ADMIN_ROLES = [:admin, :super_admin]

  self.precondition = -> (user) { user.has_role?(:active) }

  protected

  def logged_in user
    can [:read, :create], main_models
    can :modify, Album, owner: user
    can :modify, Photo, owner: user
    can :modify, Comment, author: user
    can [:show, :update], User, id: user.id
  end

  def active user
  end

  def moderator
    can :modify, Comment, author: {is_admin: false}
    can :modify, Comment, author: nil
  end

  def admin(*)
    can :read, User
    can :modify, Album, owner: nil
    can :modify, Album, owner: {is_admin: false}
    can :modify, Photo, owner: nil
    can :modify, Photo, owner: {is_admin: false}
    can [:create, :modify], User, is_admin: false
    can :assign_nongranting_roles, User
  end

  def super_admin(*)
    can :manage, :all
  end


  ### Action aliases ###
  def action_aliases
    {
        :read => %i[ index show ],
        :create => :new,
        :update => :edit,
        :delete => :destroy,
        :add_photo => [:add_new_photo, :add_existing_photo],
        :modify => %i[ update destroy add_photo remove_photo destroy_photo ]
    }
  end

  ### Subject groups ###
  def main_models
    @main_models ||= [Album, Photo, Comment]
  end

end
