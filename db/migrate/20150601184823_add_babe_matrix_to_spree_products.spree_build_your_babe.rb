class AddBabeMatrixToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :vixen_value, :int
    add_column :spree_products, :romantic_value, :int
    add_column :spree_products, :flirt_value, :int
    add_column :spree_products, :sophisticate_value, :int
  end
end
