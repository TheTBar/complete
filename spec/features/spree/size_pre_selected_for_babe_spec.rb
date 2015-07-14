require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!


describe "Get Size pre selected", type: :feature do

  let(:user) {FactoryGirl.create(:user)}

  before (:each) do
    login_as(user, scope: :spree_user)
  end

  context "user gets selection for their babe" do

    let(:sets_taxon) { FactoryGirl.create(:taxon, name: 'sets')}
    let!(:taxon1) { FactoryGirl.create(:taxon, name: 'package1', is_package_node: true, taxonomy_id: sets_taxon.taxonomy_id, parent_id: sets_taxon.id ) }

    def build_option_type_with_values(name, values)
      ot = FactoryGirl.create(:option_type, :name => name)
      values.each do |val|
        ot.option_values.create(:name => val.downcase, :presentation => val)
      end
      ot
    end

    def build_options_values_hash_from_option_type(option_type,hash)
      hash[option_type.id.to_s] = option_type.option_value_ids
    end

    let!(:bottom_option_type) do
      build_option_type_with_values("named sizes", %w(Small Medium Large))
    end

    let!(:bra_option_type) do
      build_option_type_with_values("bra sizes", %w(34A 34B 34C 36A 36B 36C))
    end


    let!(:product1) { FactoryGirl.create(:product, name: 'product1', vixen_value: 5, flirt_value: 3, sophisticate_value: 2, romantic_value:1, option_values_hash: {bra_option_type.id.to_s => bra_option_type.option_value_ids}, taxons: [taxon1]) }
    let!(:product1b) { FactoryGirl.create(:product, name: 'product1b', vixen_value: 5, flirt_value: 2, sophisticate_value: 3, romantic_value:1, option_values_hash: {bottom_option_type.id.to_s => bottom_option_type.option_value_ids}, taxons: [taxon1]) }

    before do
      product1.stock_items.each do |si|
        si.set_count_on_hand 1
      end

      product1b.stock_items.each do |si|
        si.set_count_on_hand 1
      end
    end


    it "should preselect the size values" do

      visit "/"
      click_link "The Lingerie Concierge"
      expect(current_path).to eql(spree.new_babe_path)
      fill_in_babe
      click_button "Show me the goods"
      babe = Spree::Babe.last
      expect(current_path).to eql(spree.my_babes_package_list_path(babe.id))
      expect(page).to have_content("Our personalized selection for Stella")
      expect(page).to have_content("package1")
      expect(page).to have_link("package1");
      click_link "package1"
      expect(find_field('variant_id_0').find('option[selected]').text).to eq '34C'
      expect(find_field('variant_id_1').find('option[selected]').text).to eq 'Medium'
      click_button 'Add Package To Cart'
      expect(current_path).to eql(spree.cart_path)


    end



  end

  def fill_in_babe
    fill_in "babe_name", :with => "Stella"
    fill_in "babe_height", :with => "65"
    fill_in "babe_band", :with => "34"
    fill_in "babe_cup", :with => "C"
    fill_in "babe_bottoms", :with => "Medium"
    fill_in "babe_number_size", :with => "3"
    fill_in "babe_vixen_value", :with => "5"
    fill_in "babe_romantic_value", :with => "4"
    fill_in "babe_flirt_value", :with => "3"
    fill_in "babe_sophisticate_value", :with => "2"

  end

end
