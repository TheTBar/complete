Deface::Override.new(:virtual_path => 'spree/products/_cart_form',
                     :name => 'use_drop_down_for_product_variants',
                     :replace_contents => '[id="product-variants"]',
                     :text => '
                                  <h4 class="product-section-title">Sizes</h4>
                              <%= select_tag "variant_id",
    options_for_select(@product.variants_and_option_values_with_stock(current_currency).collect{ |v| ["#{variant_options(v)}  #{variant_price(v)}", v.id] })%>

');


Deface::Override.new(:virtual_path => 'spree/products/_multi_item_cart_form_element',
                     :name => 'use_drop_down_for_product_variants_in_package',
                     :replace_contents => '[id="product-variants"]',
                     :text => '
                 <h4 class="product-section-title">Sizes</h4>
                 <% id = @product.variants_and_option_values_with_stock(current_currency).collect{ |v| ["#{variant_options(v).downcase}", v.id] }.to_h[Spree::Babe.find(session[:babe_id]).size_value_for_size_option_type_name(@product.product_size_type).downcase] if session.key?(:babe_id)%>
                 <%= select_tag "variant_id_#{index}",options_for_select(@product.variants_and_option_values_with_stock(current_currency).collect{ |v| ["#{variant_options(v)}  #{variant_price(v)}", v.id] }, selected: "#{id}")%>
');



