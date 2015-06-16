# This migration comes from spree_simple_tax_by_zip (originally 20150615123505)
class AddZipCodesToSpreeTaxRates < ActiveRecord::Migration
  def change
    add_column :spree_tax_rates, :zip_codes, :string
  end
end
