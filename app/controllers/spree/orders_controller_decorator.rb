module Spree
  OrdersController.class_eval do

    before_action :set_redirect_back, only: [:populate,:populate_from_package]

    def set_redirect_back
      session["spree_user_return_to"] = :back
    end

  end
end
