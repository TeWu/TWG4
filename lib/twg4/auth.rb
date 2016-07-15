module TWG4
  class Auth
    COOKIE_NAME = 'armt3'
    COOKIE_VALIDITY_PERIOD_COOKIE = 2663810.seconds # Random number
    COOKIE_VALIDITY_PERIOD_AUTH = 3004475.seconds # _DIFFERENT_ random number, but close to the first one (within few days)
    CURRENT_USER_ID_KEY = 'user_id'
    VALID_TO_KEY = 'valid_to'


    def initialize(cookies)
      @cookies = cookies
    end

    def login_user(user)
      self.current_user_id = user.id
    end

    def cookie
      @cookies.encrypted[COOKIE_NAME] || {}
    end

    def current_user_id
      cookie[CURRENT_USER_ID_KEY]
    end

    def current_user_id=(id)
      @cookies.encrypted[COOKIE_NAME] = {
          value: cookie.merge(
              CURRENT_USER_ID_KEY => id,
              VALID_TO_KEY => COOKIE_VALIDITY_PERIOD_AUTH.from_now
          ),
          expires: COOKIE_VALIDITY_PERIOD_COOKIE.from_now
      }
    end

    def delete_cookie
      @cookies.delete(COOKIE_NAME)
    end
    alias_method :logout_current_user, :delete_cookie

  end
end
