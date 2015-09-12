class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :set_auth_cookie
  helper_method :assign_babe


  def set_auth_cookie
    Rails.logger.debug "WE ARE TESTING THE user_signed_in? in application helperr***************************"
    if spree_user_signed_in?
      Rails.logger.debug "WE ARE SETTING THE COOKIE in application helperr***************************"
      cookies[:logged_in] = 'true'
    end
  end

  def assign_babe
    Rails.logger.debug ("checking if user is signed in")
    if spree_user_signed_in?
      Rails.logger.debug ("user is signed in, does session key exist for babe")
      if session.key?(:babe_id)
        Rails.logger.debug "we have the babe"
        babe = Spree::Babe.find(session[:babe_id])
        babe.spree_user_id = spree_current_user.id
        babe.save
      end
    end
  end

end
