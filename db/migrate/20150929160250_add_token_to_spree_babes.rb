class AddTokenToSpreeBabes < ActiveRecord::Migration
  def change
    add_column :spree_babes, :guest_token, :string
    add_index :spree_babes, :guest_token
  end
end
