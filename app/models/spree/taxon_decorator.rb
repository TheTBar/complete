Spree::Taxon.class_eval do

  before_create :check_for_sets_parent

  validate :check_for_package_node


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
    # puts personality[0][0]
    # puts personality[0][1]
    # personality.each {|name,value| puts "#{name} = #{value}" }
    # puts Spree::Taxon.where(is_package_node: true).where("\"spree_taxons\".\"#{personality[0][0]}\" >= #{personality[0][1].floor}").order("#{personality[0][0]} DESC, #{personality[1][0]} DESC").to_sql
    Spree::Taxon.where(is_package_node: true).where("\"spree_taxons\".\"#{personality[0][0]}\" >= #{personality[0][1].floor}").order("#{personality[0][0]} DESC, #{personality[1][0]} DESC")
  end

  def self.get_babes_available_package_list(babe)

    # perhaps could use this to get all products and then see if the current product exists in that size.  would be far less queries
    # if performance is bad the other way may have to invoke this.
    # Spree::Product.joins(:variants_including_master => :option_values)
    #   .where('spree_option_values.presentation = ? AND
    #       spree_option_values.option_type_id = ?', 'XL',
    #          Spree::OptionType.find_by_name('tshirt-size').id)

    available_taxons = []
    get_babes_package_list(babe).each do |taxon|
      taxon_is_available = true
      taxon.products.each do |product|
        #taxon_is_available = false unless product.does_product_have_stock_on_hand_for_option_value?(babe.size_value_for_size_option_type_name(product.product_size_type.name))
        taxon_is_available = false unless product.does_product_have_stock_on_hand_for_size_option_value?(babe.size_value_for_size_option_type_name(product.product_size_type.name))
        break unless taxon_is_available
      end
      available_taxons.push(taxon) if taxon_is_available
    end
    available_taxons
  end


end