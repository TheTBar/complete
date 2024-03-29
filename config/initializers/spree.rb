# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# Note: If a preference is set here it will be stored within the cache & database upon initialization.
#       Just removing an entry from this initializer will not make the preference value go away.
#       Instead you must either set a new value or remove entry, clear cache, and remove database entry.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
Spree.config do |config|
  # Example:
  # Uncomment to stop tracking inventory levels in the application
  # config.track_inventory_levels = false
    config.products_per_page = 50
    config.admin_products_per_page = 50
end

SpreeVariantOptions::VariantConfig.main_option_type_id = 0

Spree.user_class = "Spree::User"

attachment_config = {

    s3_credentials: {
        access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        bucket:            ENV['S3_BUCKET_NAME']
    },

    storage:        :s3,
    s3_headers:     { "Cache-Control" => "max-age=31557600" },
    s3_protocol:    "https",
    bucket:         ENV['S3_BUCKET_NAME'],
    url:            ":s3_domain_url",

    styles: {
        mini:     "48x48>",
        small:    "100x100>",
        product:  "240x240>",
        product2:  "400x400>",
        large:    "600x600>"
    },

    path:           "/:class/:id/:style/:basename.:extension",
    default_url:    "/:class/:id/:style/:basename.:extension",
    default_style:  "product"
}

attachment_config.each do |key, value|
  Spree::Image.attachment_definitions[:attachment][key.to_sym] = value
end


Premailer::Rails.config.merge!(preserve_styles: true, remove_ids: true)

Spree::PermittedAttributes.user_attributes.push :name

Spree::PermittedAttributes.taxon_attributes << :theme_taxon_id

Spree::PermittedAttributes.line_item_attributes << :babe_id

Spree::PermittedAttributes.product_attributes.push :show_in_main_search

Spree::PermittedAttributes.checkout_attributes << :gift_note

Spree::Admin::ReportsController.add_available_report!(:abandoned_carts, 'Abandoned Carts Data')
