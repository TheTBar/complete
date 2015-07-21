# This migration comes from spree_build_your_babe (originally 20150719175749)
class RenameBabeTraitTypeIdOnBabeTriatValue < ActiveRecord::Migration
  def change
    rename_column :spree_babe_trait_values, :babe_trait_type_id, :spree_babe_trait_type_id
  end
end
