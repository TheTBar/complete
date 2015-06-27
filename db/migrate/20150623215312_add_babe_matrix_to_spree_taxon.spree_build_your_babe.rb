# This migration comes from spree_build_your_babe (originally 20150623200434)
class AddBabeMatrixToSpreeTaxon < ActiveRecord::Migration
  def change
    add_column :spree_taxons, :vixen_value, :int
    add_column :spree_taxons, :romantic_value, :int
    add_column :spree_taxons, :flirt_value, :int
    add_column :spree_taxons, :sophisticate_value, :int
  end
end
