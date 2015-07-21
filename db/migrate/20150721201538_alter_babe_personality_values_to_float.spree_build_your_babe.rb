# This migration comes from spree_build_your_babe (originally 20150721143329)
class AlterBabePersonalityValuesToFloat < ActiveRecord::Migration
  def change
    change_column :spree_babes, :vixen_value, :float
    change_column :spree_babes, :flirt_value, :float
    change_column :spree_babes, :romantic_value, :float
    change_column :spree_babes, :sophisticate_value, :float
  end
end
