require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!


describe "adding products to cart", type: :feature, js: true do


  let(:user) {FactoryGirl.create(:user)}

  before (:each) do
    login_as(user, scope: :spree_user)
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

  let!(:onesize_option_type) do
    build_option_type_with_values("one size", %w(OneSize))
  end


  let!(:product1) { create(:product, :name => 'product 1', option_values_hash: {onesize_option_type.id.to_s => onesize_option_type.option_value_ids}) }

  it "should not allow the user to add more items then are in stock" , js: true do
    product1.stock_items.each do |stock_item|
      stock_item.set_count_on_hand 1
      stock_item.backorderable = false
      stock_item.save
    end

    visit "/"
    click_link "Shop All Products"
    click_link "product 1"
    click_link "OneSize"
    fill_in('quantity', :with => '5')
    click_button "Add To Cart"
    expect(page).to have_content("Quantity selected of \"product 1 (OneSize)\" is not available.")
    expect(current_path).to eql(spree.product_path(product1))
  end


  # before do
  #   @trait1 = create(:babe_trait_type, name: 'trait1')
  #   create(:babe_trait_value, name: 'trait 1', spree_babe_trait_type_id: @trait1.id, vixen_value: 0, flirt_value: 0, romantic_value: 0, sophisticate_value: 0)
  # end


end
