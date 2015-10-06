class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :set_auth_cookie
  helper_method :assign_babe


  def set_auth_cookie
    if spree_user_signed_in?
      cookies[:logged_in] = 'true'
    end
  end

  def assign_babe
    if spree_user_signed_in?
      #need to do both in case they have cookies turned off
      if session.key?(:babe_id)
        babe = Spree::Babe.find(session[:babe_id])
        babe.spree_user_id = spree_current_user.id
        babe.save
      end
      if cookies.signed[:guest_token].present?
        Spree::Babe.where(:spree_user_id => 1).where(:guest_token => cookies.signed[:guest_token]).each do |babe|
          babe.spree_user_id = spree_current_user.id
          babe.save
        end
      end
    end
  end

end
