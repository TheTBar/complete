require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!


describe "Product results", type: :feature do


  context "there products that should not be shown in main search" do
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

    let!(:number_size_option_type) do
      build_option_type_with_values("number sizes", %w(1 2 3 4))
    end

    let!(:product1) { create(:product, name: 'Girl Product', vixen_value: 5, flirt_value: 3, sophisticate_value: 1, romantic_value:1, option_values_hash: {number_size_option_type.id.to_s => number_size_option_type.option_value_ids}) }
    let!(:product2) { create(:product, name: 'Boy Product', show_in_main_search: false, option_values_hash: {number_size_option_type.id.to_s => number_size_option_type.option_value_ids}) }

    it "should only return the Girl Product on shop all products" do
      set_count_on_hand_for_size(product1,'3',1)
      set_count_on_hand_for_size(product2,'3',1)
      visit "/products"
      puts page.body
      expect(page).to have_content(/Girl Product/i)
      expect(page).to_not have_content(/Boy Product/i)
    end

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



end
