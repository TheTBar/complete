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

    def touch_taxons
      Spree::Taxon.where(id: taxon_and_ancestors.map(&:id)).update_all(updated_at: Time.current)
      # since all products in a package should have the same personality values, when any one of them is updated we can update the package taxon with the values
      Spree::Taxon.where(id: taxon_and_ancestors.map(&:id)).where(is_package_node: true).update_all(vixen_value: self.vixen_value, flirt_value: self.flirt_value, sophisticate_value: self.sophisticate_value, romantic_value: self.romantic_value)
      Spree::Taxonomy.where(id: taxonomy_ids).update_all(updated_at: Time.current)
    end

    def product_size_type
      # returns the size type of this product (named sizes, bra sizes, number sizes)
      self.option_types.each do |ot|
        if ot.presentation.downcase == 'size'
          return ot.name
        end
      end
      return nil
    end

    def does_product_have_stock_on_hand_for_option_value?(name)
      self.stock_items.each do |stock_item|
        if !stock_item.variant.is_master?
          if stock_item.variant.option_values.first.name.downcase == name.downcase
            return stock_item.count_on_hand > 0
          end
        end
      end
      false
    end

    def product_count_on_hand_hash_by_option_value_name
      count_hash_by_option_value_name = {}
      self.stock_items.each do |stock_item|
        if !stock_item.variant.is_master?
          count_hash_by_option_value_name[stock_item.variant.option_values.first.name] = stock_item.count_on_hand
        end
      end
      count_hash_by_option_value_name
    end

    def product_count_on_hand_hash_by_option_value_id
      count_hash_by_option_value_id = {}
      self.stock_items.each do |stock_item|
        if !stock_item.variant.is_master?
          count_hash_by_option_value_id[stock_item.variant.option_values.first.id] = stock_item.count_on_hand
        end
      end
      count_hash_by_option_value_id
    end

    private

    # Builds variants from a hash of option types & values
    def build_variants_from_option_values_hash
      ensure_option_types_exist_for_values_hash
      values = option_values_hash.values
      values = values.inject(values.shift) { |memo, value| memo.product(value).map(&:flatten) }
      values.each do |ids|
        sku_string = Spree::Product.get_sku_string_from_option_values(ids)
        variant = variants.create(
            option_value_ids: ids,
            price: master.price,
            sku: master.sku+sku_string
        )
      end
      save
    end

    def self.get_sku_string_from_option_values(ids)
      sku_string = ''
      [*ids].each do |id|
        option_type = Spree::OptionValue.find(id)
        sku_string = sku_string+"-#{option_type.presentation}"
      end
      sku_string
    end

  end
end
