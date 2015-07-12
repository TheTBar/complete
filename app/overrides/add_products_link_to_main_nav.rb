Deface::Override.new(:virtual_path => 'spree/shared/_main_nav_bar',
                     :name => 'add_products_and_themes_links',
                     :insert_after => "li#home-link",
                     :text => "<li id=\"products-link\" data-hook><%= link_to Spree.t('Shop All Products'), products_path %></li>
                               <li id=\"themes-link\" data-hook><%= link_to Spree.t('Explore Themed Collections'), '/t/themes' %></li>
                               <li id=\"build-your-babe-link\" data-hook><%= link_to Spree.t('The Lingerie Concierge'), build_your_babe_path %></li>
")