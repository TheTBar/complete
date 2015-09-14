require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!


describe "Get Size pre selected", type: :feature do

  let(:user) {FactoryGirl.create(:user)}

  before (:each) do
    login_as(user, scope: :spree_user)
  end

  context "there are products and sets" do

    let(:sets_taxon) { FactoryGirl.create(:taxon, name: 'sets')}
    let!(:taxon1) { FactoryGirl.create(:taxon, name: 'package1', is_package_node: true, taxonomy_id: sets_taxon.taxonomy_id, parent_id: sets_taxon.id ) }

    def build_option_type_with_values(name, presentation, values)
      ot = FactoryGirl.create(:option_type, :name => name, :presentation => presentation)
      values.each do |val|
        value_presentation = ot.name == 'named sizes' ? val[0].upcase : val
        ot.option_values.create(:name => val.downcase, :presentation => value_presentation)
      end
      ot
    end

    def build_options_values_hash_from_option_type(option_type,hash)
      hash[option_type.id.to_s] = option_type.option_value_ids
    end

    let!(:bottom_option_type) do
      build_option_type_with_values("named sizes","Size", %w(Small Medium Large))
    end

    let!(:bra_option_type) do
      build_option_type_with_values("bra sizes", "Size", %w(34A 34B 34C 36A 36B 36C))
    end




    context "there are sizes only" do
      let(:product1) { FactoryGirl.create(:product, name: 'product1', vixen_value: 5, flirt_value: 3, sophisticate_value: 2, romantic_value:1, option_values_hash: {bra_option_type.id.to_s => bra_option_type.option_value_ids}, taxons: [taxon1]) }
      let(:product1b) { FactoryGirl.create(:product, name: 'product1b', vixen_value: 5, flirt_value: 2, sophisticate_value: 3, romantic_value:1, option_values_hash: {bottom_option_type.id.to_s => bottom_option_type.option_value_ids}, taxons: [taxon1]) }

      before do
        set_count_on_hand(product1,1)
        set_count_on_hand(product1b,1)
      end

      it "should preselect the size values" , js: true  do

        visit "/build_your_babe"
        expect(current_path).to eql(spree.new_babe_path)
        fill_in_babe
        click_button "Show me the goods"
        babe = Spree::Babe.last
        expect(current_path).to eql(spree.my_babes_package_list_path(babe.id))
        expect(page.body.downcase).to have_content("Our personalized selection for Stella".downcase)
        expect(page).to have_content(/package1/i)
        expect(page).to have_link("package1");
        click_link "package1"
        click_button 'Add Package To Cart'
        expect(current_path).to eql(spree.cart_path)
        expect(page).to have_content(/product1 34C/i)
        expect(page).to have_content(/product1b M/i)

      end

    end

    context "there are named sizes only for top and bottom", js: true do

      let(:soonik_bra_option_type) do
        build_option_type_with_values("soonik named sizes", 'Size', ['Soonik Bra Small','Soonik Bra Medium','Soonik Bra Large'])
      end

      let(:product1) { FactoryGirl.create(:product, name: 'product1', vixen_value: 5, flirt_value: 3, sophisticate_value: 2, romantic_value:1, option_values_hash: {soonik_bra_option_type.id.to_s => soonik_bra_option_type.option_value_ids}, taxons: [taxon1]) }
      let(:product1b) { FactoryGirl.create(:product, name: 'product1b', vixen_value: 5, flirt_value: 2, sophisticate_value: 3, romantic_value:1, option_values_hash: {bottom_option_type.id.to_s => bottom_option_type.option_value_ids}, taxons: [taxon1]) }

      before do
        set_count_on_hand(product1,1)
        set_count_on_hand(product1b,1)
      end

      let(:babe) { create(:babe, name: 'babe1', band: 38, cup: 'A', bottoms: 'medium', number_size: '3', spree_user_id: user.id)}

      it "should be able to add to cart from the babe results page" do
        visit "/my_babes_package_list/#{babe.id}"
        click_button "Add To Cart"
        puts page.body
        expect(current_path).to eq(spree.cart_path)
        expect(page).to have_content(/product1 Soonik Bra Large/i)
        expect(page).to have_content(/product1b M/i)
      end

      it "should preselect both the top and the bottom for the babe" do
        visit "/my_babes_package_list/#{babe.id}"
        click_link "package1"
        puts page.body
        click_button 'Add Package To Cart'
        expect(current_path).to eql(spree.cart_path)
        expect(page).to have_content(/product1 Soonik Bra Large/i)
        expect(page).to have_content(/product1b M/i)
      end

    end

    context "there are sizes and colors" , js: true do

      let(:color_option_type) do
        build_option_type_with_values("Colors", "Color", %w(Red Green))
      end

      let(:product1) { FactoryGirl.create(:product, name: 'product1', vixen_value: 5, flirt_value: 3, sophisticate_value: 2, romantic_value:1, option_values_hash: {bra_option_type.id.to_s => bra_option_type.option_value_ids,color_option_type.id.to_s => color_option_type.option_value_ids}, taxons: [taxon1]) }
      let(:product1b) { FactoryGirl.create(:product, name: 'product1b', vixen_value: 5, flirt_value: 2, sophisticate_value: 3, romantic_value:1, option_values_hash: {bottom_option_type.id.to_s => bottom_option_type.option_value_ids,color_option_type.id.to_s => color_option_type.option_value_ids}, taxons: [taxon1]) }

      before do
        set_count_on_hand(product1,1)
        set_count_on_hand(product1b,1)
      end

      it "should preselect the first color that matches the babes size" do
        visit "/build_your_babe"
        expect(current_path).to eql(spree.new_babe_path)
        fill_in_babe
        click_button "Show me the goods"
        babe = Spree::Babe.last
        expect(current_path).to eql(spree.my_babes_package_list_path(babe.id))
        expect(page).to have_content(/package1/i)
        expect(page).to have_link("package1");
        click_link "package1"
        click_link "namedsizes-red"
        click_link "brasizes-red"
        click_button 'Add Package To Cart'
        expect(current_path).to eql(spree.cart_path)
        expect(page).to have_content("34C, Red")
        expect(page).to have_content("M, Red")
      end

    end

  end

  def fill_in_babe
    fill_in "babe_name", :with => "Stella"
  end

  def set_count_on_hand(product,count)
    product.stock_items.each do |si|
      if !si.variant.is_master?
        si.set_count_on_hand count
      end
    end
  end

end
