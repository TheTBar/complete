# This migration comes from spree_build_your_babe (originally 20150525171800)
class CreateSpreeBabes < ActiveRecord::Migration
  def change
    create_table :spree_babes do |t|
      t.references :spree_user, index: true, default: 1
      t.references :body_type
      t.string :name
      t.integer :height
      t.integer :band
      t.string :cup
      t.string :bottoms
      t.integer :vixen_value
      t.integer :romantic_value
      t.integer :flirt_value
      t.integer :sophisticate_value
      t.timestamps

    end
  end
end
