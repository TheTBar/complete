require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!


describe "Get user wants to purchase through BYB", type: :feature do

  let!(:admin_user) {FactoryGirl.create(:user)}
  let!(:country) { create(:country, :name => "United States", :states_required => true) }
  let!(:state) { create(:state, :name => "Colorado", :country => country) }
  let!(:shipping_method) { create(:shipping_method) }
  let!(:stock_location) { create(:stock_location) }
  let!(:payment_method) { create(:check_payment_method) }
  let!(:zone) { create(:zone) }

  let(:sets_taxon) { FactoryGirl.create(:taxon, name: 'sets')}
  let!(:taxon1) { FactoryGirl.create(:taxon, name: 'package1', is_package_node: true, taxonomy_id: sets_taxon.taxonomy_id, parent_id: sets_taxon.id ) }

  let!(:bottom_option_type) do
    build_option_type_with_values("named sizes", "Size", %w(Small Medium))
  end

  let!(:bra_option_type) do
    build_option_type_with_values("bra sizes", "Size", %w(34A 34C))
  end

  let(:product1) { FactoryGirl.create(:product, name: 'product1', vixen_value: 5, flirt_value: 3, sophisticate_value: 2, romantic_value:1, option_values_hash: {bra_option_type.id.to_s => bra_option_type.option_value_ids}, taxons: [taxon1]) }
  let(:product1b) { FactoryGirl.create(:product, name: 'product1b', vixen_value: 5, flirt_value: 3, sophisticate_value: 2, romantic_value:1, option_values_hash: {bottom_option_type.id.to_s => bottom_option_type.option_value_ids}, taxons: [taxon1]) }

  before do
    set_count_on_hand(product1,1)
    set_count_on_hand(product1b,1)
  end



    context "user is logged in and creates babe" do

      let(:user) {create(:user)}

      before (:each) do
        login_as(user, scope: :spree_user)
      end

      let (:babe) { create(:babe, spree_user_id: user.id, name: 'Stella', band: 34, cup: 'A', bottoms: 'Small', number_size: 3, vixen_value: 4.1, flirt_value: 3.2 ) }


      it "should save the babes id on the order when added from the BYB results page" do
        #puts (user.inspect)
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

    context "user starts out as guest and creates babe" do
      before do
        @city_trait = create(:babe_trait_type, name: 'city')
        create(:babe_trait_value, name: 'city 1', spree_babe_trait_type_id: @city_trait.id, vixen_value: 5, flirt_value: 4, romantic_value: 3, sophisticate_value: 2)
        @date_trait = create(:babe_trait_type, name: 'date')
        create(:babe_trait_value, name: "date 1", spree_babe_trait_type_id: @date_trait.id, vixen_value: 4, flirt_value: 3, romantic_value: 2, sophisticate_value: 1)
        @shoe_trait = create(:babe_trait_type, name: 'shoe', active: false)
        create(:babe_trait_value, name: "shoe 1", spree_babe_trait_type_id: @shoe_trait.id, vixen_value: 4, flirt_value: 2, romantic_value: 5, sophisticate_value: 5)
      end

      let(:user) { create(:user) }

      it "should assign the babe to the user on checkout" , js: true  do
        visit '/build_your_babe'
        fill_in_babe
        click_button "Show me the goods"
        babe = Spree::Babe.last
        expect(babe.id).to eq 1
        click_button "Add To Cart"
        expect(current_path).to eql(spree.cart_path)
        click_button 'Checkout'
        fill_in_new_user
        click_button 'Create'
        user2 = Spree::User.last
        fill_in_address
        click_button "Save and Continue"
        expect(current_path).to eql(spree.checkout_state_path("delivery"))
        click_button "Save and Continue"
        expect(current_path).to eql(spree.checkout_state_path("payment"))
        click_button "Save and Continue"
        order = Spree::Order.last
        expect(current_path).to eql(spree.order_path(order))
        babe = Spree::Babe.last
        lines = Spree::LineItem.where("order_id = #{order.id}")
        expect(lines.first.babe_id).to eq babe.id
        expect(lines.second.babe_id).to eq babe.id

        expect(babe.spree_user_id).to eq user2.id



      end

    end

  def fill_in_new_user
    fill_in "spree_user_email", :with => "bobroberts@example.com"
    fill_in "spree_user_name", :with => "bob roberts"
    fill_in "spree_user_password", :with => "welcome1"
    fill_in "spree_user_password_confirmation", :with => "welcome1"
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



end
