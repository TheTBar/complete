Deface::Override.new(:virtual_path => 'spree/taxons/show',
                     :name => 'do_not_show_taxon_products_unless_show_products_flag_is_set_on_taxon',
                     :surround_contents => '[data-hook="taxon_products"]',
                     :text => '<% if @taxon.show_products %><%= render_original %><% end %>');


Deface::Override.new(:virtual_path => 'spree/taxons/x_taxon',
                     :name => 'show_taxon_icon',
                     :replace => "erb[loud]:contains('spree/shared/products')",
                     :text => '<%= link_to(image_tag(taxon.icon(:display)), show_package_path(taxon)) unless taxon.icon_file_name.nil? %>');