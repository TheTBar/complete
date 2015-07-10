module Spree
  Product.class_eval do

    def variants_and_option_values_with_stock(current_currency = nil)
      filtered_collection = []
      variants_and_option_values(current_currency = nil).each do |variant|
        filtered_collection.push(variant) if variant.can_supply?
      end
      filtered_collection
    end

    add_search_scope :in_stock do
      # joins(variants_including_master: :stock_items).group('spree_products.id').having("SUM(count_on_hand) > 0")
      joins(:master => :prices, variants: :stock_items).where("#{StockItem.quoted_table_name}.count_on_hand > 0").uniq
    end
    search_scopes << :in_stock

    def self.available(available_on = nil, currency = nil)
      # joins(:master => :prices).where("#{Product.quoted_table_name}.available_on <= ?", available_on || Time.now).joins(variants_including_master: :stock_items).group('spree_products.id').having("SUM(count_on_hand) > 0")
      # joins(:master => :prices).where("#{Product.quoted_table_name}.available_on <= ?", available_on || Time.now)
      joins(:master => :prices, variants: :stock_items).where("#{StockItem.quoted_table_name}.count_on_hand > 0 AND #{Product.quoted_table_name}.available_on <= ?", available_on || Time.now).uniq
    end
    search_scopes << :available

  end
end
