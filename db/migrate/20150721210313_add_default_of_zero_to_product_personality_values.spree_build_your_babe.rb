# This migration comes from spree_build_your_babe (originally 20150721204646)
class AddDefaultOfZeroToProductPersonalityValues < ActiveRecord::Migration
  def change
    change_column :spree_products, :vixen_value, :int, default: 0
    change_column :spree_products, :flirt_value, :int, default: 0
    change_column :spree_products, :romantic_value, :int, default: 0
    change_column :spree_products, :sophisticate_value, :int, default: 0
  end
end
