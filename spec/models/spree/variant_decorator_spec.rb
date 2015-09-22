require 'rails_helper'

describe Spree::Variant, :type => :model do


  context "there are only sizes" do

    let(:bra_option_type) do
      build_option_type_with_values("Bra Sizes", "Size", %w(34A))
    end

    let(:product1) { create(:product, name: 'product1', option_values_hash: {bra_option_type.id.to_s => bra_option_type.option_value_ids}) }

    it "should create the effective sizes records when variant is created and is not master" do
      variants = Spree::Variant.where(:product_id => product1.id)
      count = variants.count
      expect(count).to eq 2

      effective_size_records = Spree::EffectiveSize.all
      expect(effective_size_records.count).to eq count-1
      expect(effective_size_records[0].effective_size).to eq '34a'
    end

  end

  context "there are sizes and colors" do

    let(:bra_option_type) do
      build_option_type_with_values("Bra Sizes", "Size", %w(34A))
    end

    let(:color_option_type) do
      build_option_type_with_values("Colors", "Color", %w(Red Green))
    end

    let(:product1) { create(:product, name: 'product1', option_values_hash: {bra_option_type.id.to_s => bra_option_type.option_value_ids,color_option_type.id.to_s => color_option_type.option_value_ids}) }

    it "should create a record for each variant combination" do
      variants = Spree::Variant.where(:product_id => product1.id)
      count = variants.count
      expect(count).to eq 3

      effective_size_records = Spree::EffectiveSize.all
      expect(effective_size_records.count).to eq count-1
      expect(effective_size_records[0].effective_size).to eq '34a'
      expect(effective_size_records[1].effective_size).to eq '34a'
    end
  end

  context "there are sizes and colors to be re-assigned" do
    let(:named_option_type) do
      build_option_type_with_values("Named Sizes", "Size", %w(Small Medium Large))
    end

    let(:color_option_type) do
      build_option_type_with_values("Colors", "Color", %w(Red Green))
    end

    let(:product1) { create(:product, name: 'product1', option_values_hash: {named_option_type.id.to_s => named_option_type.option_value_ids,color_option_type.id.to_s => color_option_type.option_value_ids}) }

    it "should allow reassignment though the variant object" do
      variants = Spree::Variant.where(:product_id => product1.id)
      count = variants.size
      expect(count).to eq 7

      small_effective_size_records = Spree::EffectiveSize.joins(:variant => :option_values).where("spree_variants.product_id = #{product1.id}").where("LOWER(spree_option_values.name) = 'small'")
      expect(small_effective_size_records.size).to eq 2
      expect(small_effective_size_records[0].effective_size).to eq 'small'
      expect(small_effective_size_records[1].effective_size).to eq 'small'

      Spree::Variant.assign_custom_effective_size_value_to_variant(product1.id,'small','30a')
      small_effective_size_records = Spree::EffectiveSize.joins(:variant => :option_values).where("spree_variants.product_id = #{product1.id}").where("LOWER(spree_option_values.name) = 'small'")
      expect(small_effective_size_records.size).to eq 2
      expect(small_effective_size_records[0].effective_size).to eq '30a'
      expect(small_effective_size_records[1].effective_size).to eq '30a'
    end

    it "should allow adding extra effective sizes to a variant" do
      Spree::Variant.assign_custom_effective_size_value_to_variant(product1.id,'small','30a')
      Spree::Variant.add_custom_effective_size_value_to_variant(product1.id,'small','28a')
      small_effective_size_records = Spree::EffectiveSize.joins(:variant => :option_values).where("spree_variants.product_id = #{product1.id}").where("LOWER(spree_option_values.name) = 'small'")
      expect(small_effective_size_records.size).to eq 4
      es = small_effective_size_records.pluck(:effective_size)
      expect(es.grep('30a').size).to eq 2
      expect(es.grep('28a').size).to eq 2
    end

  end

  def build_option_type_with_values(name, presentation, values)
    ot = FactoryGirl.create(:option_type, :name => name, :presentation => presentation)
    values.each do |val|
      value_presentation = ot.name == 'named sizes' ? val[0].upcase : val
      ot.option_values.create(:name => val.downcase, :presentation => value_presentation)
    end
    ot
  end


end

