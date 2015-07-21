# This migration comes from spree_build_your_babe (originally 20150721164025)
class AddActiveFlagToSpreeBabeTraitType < ActiveRecord::Migration
  def change
    add_column :spree_babe_trait_types, :active, :boolean, default: true
  end
end
