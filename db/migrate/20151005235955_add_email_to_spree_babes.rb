class AddEmailToSpreeBabes < ActiveRecord::Migration
  def change
    add_column :spree_babes, :guest_email, :string
  end
end
