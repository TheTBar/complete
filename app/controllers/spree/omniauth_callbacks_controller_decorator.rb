module Spree
  OmniauthCallbacksController.class_eval do

    after_action :set_auth_cookie, only: [:facebook]

    def set_auth_cookie
      Rails.logger.debug "WE ARE SETTING THE COOKIE IN FACEBOOK LOGIN ***************************"
      if spree_user_signed_in?
        Rails.logger.debug "spree user signed in"
        cookies[:logged_in] = true
      else
        Rails.logger.debug "spree user NOT SIGNED in :( "
      end
    end
  end
end
