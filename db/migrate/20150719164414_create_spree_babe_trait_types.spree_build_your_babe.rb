# This migration comes from spree_build_your_babe (originally 20150719160813)
class CreateSpreeBabeTraitTypes < ActiveRecord::Migration
  def change
    create_table :spree_babe_trait_types do |t|
      t.string :name
      t.timestamps
    end
  end
end
