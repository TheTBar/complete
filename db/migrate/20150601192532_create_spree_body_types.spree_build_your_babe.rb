# This migration comes from spree_build_your_babe (originally 20150525171703)
class CreateSpreeBodyTypes < ActiveRecord::Migration
  def change
    create_table :spree_body_types do |t|
      t.string :name
      t.timestamps
    end
  end
end
