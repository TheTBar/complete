Deface::Override.new(:virtual_path => 'spree/products/show_package',
                     :name => 'add_link_to_babes_selections',
                     :insert_before => '[data-hook="package_left_part_wrap"]',
                     :text => "<%= link_to Spree.t('Back To Babes Search Results'), my_babes_package_list_path(session['babe_id']) if session['babe_id'] %>"
                    );

Deface::Override.new(:virtual_path => 'spree/orders/edit',
                     :name => 'add_link_to_babes_selections_at_cart',
                     :insert_after => "erb[loud]:contains('link_to Spree.t(:continue_shopping)')",
                     :text => "
                      <%= Spree.t(:or) if session['babe_id'] %>
                      <%= link_to Spree.t('Back To Babes Search Results'), my_babes_package_list_path(session['babe_id']) if session['babe_id'] %>"
                    );