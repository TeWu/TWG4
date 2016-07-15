module TWG4
  module Crypt
    class << self
      def hash_password(password)
        Argon2::Password.new(t_cost: 2, m_cost: 16).create(password)
      end

      def verify_password(password, secure_password)
        Argon2::Password.verify_password(password, secure_password)
      end
    end
  end
end
