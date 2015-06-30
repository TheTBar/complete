Spree::Taxon.class_eval do

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
# Load user defined paperclip settings
#     s3_creds = { :access_key_id => Spree::Config[:access_key_id], :secret_access_key => Spree::Config[:secret_access_key], :bucket => Spree::Config[:bucket] }
#     Spree::Taxon.attachment_definitions[:icon][:storage] = :s3
#     Spree::Taxon.attachment_definitions[:icon][:s3_credentials] = s3_creds
#     Spree::Taxon.attachment_definitions[:icon][:s3_headers] = ActiveSupport::JSON.decode(Spree::Config[:s3_headers])
#     Spree::Taxon.attachment_definitions[:icon][:bucket] = Spree::Config[:s3_bucket]


end