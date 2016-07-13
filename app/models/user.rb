class User < ApplicationRecord
  has_many :owned_albums, dependent: :nullify, class_name: 'Album', foreign_key: :owner_id, inverse_of: :owner
  has_many :comments, dependent: :nullify, foreign_key: :author_id, inverse_of: :author

  validates :display_name, presence: true, uniqueness: true, length: {within: 3..30}
  validates :username, presence: true, uniqueness: true, length: {within: 3..255}

  valid_password_range = 2..1_000
  validates :password, confirmation: true
  validates :password, presence: true, length: {in: valid_password_range}, on: :create
  validates :password, length: {in: valid_password_range}, allow_blank: true, on: :update

  before_save :hash_password

  attr_accessor :password, :password_confirmation


  private

  def hash_password
    if password.present?
      self.passhash = TWG4::Crypt.hash_password(password)
      self.password = self.password_confirmation = nil
    end
  end
end
