module Spree
  UserSessionsController.class_eval do

    after_action :set_auth_cookie, only: [:create,:new]
    after_action :destroy_auth_cookie, only: [:destroy]
    after_action :assign_babe, only: [:create]

    def destroy_auth_cookie
      Rails.logger.debug "WE ARE DESTROYING THE COOKIE ***************************"
      cookies.delete :logged_in
    end


  end
end