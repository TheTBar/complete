# This migration comes from spree_build_your_babe (originally 20150721180903)
class AlterSpreeBabePersonalityValuesPrecisionTwo < ActiveRecord::Migration
  def change
    change_column :spree_babes, :vixen_value, :decimal, precision: 4, scale: 2
    change_column :spree_babes, :flirt_value, :decimal, precision: 4, scale: 2
    change_column :spree_babes, :romantic_value, :decimal, precision: 4, scale: 2
    change_column :spree_babes, :sophisticate_value, :decimal, precision: 4, scale: 2
  end
end
