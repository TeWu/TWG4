class Ability < BaseAbility
  protected

  def logged_in(user)
  end

  def active(user)
    can :read, :all
    can :modify, Comment, author_id: user.id
  end

  def moderator(user)
    active(user)
    can :manage, Comment
  end

  def admin(*)
    can :manage, :all
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
        :crud => %i[ create read update destroy ]
    }
  end

  ### Subject groups ###
  def main_models
    @main_models ||= [Album, Photo, Comment]
  end

end
