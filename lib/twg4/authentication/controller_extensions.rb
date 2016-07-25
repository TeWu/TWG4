module TWG4
  module Authentication
    module ControllerExtensions
      extend ActiveSupport::Concern

      included do

        helper_method :current_user, :logged_in?


        protected

        def logged_in?
          not current_user.nil?
        end

        def current_user
          return @current_user if defined? @current_user # Checking 'if defined?' instead of using '||=', to be able to cache nil (for unauthenticated users)
          @current_user = begin
            id = authentication_proxy.current_user_id
            User.find_by(id: id) if id
          end
        end

        def current_user=(user)
          authentication_proxy.current_user_id = user.id
        end
        alias_method :set_current_user, :current_user=

        def logout_current_user
          authentication_proxy.delete_cookie
        end

        def reset_authentication
          remove_instance_variable :@current_user
          @authentication_proxy = nil
        end

        def authentication_proxy
          @authentication_proxy ||= TWG4::Authentication::AuthProxy.new(cookies)
        end

      end

    end
  end
end
