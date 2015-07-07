Deface::Override.new(:virtual_path => 'spree/admin/products/_form',
                     :name => 'add_brand_to_product_edit',
                     :insert_after => "erb[loud]:contains('text_field :available')",
                     :text => "
    <%= f.field_container :brand, class:['form-group'] do %>
      <%= f.label :brand, raw(Spree.t(:brand) + content_tag(:span, ' *')) %><p>
      <%= f.text_field :brand, :value => @product.brand %>
    <% end %>
")