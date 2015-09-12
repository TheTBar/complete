module Spree
  OmniauthCallbacksController.class_eval do

    after_action :set_auth_cookie, only: [:facebook]
    after_action :assign_babe, only: [:facebook]

  end
end
