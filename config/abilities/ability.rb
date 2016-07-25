class Ability < BaseAbility
  protected

  def logged_in user
    can :read, main_models
  end

  def active user
    can :create, [Album, Comment]
    can :create, Photo, album: {owner: user}
    can :modify, Album, owner: user
    can :modify, Comment, author: user
  end

  def moderator
    active user
    can :manage, Comment
  end

  def admin(*)
    can :manage, main_models
    can :manage, User
    cannot :destroy, :all
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
        :modify => %i[ update destroy add_photo remove_photo ],
        :crud => %i[ create read update destroy ],
    }
  end

  ### Subject groups ###
  def main_models
    @main_models ||= [Album, Photo, Comment]
  end

end
