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
          return ot
        end
      end
      return nil
    end

    def product_size_type_name_string
      self.product_size_type.name.downcase.gsub(/\s+/, "")
    end

    def does_product_have_stock_on_hand_for_option_value?(name)
      self.stock_items.each do |stock_item|
        if !stock_item.variant.is_master?
          #puts "checking size: #{stock_item.variant.option_values.first.name.downcase}"
          if stock_item.variant.option_values.first.name.downcase == name.downcase
            return stock_item.count_on_hand > 0
          end
        end
      end
      false
    end

    def does_product_have_stock_on_hand_for_size_option_value?(size_option_name)
      #puts "checking: #{size_option_name.downcase}"
      return product_count_on_hand_hash_by_size_option_value_name[size_option_name.downcase] > 0
    end

    def product_count_on_hand_hash_by_option_value_name
      count_hash_by_option_value_name = {}
      self.stock_items.each do |stock_item|
        if !stock_item.variant.is_master?
          # puts stock_item.inspect
          # puts stock_item.variant.option_values.inspect
          count_hash_by_option_value_name[get_option_value_string_for_stock_item(stock_item)] = stock_item.count_on_hand
        end
      end
      count_hash_by_option_value_name
    end

    def product_count_on_hand_hash_by_size_option_value_name
      count_hash_by_option_value_name = Hash.new(0)
      self.stock_items.each do |stock_item|
        if !stock_item.variant.is_master?
          count_hash_by_option_value_name[get_size_option_value_for_stock_item(stock_item).name.downcase] += stock_item.count_on_hand
        end
      end
      #puts count_hash_by_option_value_name.inspect
      count_hash_by_option_value_name
    end

    def get_variant_id_of_first_matching_size(size_name)
      size_hash = variants_and_option_values_with_stock(nil).collect{ |v| ["#{v.options_text_by_name.downcase}", v.id] }.to_h
      if id = size_hash[size_name]
        return id
      end
      size_hash.each do |k,v|
        if k.include? size_name
          return v
        end
      end
    end

    def is_size_only_variant?
      return self.option_types.count == 1 && self.option_types.first.presentation.downcase == 'size'
    end

    # def product_count_on_hand_hash_by_option_value_id
    #   count_hash_by_option_value_id = {}
    #   self.stock_items.each do |stock_item|
    #     if !stock_item.variant.is_master?
    #       count_hash_by_option_value_id[stock_item.variant.option_values.first.id] = stock_item.count_on_hand
    #     end
    #   end
    #   count_hash_by_option_value_id
    # end

    def grouped_option_values
      @_grouped_option_values ||= option_values.group_by(&:option_type)
      @_grouped_option_values.sort_by { |option_type, option_values| option_type.position }
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

    def get_option_value_string_for_stock_item(stock_item)
      variant_string = ''
      ovs = stock_item.variant.option_values.sort_by { |ovalue| ovalue.option_type.position}
      ovs.each do |ov|
        variant_string = variant_string + ov.name + "-"
      end
      variant_string[0...-1]
    end

    def get_size_option_value_for_stock_item(stock_item)
      ot_id = product_size_type.id
      stock_item.variant.option_values.each do |ov|
        if ov.option_type_id == ot_id
          return ov
        end
      end
    end

  end
end
