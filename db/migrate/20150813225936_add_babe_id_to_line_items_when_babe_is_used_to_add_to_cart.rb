class AddBabeIdToLineItemsWhenBabeIsUsedToAddToCart < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :babe_id, :integer, default: nil
  end
end
