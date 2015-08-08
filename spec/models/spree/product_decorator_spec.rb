require 'rails_helper'

describe Spree::Product, :type => :model do


  context "product has sizes" do

    let(:bottom_option_type) do
      build_option_type_with_values("Named Sizes", %w(Small Medium))
    end

    let(:bra_option_type) do
      build_option_type_with_values("Bra Sizes", %w(34A 34B))
    end

    let(:product1) { create(:product, name: 'product1', vixen_value: 5, flirt_value: 3, sophisticate_value: 1, romantic_value:1, option_values_hash: {bra_option_type.id.to_s => bra_option_type.option_value_ids}) }
    let(:product1b) { create(:product, name: 'product1b', vixen_value: 5, flirt_value: 3, sophisticate_value: 1, romantic_value:1, option_values_hash: {bottom_option_type.id.to_s => bottom_option_type.option_value_ids}) }

    it "should return the size type of the product" do
      expect(product1.product_size_type.name).to eq 'Bra Sizes'
    end

    it "should return the variant id of the matching size" do
      expected_id = product1b.variants_and_option_values_with_stock(nil).collect{ |v| ["#{v.options_text.downcase}", v.id] }.to_h['medium']
      selected_id = product1b.get_variant_id_of_first_matching_size('medium')
      expect(selected_id).to eq expected_id
      expect(selected_id).to_not eq nil
    end

    it "should return true for size only check" do
      expect(product1.is_size_only_variant?).to eq true
    end

  end

  context "product has sizes and colors" do

    let(:bottom_option_type) do
      build_option_type_with_values("Named Sizes", %w(Small Medium))
    end

    let(:color_option_type) do
      build_option_type_with_values("Colors", %w(Red Green))
    end

    let(:product1) { create(:product, name: 'product1', vixen_value: 5, flirt_value: 3, sophisticate_value: 1, romantic_value:1, option_values_hash: {bottom_option_type.id.to_s => bottom_option_type.option_value_ids,color_option_type.id.to_s => color_option_type.option_value_ids}) }

    it "should return the size type of the product" do
      expect(product1.product_size_type.name).to eq 'Named Sizes'
    end

    it "should return the count on hand by option value names" do
      variant_hash = product1.product_count_on_hand_hash_by_option_value_name
      expect(variant_hash).to include('small-red');
    end

    it "should return false for size only check" do
      expect(product1.is_size_only_variant?).to eq false
    end


    context "there is stock on hand for all variants" do

      before do
        product1.stock_items.each do |si|
          if !si.variant.is_master?
            si.set_count_on_hand 1
          end
        end
      end

      it "should return the count on hand by size option value names" do
        expect(product1.total_on_hand).to eq 4
        size_hash = product1.product_count_on_hand_hash_by_size_option_value_name
        expect(size_hash['small']).to eq 2
        expect(size_hash['medium']).to eq 2
        expect(size_hash.count).to eq 2
      end

      it "should return the first matching size for size-color combination" do
        expected_id = product1.variants_and_option_values_with_stock(nil).collect{ |v| ["#{v.options_text.downcase}", v.id] }.to_h['medium, red']
        selected_id = product1.get_variant_id_of_first_matching_size('medium')
        expect(selected_id).to eq expected_id
        expect(selected_id).to_not eq nil

      end

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

  context "get sku appending string from variant combination"  do

    let!(:option_type1) do
      build_option_type_with_values("Named Sizes", %w(Small))
    end

    let!(:option_type2) do
      build_option_type_with_values("Colors", %w(Red))
    end

    context "product only has 1 type of variant" do


      it "should get a sku append string of the single variant name, small" do
        ids = option_type1.option_values.first.id
        sku_string = Spree::Product.get_sku_string_from_option_values(ids);
        expect(sku_string).to eq '-Small'
      end

      it "should get a sku append string for the double variant name, small-red" do
        ids = [option_type1.option_values.first.id,option_type2.option_values.first.id]
        sku_string = Spree::Product.get_sku_string_from_option_values(ids);
        expect(sku_string).to eq '-Small-Red'

      end

    end


  end

  def build_option_type_with_values(name, values)
    ot = create(:option_type, :name => name)
    values.each do |val|
      ot.option_values.create(:name => val.downcase, :presentation => val)
    end
    ot
  end
end
