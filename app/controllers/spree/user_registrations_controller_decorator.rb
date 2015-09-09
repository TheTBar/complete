module Spree
  UserRegistrationsController.class_eval do

    after_action :set_auth_cookie, only: [:create]

    def set_auth_cookie
      Rails.logger.debug "WE ARE SETTING THE COOKIE UserRegistrationsController***************************"
      if spree_user_signed_in?
        cookies[:logged_in] = 'true'
      end
    end

  end
end