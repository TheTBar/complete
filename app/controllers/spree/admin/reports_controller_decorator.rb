module Spree
  module Admin
    ReportsController.class_eval do

      def abandoned_carts

        params[:q] = {} unless params[:q]

        if params[:q][:created_at_gt].blank?
          params[:q][:created_at_gt] = Time.zone.now.beginning_of_month
        else
          params[:q][:created_at_gt] = Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
        end

        if params[:q] && !params[:q][:completed_at_lt].blank?
          params[:q][:created_at_lt] = Time.zone.parse(params[:q][:created_at_lt]).end_of_day rescue ""
        end

        params[:q][:s] ||= "created_at desc"

        @search = Order.where.not(state: 'complete').ransack(params[:q])

        @total_abandoned_carts = @search.result
        @total_no_user = @total_abandoned_carts.where(state: 'cart')
        @total_no_address =  @total_abandoned_carts.where(state: 'address')
        @total_no_delivery =  @total_abandoned_carts.where(state: 'delivery')
        @total_no_payment = @total_abandoned_carts.where(state: 'payment')
        @total_no_confirm = @total_abandoned_carts.where(state: 'confirm')
      end

      def inventory_totals
        sql = "select z.name, z.count_on_hand, z.cost_price, (z.count_on_hand * z.cost_price) as total_value FROM (select a.name, sum(c.count_on_hand) as count_on_hand, max(b.cost_price) as cost_price from spree_products a JOIN spree_variants b ON a.id = b.product_id JOIN spree_stock_items c ON b.id = c.variant_id WHERE a.deleted_at IS NULL group by a.name ) z ORDER BY z.name "

        @total_inventory_amounts_by_product = Spree::Product.find_by_sql(sql);


        sql2 = "select 'total inventory value', sum(z.count_on_hand * z.cost_price) FROM (select a.name, sum(c.count_on_hand) as count_on_hand, max(b.cost_price) as cost_price from spree_products a JOIN spree_variants b ON a.id = b.product_id JOIN spree_stock_items c ON b.id = c.variant_id WHERE a.deleted_at IS NULL group by a.name ) z"

        @total_inventory_capital = Spree::Product.find_by_sql(sql2)


      end

      def sales_total
        params[:q] = {} unless params[:q]

        if params[:q][:completed_at_gt].blank?
          params[:q][:completed_at_gt] = Time.zone.now.beginning_of_month
        else
          params[:q][:completed_at_gt] = Time.zone.parse(params[:q][:completed_at_gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
        end

        if params[:q] && !params[:q][:completed_at_lt].blank?
          params[:q][:completed_at_lt] = Time.zone.parse(params[:q][:completed_at_lt]).end_of_day rescue ""
        end

        params[:q][:s] ||= "completed_at desc"

        @search = Order.complete.ransack(params[:q])
        @orders = @search.result

        @totals = {}
        @cost = 0
        @taxes = Hash.new(0)
        @shipping = 0
        @orders.each do |order|
          @totals[order.currency] = { :item_total => ::Money.new(0, order.currency),:cost_total => ::Money.new(0, order.currency),:shipping_total => ::Money.new(0, order.currency), :adjustment_total => ::Money.new(0, order.currency), :sales_total => ::Money.new(0, order.currency) } unless @totals[order.currency]
          @totals[order.currency][:item_total] += order.display_item_total.money
          @totals[order.currency][:adjustment_total] += order.display_adjustment_total.money
          @shipping += order.shipment_total
          Spree::Adjustment.where(:order_id => order.id).each do |adjustment|
            @taxes[adjustment.label.to_s] += adjustment.amount
          end
          order.line_items.each do |li|
            @cost += (li.product.master.cost_price*li.quantity) if li.product.master.cost_price
          end
          #@cost += order.line_items.inject(0) { |cost, li| cost + (li.variant.cost_price.to_f)*li.quantity }
          @totals[order.currency][:sales_total] += order.display_total.money
        end
        # Rails.logger.debug("HERE I AM: #{@taxes.inspect}")
        # Rails.logger.debug("totals: #{@totals.inspect}")
      end
    end
  end
end
