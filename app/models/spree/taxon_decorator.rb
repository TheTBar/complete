Spree::Taxon.class_eval do

  before_create :check_for_sets_parent

  validate :check_for_package_node

  attr_accessor :babes_variants_for_taxons_products, :package_price, :package_brand, :has_color_options

  has_attached_file :icon,
                    styles: { mini: '32x32>', normal: '128x128>', display: '240x240>', large: '600x600'},
                    default_style: :mini,
                    url: '/spree/taxons/:id/:style/:basename.:extension',
                    path: ':rails_root/public/spree/taxons/:id/:style/:basename.:extension',
                    default_url: '/assets/default_taxon.png'

  taxon_attachment_config = {

      s3_credentials: {
          access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
          secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
          bucket:            ENV['S3_TAXON_BUCKET_NAME']
      },

      storage:        :s3,
      s3_headers:     { "Cache-Control" => "max-age=31557600" },
      s3_protocol:    "https",
      bucket:         ENV['S3_TAXON_BUCKET_NAME'],
      url:            ":s3_domain_url",

      styles: {
          mini:     "48x48>",
          small:    "100x100>",
          display:  "240x240>",
          display2:  "400x400>",
          large:    "600x600>"
      },

      path:           "/:class/:id/:style/:basename.:extension",
      default_url:    "/:class/:id/:style/:basename.:extension",
      default_style:  "display"
  }
  taxon_attachment_config.each do |key, value|
    Spree::Taxon.attachment_definitions[:icon][key.to_sym] = value
  end

  def check_for_sets_parent
    if parent.present?
      if self.parent.name == 'Sets'
        self.is_package_node = true
      end
    end
  end

  def check_for_package_node
    if parent.present?
      if self.parent.is_package_node == true
        errors.add :parent_id, "Parent cannot be a Set"
      end
    end
  end

  def self.get_babes_package_list(babe)
    personality = babe.personality
    primary_personality_limit = personality[0][1].floor - 1
    Spree::Taxon.where(is_package_node: true).where("\"spree_taxons\".\"#{personality[0][0]}\" >= #{primary_personality_limit}").includes({:products => :option_types}).order("#{personality[0][0]} DESC, #{personality[1][0]} DESC")
  end

  def self.get_babes_available_package_list(babe)

    # perhaps could use this to get all products and then see if the current product exists in that size.  would be far less queries
    # if performance is bad the other way may have to invoke this.
    # Spree::Product.joins(:variants_including_master => :option_values)
    #   .where('spree_option_values.presentation = ? AND
    #       spree_option_values.option_type_id = ?', 'XL',
    #          Spree::OptionType.find_by_name('tshirt-size').id)

    available_taxons = []
    product_variants_in_babes_sizes = Spree::Variant.select("spree_products.id as product_id,spree_variants.id as id").joins(:product).joins(:option_values).joins(:stock_items).where("LOWER(spree_option_values.name) in ('#{babe.bottoms.downcase}','#{babe.bra_size.downcase}','one size') AND spree_stock_items.count_on_hand > 0")
    get_babes_package_list(babe).each do |taxon|
      taxon_is_available = true
      size_matched_variants = []
      package_price = 0.00
      taxon.products.each do |product|
        product_variant = product_variants_in_babes_sizes.detect{|pv| pv.product_id == product.id}
        taxon_is_available = product_variant != nil
        break unless taxon_is_available
        if product.is_size_only_variant?
           size_matched_variants.push(product_variant.id)
        end
        package_price = package_price + product.price_in("USD").amount
        taxon.package_brand = product.brand
        taxon.has_color_options = true if there_are_color_options(product)
      end
      taxon.package_price = sprintf('%.0f', package_price)
      if taxon_is_available
        taxon.babes_variants_for_taxons_products = size_matched_variants if size_matched_variants.count > 0
        available_taxons.push(taxon)
      end
    end
    available_taxons
  end

  private

  def self.there_are_color_options(product)
    product.option_types.each do |ot|
      return true if ot.name == 'Colors'
    end
    return false
  end


end