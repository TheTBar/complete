class CreateSpreeBabeProductSearchFailures < ActiveRecord::Migration
  def change
    create_table :spree_babe_product_search_failures do |t|
      t.references :spree_user, index: true
      t.references :spree_babe, index: true
      t.integer :number_of_packages_returned
      t.timestamps :created_time
    end
  end
end
