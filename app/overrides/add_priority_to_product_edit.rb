Deface::Override.new(:virtual_path => 'spree/admin/products/_form',
                     :name => 'add_priority_to_product_edit',
                     :insert_after => "erb[loud]:contains('text_field :available')",
                     :text => "<p>
    <%= f.field_container :priority, class:['form-group'] do %>
      <%= f.label :priority, 'Order' %><p>
      <%= f.text_field :priority, :value => @product.priority %>
    <% end %>
")