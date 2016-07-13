module TWG4
  module Crypt
    class << self
      def hash_password(password)
        Argon2::Password.new(t_cost: 2, m_cost: 16).create(password)
      end
    end
  end
end
