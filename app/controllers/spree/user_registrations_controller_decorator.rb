module Spree
  UserRegistrationsController.class_eval do

    after_action :set_auth_cookie, only: [:create]
    after_action :assign_babe, only: [:create]

  end
end