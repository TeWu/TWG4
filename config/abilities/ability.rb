class Ability < BaseAbility
  protected

  def logged_in(user)
  end

  def active(user)
    logged_in(user)
    can :read, Album
    can :read, Photo
    can :modify, Comment, author_id: user.id
    can :add_existing_photo, Album
    can :remove_photo, Album
  end

  def moderator(user)
    active(user)
    can :manage, Comment
    can :add_photo, Album
    can :remove_photo, Album
  end

  def admin(*)
    can :manage, main_models
  end

  def super_admin(*)
    can :manage, :all
  end


  ### Action aliases ###
  def action_aliases
    {
        :read => %i[ index show ],
        :create => %i[ new show ],
        :update => %i[ edit show ],
        :modify => %i[ update destroy ],
        :crud => %i[ create read update destroy ],

        :add_photo => [:add_new_photo, :add_existing_photo]
    }
  end

  ### Subject groups ###
  def main_models
    @main_models ||= [Album, Photo, Comment]
  end

end
