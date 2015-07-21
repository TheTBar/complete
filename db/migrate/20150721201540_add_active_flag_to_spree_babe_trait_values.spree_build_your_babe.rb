# This migration comes from spree_build_your_babe (originally 20150721164435)
class AddActiveFlagToSpreeBabeTraitValues < ActiveRecord::Migration
  def change
    add_column :spree_babe_trait_values, :active, :boolean, default: true
  end
end
