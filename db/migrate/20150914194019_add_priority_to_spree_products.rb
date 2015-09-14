class AddPriorityToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :priority, :int
  end
end
