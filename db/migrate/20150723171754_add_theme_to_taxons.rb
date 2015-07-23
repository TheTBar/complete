class AddThemeToTaxons < ActiveRecord::Migration
  def change
    add_column :spree_taxons, :theme_taxon_id, :integer, default: nil
  end
end
