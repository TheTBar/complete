Deface::Override.new(:virtual_path => 'spree/taxons/show',
                     :name => 'do_not_show_taxon_name_as_title',
                     :replace => "erb[loud]:contains('@taxon.name')",
                     :text => '&nbsp;');

Deface::Override.new(:virtual_path => 'spree/taxons/show',
                     :name => 'do_not_show_taxon_products_unless_show_products_flag_is_set_on_taxon',
                     :surround_contents => '[data-hook="taxon_products"]',
                     :text => '<% if @taxon.show_products %><%= render_original %><% end %>');


Deface::Override.new(:virtual_path => 'spree/taxons/show',
                     :name => 'show_themed_colections',
                     :surround_contents => '[data-hook="taxon_children"]',
                     :text => "<% if @taxon.show_products == false %><%= render_original %><% end %>");
