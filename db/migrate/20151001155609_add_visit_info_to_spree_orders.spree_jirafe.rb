# This migration comes from spree_jirafe (originally 20131204192804)
class AddVisitInfoToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :visit_id,         :integer, default: 0
    add_column :spree_orders, :visitor_id,       :integer, default: 0
    add_column :spree_orders, :pageview_id,      :integer, default: 0
    add_column :spree_orders, :last_pageview_id, :integer, default: 0
  end
end
