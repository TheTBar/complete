# This migration comes from spree_build_your_babe (originally 20150719160825)
class CreateSpreeBabeTraitValues < ActiveRecord::Migration
  def change
    create_table :spree_babe_trait_values do |t|
      t.references :babe_trait_type, index: true
      t.string :name
      t.integer :vixen_value
      t.integer :flirt_value
      t.integer :romantic_value
      t.integer :sophisticate_value
      t.timestamps
    end
  end
end
