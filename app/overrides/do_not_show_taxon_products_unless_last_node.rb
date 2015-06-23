Deface::Override.new(:virtual_path => 'spree/taxons/show',
                     :name => 'do_not_show_taxon_products_unless_last_node',
                     :surround_contents => '[data-hook="taxon_products"]',
                     :text => '<% if @taxon.children.size == 0 %><%= render_original %><% end %>');


Deface::Override.new(:virtual_path => 'spree/taxons/_taxon',
                     :name => 'show_taxon_icon',
                     :replace => "erb[loud]:contains('spree/shared/products')",
                     :text => '<%= link_to(image_tag(taxon.icon(:display)), seo_url(taxon)) unless taxon.icon_file_name.nil? %>');