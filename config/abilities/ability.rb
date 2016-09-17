class Ability < BaseAbility
  GRANTING_ACTIONS = [:assign_all_roles, :assign_nongranting_roles]
  protected

  def logged_in user
    can :read, main_models
  end

  def active user
    can :create, main_models
    can :modify, Album, owner: user
    can :modify, Photo, owner: user
    can :modify, Comment, author: user
    can [:show, :update], User, id: user.id
  end

  def moderator
    active user
    can :manage, Comment
  end

  def admin(*)
    can :manage, main_models + [User]
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
        :modify => %i[ update destroy add_new_photo add_existing_photo remove_photo destroy_photo ],

        :add_photo => [:add_new_photo, :add_existing_photo]
    }
  end

  ### Subject groups ###
  def main_models
    @main_models ||= [Album, Photo, Comment]
  end

end
