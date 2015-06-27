# This migration comes from spree_product_packages (originally 20150623215311)
# This migration comes from spree_build_your_babe (originally 20150623200406)
class AddIsPackageNodeToTaxon < ActiveRecord::Migration
  def change
    add_column :spree_taxons, :is_package_node, :boolean, default: false
  end
end
