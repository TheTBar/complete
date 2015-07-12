# This migration comes from spree_build_your_babe (originally 20150704153208)
class AddNumberSizeToSpreeBabes < ActiveRecord::Migration
  def change
    add_column :spree_babes, :number_size, :string
  end
end
