class AddShowInMainProductSearchBooleanToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :show_in_main_search, :boolean, default: true
  end
end
