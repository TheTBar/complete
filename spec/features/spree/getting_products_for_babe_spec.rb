require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!


describe "Getting Babe product results", type: :feature do

  before do
    @base_user = FactoryGirl.create(:user)
    @city_trait = create(:babe_trait_type, name: 'city')
    create(:babe_trait_value, name: 'city 1', spree_babe_trait_type_id: @city_trait.id, vixen_value: 5, flirt_value: 1, romantic_value: 3, sophisticate_value: 4)
    @date_trait = create(:babe_trait_type, name: 'date')
    create(:babe_trait_value, name: "date 1", spree_babe_trait_type_id: @date_trait.id, vixen_value: 4, flirt_value: 4, romantic_value: 2, sophisticate_value: 3)
    @shoe_trait = create(:babe_trait_type, name: 'shoe')
    create(:babe_trait_value, name: "shoe 1", spree_babe_trait_type_id: @shoe_trait.id, vixen_value: 5, flirt_value: 1, romantic_value: 1, sophisticate_value: 4)
  end

  let(:sets_taxon) { create(:taxon, name: 'sets')}
  let(:user) {FactoryGirl.create(:user)}

  before (:each) do
    login_as(user, scope: :spree_user)
  end

  context "user gets selection for their babe" do


    let!(:taxon1) { create(:taxon, name: 'package1', is_package_node: true, taxonomy_id: sets_taxon.taxonomy_id, parent_id: sets_taxon.id ) }
    let!(:taxon2) { create(:taxon, name: 'package2', is_package_node: true, taxonomy_id: sets_taxon.taxonomy_id, parent_id: sets_taxon.id ) }
    let!(:taxon3) { create(:taxon, name: 'package3', is_package_node: true, taxonomy_id: sets_taxon.taxonomy_id, parent_id: sets_taxon.id ) }
    let!(:taxon4) { create(:taxon, name: 'package4', is_package_node: true, taxonomy_id: sets_taxon.taxonomy_id, parent_id: sets_taxon.id ) }

    let!(:bottom_option_type) do
      build_option_type_with_values("named sizes", %w(Small Medium Large))
    end

    let!(:bra_option_type) do
      build_option_type_with_values("bra sizes", %w(34A 34B 34C 36A 36B 36C))
    end

    let!(:number_size_option_type) do
      build_option_type_with_values("number sizes", %w(1 2 3 4))
    end

    let!(:product1) { create(:product, name: 'product1', vixen_value: 5, flirt_value: 3, sophisticate_value: 1, romantic_value:1, option_values_hash: {bra_option_type.id.to_s => bra_option_type.option_value_ids}, taxons: [taxon1]) }
    let!(:product1b) { create(:product, name: 'product1b', vixen_value: 5, flirt_value: 3, sophisticate_value: 1, romantic_value:1, option_values_hash: {bottom_option_type.id.to_s => bottom_option_type.option_value_ids}, taxons: [taxon1]) }
    let!(:product2) { create(:product, name: 'product2', vixen_value: 5, flirt_value: 2, sophisticate_value: 2, romantic_value:1, option_values_hash: {bra_option_type.id.to_s => bra_option_type.option_value_ids}, taxons: [taxon2]) }
    let!(:product2b) { create(:product, name: 'product2b', vixen_value: 5, flirt_value: 2, sophisticate_value: 2, romantic_value:1, option_values_hash: {bottom_option_type.id.to_s => bottom_option_type.option_value_ids}, taxons: [taxon2]) }
    let!(:product3) { create(:product, name: 'product3', vixen_value: 5, flirt_value: 4, sophisticate_value: 3, romantic_value:2, option_values_hash: {bra_option_type.id.to_s => bra_option_type.option_value_ids}, taxons: [taxon3]) }
    let!(:product3b) { create(:product, name: 'product3b', vixen_value: 5, flirt_value: 4, sophisticate_value: 3, romantic_value:2, option_values_hash: {bottom_option_type.id.to_s => bottom_option_type.option_value_ids}, taxons: [taxon3]) }
    let!(:product4) { create(:product, name: 'product4', vixen_value: 5, flirt_value: 4, sophisticate_value: 4, romantic_value:1, option_values_hash: {number_size_option_type.id.to_s => number_size_option_type.option_value_ids}, taxons: [taxon4]) }

    let (:weird_babe) { create(:babe, name: 'Bad Stella', band: 99, cup: 'Z', bottoms: 'Huge')}

    it "should return the availble packages" do

      #{master, "34a"=>1, "34b"=>0, "34c"=>0, "36a"=>0, "36b"=>0, "36c"=>0}
      #{master, "small"=>1, "medium"=>0, "large"=>0}
      #puts product1b.stock_items.inspect
      set_count_on_hand_for_size(product1,'34C',1)
      set_count_on_hand_for_size(product1b,'medium',1)
      set_count_on_hand_for_size(product2,'34C',1)
      set_count_on_hand_for_size(product2b,'small',1)
      set_count_on_hand_for_size(product3,'34C',1)
      set_count_on_hand_for_size(product3b,'medium',1)
      set_count_on_hand_for_size(product4,'1',1)

      visit spree.build_your_babe_path
      fill_in_babe
      click_button "Show me the goods"
      last_babe = Spree::Babe.last
      expect(current_path).to eql(spree.my_babes_package_list_path(last_babe.id))
      expect(page).to have_content(/Our personalized selection for Stella/i)
      expect(page).to have_content(/package1/i)
      expect(page).to have_content(/package3/i)
      expect(page).to_not have_content(/package2/i)
      expect(page).to_not have_content(/package4/i)
    end

    it "should return the no results for babe page" do
      visit spree.my_babes_package_list_path(weird_babe.id)
      expect(weird_babe.name).to eq "Bad Stella"
      expect(page).to have_content("OH NO")
      expect(page).to have_content("Sorry we couldn't find any items for Bad Stella")
      last_failure_record = Spree::BabeProductSearchFailure.last
      expect(last_failure_record).to_not eq nil
      expect(last_failure_record.spree_babe_id).to eq weird_babe.id
      expect(last_failure_record.spree_user_id).to eq user.id
    end

    it "should allow the user to add the package to their cart if size is the only variant" do
      set_count_on_hand_for_size(product1,'34C',1)
      set_count_on_hand_for_size(product1b,'medium',1)
      visit spree.build_your_babe_path
      fill_in_babe
      click_button "Show me the goods"
      last_babe = Spree::Babe.last
      expect(page).to have_content("package1")
      click_button "Add To Cart"
      expect(current_path).to eql(spree.cart_path)

    end



  end

  context "named sizes for bra and bottom" do

    let(:bottom_option_type) do
      build_option_type_with_values("named sizes", %w(Small Medium Large))
    end
    let(:taxon1) { create(:taxon, name: 'package1', is_package_node: true, taxonomy_id: sets_taxon.taxonomy_id, parent_id: sets_taxon.id ) }
    let(:product1) { create(:product, name: 'product1', vixen_value: 5, flirt_value: 3, sophisticate_value: 1, romantic_value:1, option_values_hash: {bottom_option_type.id.to_s => bottom_option_type.option_value_ids}, taxons: [taxon1]) }
    let(:product1b) { create(:product, name: 'product1b', vixen_value: 5, flirt_value: 3, sophisticate_value: 1, romantic_value:1, option_values_hash: {bottom_option_type.id.to_s => bottom_option_type.option_value_ids}, taxons: [taxon1]) }

    it "should return the package based on the effective size" do
      set_count_on_hand_for_size(product1,'small',1)
      set_count_on_hand_for_size(product1b,'Medium',1)
      babe = create(:babe, name: 'my babe 1', band: 30, cup: 'a', bottoms: 'Medium', vixen_value: 2, flirt_value: 0, sophisticate_value: 1, romantic_value:0)
      visit spree.my_babes_package_list_path(babe.id)
      expect(page).to have_content(/oh no/i)

      Spree::Variant.assign_custom_effective_size_value_to_variant(product1.id,'Small','30A')
      visit spree.my_babes_package_list_path(babe.id)
      expect(page).to have_content("package1")
      click_button "Add To Cart"
      expect(current_path).to eql(spree.cart_path)

      babe2 = create(:babe, name: 'my babe 1', band: 28, cup: 'a', bottoms: 'Medium', vixen_value: 2, flirt_value: 0, sophisticate_value: 1, romantic_value:0)
      visit spree.my_babes_package_list_path(babe2.id)
      expect(page).to have_content(/oh no/i)

      Spree::Variant.add_custom_effective_size_value_to_variant(product1.id,'Small','28A')
      visit spree.my_babes_package_list_path(babe.id)
      expect(page).to have_content("package1")
      click_button "Add To Cart"
      expect(current_path).to eql(spree.cart_path)

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

  #this is just for debugging the test. ugh
  def show_product_stock(product)
    product.stock_items.each do |stock_item|
      if !stock_item.variant.is_master?
        puts stock_item.variant.option_values.first.name.downcase
        puts "stock on hand is #{stock_item.count_on_hand}"
      end
    end
  end

  def fill_in_weird_babe
    fill_in "babe_name", :with => "Bad Stella"
    fill_in "babe_height", :with => "150"
    fill_in "babe_band", :with => "99"
    fill_in "babe_cup", :with => "Z"
    fill_in "babe_bottoms", :with => "Huge"
    fill_in "babe_number_size", :with => "7"

  end

  def fill_in_babe
    fill_in "babe_name", :with => "Stella"
  end

end
