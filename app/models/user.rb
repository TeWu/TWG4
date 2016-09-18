class User < ApplicationRecord
  include URLSegmentSupport[:display_name]

  has_many :owned_albums, dependent: :nullify, class_name: 'Album', foreign_key: :owner_id, inverse_of: :owner
  has_many :owned_photos, dependent: :nullify, class_name: 'Photo', foreign_key: :owner_id, inverse_of: :owner
  has_many :comments, dependent: :nullify, foreign_key: :author_id, inverse_of: :author

  validates :display_name, presence: true, uniqueness: true, length: {within: 3..30}
  validates :username, presence: true, uniqueness: true, length: {within: 3..255}

  valid_password_range = 2..1_000
  validates :password, confirmation: true
  validates :password, presence: true, length: {in: valid_password_range}, on: :create
  validates :password, length: {in: valid_password_range}, allow_blank: true, on: :update

  before_save :hash_password
  before_save { self.is_admin = is_admin }

  serialize :roles_bitmask, TWG4::Serializers::RolesBitmaskSerializer

  attr_accessor :password, :password_confirmation
  alias_attribute :roles, :roles_bitmask


  def self.authenticate(username, password)
    user = find_by username: username
    return user if user && TWG4::Crypt.verify_password(password, user.passhash)
    return nil
  end

  def self.guest_ability
    @guest_ability ||= Ability.new(nil)
  end

  def ability
    @ability ||= Ability.new(self)
  end
  delegate :can?, :cannot?, to: :ability

  def has_role?(role)
    roles.include? role.to_s
  end

  def has_any_role?(*roles)
    return self.roles.any? if roles.empty?
    roles = roles.flatten.map(&:to_s)
    (self.roles || []).any? { |role| role.in? roles }
  end

  def is_admin
    has_any_role?(Ability::ADMIN_ROLES)
  end
  alias_method :is_admin?, :is_admin

  def roles_string
    roles.each(&:to_s) * ", "
  end


  private

  def hash_password
    if password.present?
      self.passhash = TWG4::Crypt.hash_password(password)
      self.password = self.password_confirmation = nil
    end
  end


  # Fix for ActiveModel::Dirty bug causing it to not work well with serialized attributes (e.g. "user.roles << :active; user.changed?" => false) #TODO: Fix it better
  after_find { @roles_bitmask_after_find = roles_bitmask.clone }
  after_commit { @roles_bitmask_after_find = roles_bitmask.clone }
  before_update { roles_bitmask_will_change! unless @roles_bitmask_after_find == roles_bitmask }

end
