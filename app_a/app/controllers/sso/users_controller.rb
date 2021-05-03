module Sso
  class UsersController < Api::ApiController
    before_action :authorization_for_profile!, only: :profile

    def userinfo
      introspection = ::HydraService.instance.introspect_token(access_token)
      
      info = {
        sub: introspection.sub
      }
      if introspection.scope.include?('email')
        info.update(
          email: current_user.email
        )
      end

      render json: info.deep_stringify_keys
    end
    
    private

    def authorization_for_profile!
      authorization!('profile')
    end
  end
end
