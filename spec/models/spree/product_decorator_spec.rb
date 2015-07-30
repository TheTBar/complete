require 'rails_helper'

describe Spree::Product, :type => :model do


  context "product has sizes" do

    def build_option_type_with_values(name, values)
      ot = create(:option_type, :name => name)
      values.each do |val|
        ot.option_values.create(:name => val.downcase, :presentation => val)
      end
      ot
    end

    let(:bottom_option_type) do
      build_option_type_with_values("Named Sizes", %w(Small))
    end

    let(:bra_option_type) do
      build_option_type_with_values("Bra Sizes", %w(34A))
    end

    let(:product1) { create(:product, name: 'product1', vixen_value: 5, flirt_value: 3, sophisticate_value: 1, romantic_value:1, option_values_hash: {bra_option_type.id.to_s => bra_option_type.option_value_ids}) }
    let(:product1b) { create(:product, name: 'product1b', vixen_value: 5, flirt_value: 3, sophisticate_value: 1, romantic_value:1, option_values_hash: {bottom_option_type.id.to_s => bottom_option_type.option_value_ids}) }

    it "should return the size type of the product" do
      expect(product1.product_size_type).to eq 'Bra Sizes'
    end

  end

  context "Product Becomes Part Of Package" do

    let!(:taxonomy) { create(:taxonomy, name: 'sets')}


    it "should set the personality values of its parent taxon package" do

      taxon = create(:taxon, name: 'first package', is_package_node: true, parent_id: Spree::Taxon.find_by_name('sets').id)
      product = create(:product)

      product.taxons << taxon
      product.vixen_value = 5;
      product.flirt_value = 4;
      product.sophisticate_value = 3;
      product.romantic_value = 2;
      product.save

      taxon_after = Spree::Taxon.last
      expect(taxon_after.vixen_value).to eq(5)
      expect(taxon_after.flirt_value).to eq(4)
      expect(taxon_after.sophisticate_value).to eq(3)
      expect(taxon_after.romantic_value).to eq(2)

      parent_taxon = Spree::Taxon.find(taxon_after.parent_id)
      expect(parent_taxon.vixen_value).to eq 0

    end

  end

end
