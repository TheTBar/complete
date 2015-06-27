# This migration comes from spree_product_packages (originally 20150625173127)
class AddShowProductsBooleanToTaxons < ActiveRecord::Migration
  def change
      add_column :spree_taxons, :show_products, :boolean, default: false
  end
end
