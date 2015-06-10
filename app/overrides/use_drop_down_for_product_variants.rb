Deface::Override.new(:virtual_path => 'spree/products/_cart_form',
                     :name => 'use_drop_down_for_product_variants',
                     :replace_contents => '[id="product-variants"]',
                     :text => '
                                  <h3 class="product-section-title"><%= Spree.t(:variants) %></h3>
                              <%= select_tag "variant_id",
    options_for_select(@product.variants_and_option_values(current_currency).collect{ |v| ["#{variant_options(v)}  #{variant_price(v)}", v.id] })%>

');