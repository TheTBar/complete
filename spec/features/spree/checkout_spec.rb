require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!


describe "Get user wants to purchase a produtc", type: :feature do

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

  let!(:size_option_type) do
    build_option_type_with_values("Sizes", %w(Medium))
  end

  #let(:user) {create(:user)}
  let!(:country) { create(:country, :name => "United States", :states_required => true) }
  let!(:state) { create(:state, :name => "Colorado", :country => country) }
  let!(:shipping_method) { create(:shipping_method) }
  let!(:stock_location) { create(:stock_location) }
  let!(:payment_method) { create(:credit_card_payment_method) }
  #let!(:zone) { create(:zone) }
  let!(:product1) { create(:product, name: 'product1', option_values_hash: {size_option_type.id.to_s => size_option_type.option_value_ids} ) }


  it "should let a user purchase a product" do
    set_count_on_hand(product1,1)
    #login_as(user, scope: :spree_user)
    visit "/"
    click_link "Shop All Products"
    click_link 'product1'
    click_button 'Add To Cart'

    expect(current_path).to eql(spree.cart_path)
    expect(page).to have_content("product1")
    order = Spree::Order.last
    lines = Spree::LineItem.find_by_order_id(order.id)

    click_button "Checkout"
    fill_in "order_email", with: "test@example.com"
    click_button "Continue"
    fill_in_address
    click_button "Save and Continue"
    expect(current_path).to eql(spree.checkout_state_path("delivery"))
    expect(page).to have_content("product1")
    click_button "Save and Continue"

    click_button "Save and Continue"
    fill_in "Card Number", with: '4111111111111111'
    fill_in "Expiration", with: '10/20'
    fill_in "Card Code", with: '123'
    click_button "Save and Continue"
    click_button "Place Order"
    expect(current_path).to eql(spree.order_path(Spree::Order.last))
    expect(page).to have_content(Spree::Order.last.number)
    expect(page).to have_content("product1")
    line_item = Spree::LineItem.find_by_order_id(Spree::Order.last.id)
    expect(line_item.babe_id).to eq nil
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
    fill_in "#{address}_state_name", :with => "Colorado"
    fill_in "#{address}_zipcode", :with => "80302"
    fill_in "#{address}_phone", :with => "(555) 555-5555"
  end

end
