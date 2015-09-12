require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!


describe "Getting Babe product results limited to 4 and then 8", type: :feature do

  before do
    @base_user = FactoryGirl.create(:user)
    @city_trait = create(:babe_trait_type, name: 'city')
    create(:babe_trait_value, name: 'city 1', spree_babe_trait_type_id: @city_trait.id, vixen_value: 5, flirt_value: 1, romantic_value: 3, sophisticate_value: 4)
    @date_trait = create(:babe_trait_type, name: 'date')
    create(:babe_trait_value, name: "date 1", spree_babe_trait_type_id: @date_trait.id, vixen_value: 4, flirt_value: 4, romantic_value: 2, sophisticate_value: 3)
    @shoe_trait = create(:babe_trait_type, name: 'shoe')
    create(:babe_trait_value, name: "shoe 1", spree_babe_trait_type_id: @shoe_trait.id, vixen_value: 5, flirt_value: 1, romantic_value: 1, sophisticate_value: 4)
  end

  let!(:onesize_option_type) do
    build_option_type_with_values("one size", ['One Size'])
  end

  let!(:bottom_option_type) do
    build_option_type_with_values("named sizes", %w(Small))
  end

  let(:sets_taxon) { create(:taxon, name: 'sets')}


  context "there lots of packages for the babe" do

    before do
      for i in 1..12
        create(:taxon, name: "package#{i}", is_package_node: true, taxonomy_id: sets_taxon.taxonomy_id, parent_id: sets_taxon.id )
        if i < 5
          v = 5
        elsif i < 9
          v = 4
        elsif i < 11
          v = 3
        else
          v = 2
        end
        create(:product, :name => "product#{i}", vixen_value: v, flirt_value: 4, sophisticate_value: 3, romantic_value:1, option_values_hash: {onesize_option_type.id.to_s => onesize_option_type.option_value_ids}, taxons: [Spree::Taxon.last])
        set_count_on_hand_for_size(Spree::Product.last,'One Size',1)
      end
    end


    let (:babe) { create(:babe, name: 'Stella', band: 34, cup: 'A', bottoms: 'Small', number_size: 3, vixen_value: 4.2, flirt_value: 3.2 ) }

    # it "should show all the products" do
    #   visit "/products"
    #   puts page.body
    #   expect(page).to have_content "product1"
    #   expect(page).to have_content "product10"
    # end

    it "shoudl only return 10 items" do
      # i know this isn't a feature test but who wants to set all this up twice
      expect(Spree::Taxon.where(is_package_node: true).count).to eq 12
      expect(Spree::Taxon.get_babes_package_list(babe).count).to eq 10
    end

    it "should return the top 4 matches only" do



      visit spree.my_babes_package_list_path(babe.id)
      expect(page).to have_content("Our personalized selection for Stella")
      for i in 1..4
        expect(page).to have_content("package#{i}")
      end
      for i in 5..10
        expect(page).to_not have_content("package#{i}")
      end
      click_link "See More Selections"
      for j in 1..8
        expect(page).to have_content("package#{j}")
      end
      expect(page).to_not have_content("package9")
      expect(page).to_not have_content("package10")
      expect(page).to_not have_button("See More Selections")
    end

  end

  context "there are only 4 matching Packages for the babe" do
    before do
      for i in 1..4
        create(:taxon, name: "package#{i}", is_package_node: true, taxonomy_id: sets_taxon.taxonomy_id, parent_id: sets_taxon.id )
        v = 4
        create(:product, :name => "product#{i}", vixen_value: v, flirt_value: 4, sophisticate_value: 3, romantic_value:1, option_values_hash: {onesize_option_type.id.to_s => onesize_option_type.option_value_ids}, taxons: [Spree::Taxon.last])
        set_count_on_hand_for_size(Spree::Product.last,'One Size',1)
      end
    end


    let (:babe) { create(:babe, name: 'Stella', band: 34, cup: 'A', bottoms: 'Small', number_size: 3, vixen_value: 3.8, flirt_value: 3.2 ) }

    it "should return the 4 matches with out the see more choices button" do
      visit spree.my_babes_package_list_path(babe.id)
      expect(page).to have_content("Our personalized selection for Stella")
      for i in 1..4
        expect(page).to have_content("package#{i}")
      end
      expect(page).to_not have_link("See More Selections")
    end

  end


  def build_option_type_with_values(name, values)
    ot = create(:option_type, :name => name)
    values.each do |val|
      ot.option_values.create(:name => val.downcase, :presentation => val)
    end
    ot
  end

  def build_options_values_hash_from_option_type(option_type,hash)
    hash[option_type.id.to_s] = option_type.option_value_ids
  end

  def set_count_on_hand_for_size(product,size,count)
    product.stock_items.each do |stock_item|
      if !stock_item.variant.is_master?
        if stock_item.variant.option_values.first.name.downcase == size.downcase || size.downcase == 'all'
          stock_item.set_count_on_hand count
        end
      end
    end
  end

  def show_product_stock(product)
    product.stock_items.each do |stock_item|
      if !stock_item.variant.is_master?
        puts stock_item.variant.option_values.first.name.downcase
        puts "stock on hand is #{stock_item.count_on_hand}"
      end
    end
  end

end
