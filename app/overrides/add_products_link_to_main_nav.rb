Deface::Override.new(:virtual_path => 'spree/shared/_main_nav_bar',
                     :name => 'add_products_link',
                     :insert_after => "li#home-link",
                     :text => "<li id=\"products-link\" data-hook><%= link_to Spree.t('products'), products_path %></li>")