module Spree
  module Admin
    ReportsController.class_eval do

      def abandoned_carts

        params[:q] = {} unless params[:q]

        if params[:q][:updated_at_gt].blank?
          params[:q][:updated_at_gt] = Time.zone.now.beginning_of_month
        else
          params[:q][:updated_at_gt] = Time.zone.parse(params[:q][:updated_at_gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
        end

        if params[:q] && !params[:q][:completed_at_lt].blank?
          params[:q][:updated_at_lt] = Time.zone.parse(params[:q][:updated_at_lt]).end_of_day rescue ""
        end

        params[:q][:s] ||= "updated_at desc"

        @search = Order.where.not(state: 'complete').ransack(params[:q])

        @total_abandoned_carts = @search.result
        @total_no_user = @total_abandoned_carts.where(state: 'cart')
        @total_no_address =  @total_abandoned_carts.where(state: 'address')
        @total_no_delivery =  @total_abandoned_carts.where(state: 'delivery')
        @total_no_payment = @total_abandoned_carts.where(state: 'payment')
        @total_no_confirm = @total_abandoned_carts.where(state: 'confirm')
      end
    end
  end
end
