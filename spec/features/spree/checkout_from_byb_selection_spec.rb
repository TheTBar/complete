require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!


describe "Get user wants to purchase through BYB", type: :feature do

  let(:user) {FactoryGirl.create(:user)}
  let!(:country) { create(:country, :name => "United States", :states_required => true) }
  let!(:state) { create(:state, :name => "Colorado", :country => country) }
  let!(:shipping_method) { create(:shipping_method) }
  let!(:stock_location) { create(:stock_location) }
  let!(:payment_method) { create(:check_payment_method) }
  let!(:zone) { create(:zone) }


  before (:each) do
    login_as(user, scope: :spree_user)
  end

  context "user gets selection for their babe" do

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
      build_option_type_with_values("named sizes", "Size", %w(Small))
    end

    let!(:bra_option_type) do
      build_option_type_with_values("bra sizes", "Size", %w(34A))
    end

    let (:babe) { create(:babe, name: 'Stella', band: 34, cup: 'A', bottoms: 'Small', number_size: 3, vixen_value: 4.1, flirt_value: 3.2 ) }

    context "there are sizes only" do
      let(:product1) { FactoryGirl.create(:product, name: 'product1', vixen_value: 5, flirt_value: 3, sophisticate_value: 2, romantic_value:1, option_values_hash: {bra_option_type.id.to_s => bra_option_type.option_value_ids}, taxons: [taxon1]) }
      let(:product1b) { FactoryGirl.create(:product, name: 'product1b', vixen_value: 5, flirt_value: 3, sophisticate_value: 2, romantic_value:1, option_values_hash: {bottom_option_type.id.to_s => bottom_option_type.option_value_ids}, taxons: [taxon1]) }

      before do
        set_count_on_hand(product1,1)
        set_count_on_hand(product1b,1)
      end

      it "should save the babes id on the order when added from the BYB results page" do

        visit spree.my_babes_package_list_path(babe.id)
        click_button 'Add To Cart'
        expect(current_path).to eql(spree.cart_path)
        expect(page).to have_content("product1b")
        order = Spree::Order.last
        lines = Spree::LineItem.where("order_id = #{order.id}")
        expect(lines.first.babe_id).to eq babe.id
        expect(lines.second.babe_id).to eq babe.id

      end


      it "should save the babes id on the order when added from the package page" , js: true do

        visit spree.my_babes_package_list_path(babe.id)
        click_link "package1"
        click_button 'Add Package To Cart'
        expect(current_path).to eql(spree.cart_path)
        expect(page).to have_content("product1b")
        order = Spree::Order.last

        click_button "Checkout"
        fill_in_address
        click_button "Save and Continue"
        expect(current_path).to eql(spree.checkout_state_path("delivery"))
        expect(page).to have_content("product1b")

        click_button "Save and Continue"
        expect(current_path).to eql(spree.checkout_state_path("payment"))

        click_button "Save and Continue"
        expect(current_path).to eql(spree.order_path(Spree::Order.last))
        expect(page).to have_content("product1b")
        expect(page).to have_content("Your order has been processed successfully")
        lines = Spree::LineItem.where("order_id = #{order.id}")
        expect(lines.first.babe_id).to eq babe.id
        expect(lines.second.babe_id).to eq babe.id


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

  def fill_in_address
    address = "order_bill_address_attributes"
    fill_in "#{address}_firstname", :with => "Adam"
    fill_in "#{address}_lastname", :with => "Tbar"
    fill_in "#{address}_address1", :with => "1045 Pine Street"
    fill_in "#{address}_city", :with => "Boulder"
    select "Colorado", :from => "order_bill_address_attributes_state_id"
    fill_in "#{address}_zipcode", :with => "80302"
    fill_in "#{address}_phone", :with => "(555) 555-5555"
  end


end
