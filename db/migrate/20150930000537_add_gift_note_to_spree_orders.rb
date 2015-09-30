class AddGiftNoteToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :gift_note, :string
  end
end
