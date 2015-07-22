Deface::Override.new(:virtual_path => 'spree/admin/products/_form',
                     :name => 'add_babe_metrix_to_product_edit',
                     :insert_after => "erb[loud]:contains('text_field :available')",
                     :text => "
    <%= f.field_container :vixen_value, class:['form-group'] do %>
      <%= f.label :vixen_value, raw(Spree.t(:vixen_value) + content_tag(:span, ' *')) %><p>
      <%= f.select :vixen_value, options_for_select((0..5),:selected => @product.vixen_value) %>
    <% end %>
    <%= f.field_container :flirt_value, class:['form-group'] do %>
      <%= f.label :flirt_value, raw(Spree.t(:flirt_value) + content_tag(:span, ' *')) %><p>
      <%= f.select :flirt_value, options_for_select((0..5),:selected => @product.flirt_value) %>
    <% end %>
    <%= f.field_container :romantic_value, class:['form-group'] do %>
      <%= f.label :romantic_value, raw(Spree.t(:romantic_value) + content_tag(:span, ' *')) %><p>
      <%= f.select :romantic_value, options_for_select((0..5),:selected => @product.romantic_value) %>
    <% end %>
    <%= f.field_container :sophisticate_value, class:['form-group'] do %>
      <%= f.label :sophisticate_value, raw(Spree.t(:sophisticate_value) + content_tag(:span, ' *')) %><p>
      <%= f.select :sophisticate_value, options_for_select((0..5),:selected => @product.sophisticate_value) %>
    <% end %>
  ")