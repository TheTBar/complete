module Spree
  Product.class_eval do

    def variants_and_option_values_with_stock(current_currency = nil)
      filtered_collection = []
      variants_and_option_values(current_currency = nil).each do |variant|
        filtered_collection.push(variant) if variant.can_supply?
      end
      filtered_collection
    end

  end
end
