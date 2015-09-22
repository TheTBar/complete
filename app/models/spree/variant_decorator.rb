Spree::Variant.class_eval do

  has_many :effective_sizes, :class_name => 'Spree::EffectiveSize'

  after_create :create_effective_size_record

  def options_text
    values = self.option_values.sort do |a, b|
      a.option_type.position <=> b.option_type.position
    end

    values.to_a.map! do |ov|
      "#{ov.presentation}"
    end

    values.to_sentence({ words_connector: ", ", two_words_connector: ", " })
  end

  def options_text_by_name
    values = self.option_values.sort do |a, b|
      a.option_type.position <=> b.option_type.position
    end

    values.to_a.map! do |ov|
      "#{ov.name}"
    end

    values.to_sentence({ words_connector: ", ", two_words_connector: ", " })
  end

  def create_effective_size_record
    if self.is_master == false
      self.option_values.each do |ov|
        if ov.option_type.presentation.downcase == 'size'
            default_effective_size = ov.name
            es = Spree::EffectiveSize.new()
            es.effective_size = default_effective_size
            es.variant_id = self.id
            es.save
        end
      end
    end
  end

  def self.load_effective_sizes_to_associated_option_value_size
    Spree::Variant.where("is_master"=>false).each do |v|
      if v.effective_sizes.empty?
        v.create_effective_size_record
      end
    end
  end

  def self.assign_custom_effective_size_value_to_variant(product_id,current_effective_size,new_effective_size)
    Spree::EffectiveSize.joins(:variant => :option_values).where("spree_variants.product_id = #{product_id}").where("LOWER(spree_option_values.name) = '#{current_effective_size.downcase}'").update_all(:effective_size => new_effective_size)
  end

  def self.add_custom_effective_size_value_to_variant(product_id,option_value_name,effective_size)
    variants = Spree::Variant.joins(:option_values).where("spree_variants.product_id = #{product_id}").where("LOWER(spree_option_values.name) = '#{option_value_name.downcase}'")
    variants.each do |v|
      es = Spree::EffectiveSize.new()
      es.effective_size = effective_size
      es.variant_id = v.id
      es.save
    end
  end

  def self.size_matching_in_stock_option_value_for_babe(product_id,babe)
    if variant = Spree::Variant.joins(:effective_sizes).includes(:option_values => :option_type).joins(:stock_items).where("spree_variants.product_id = #{product_id}").where("LOWER(spree_effective_sizes.effective_size) in ('#{babe.bottoms.downcase}','#{babe.bra_size.downcase}','one size') AND spree_stock_items.count_on_hand > 0").first
      variant.option_values.each do |ov|
        if ov.option_type.isSizeOptionType?
          return ov.name.downcase
        end
      end
    end
  end
  
end