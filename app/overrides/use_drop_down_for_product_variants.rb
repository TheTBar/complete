Deface::Override.new(:virtual_path => 'spree/products/_cart_form',
                     :name => 'use_drop_down_for_product_variants',
                     :replace_contents => '[id="product-variants"]',
                     :text => '
                                  <h4 class="product-section-title">Sizes</h4>
                              <%= select_tag "variant_id",
    options_for_select(@product.variants_and_option_values_with_stock(current_currency).collect{ |v| ["#{variant_options(v)}  #{variant_price(v)}", v.id] })%>

');