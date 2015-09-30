Deface::Override.new(:virtual_path => 'spree/admin/orders/edit',
                     :name => 'add_custom_shipping_info_to_order_shipments_screen',
                     :insert_after => 'erb[loud]:contains("render partial: \'add_product\'")',
                     :text => '<div class="panel panel-default" id="customer-shipping-information" data-hook="customer-shipping-info">
  <div class="panel-heading">
    <h1 class="panel-title">
      Customer Shipping Information
    </h1>
  </div>
  <div class="panel-body">
    Name: <strong><%= @order.shipping_address.first_name %> <%= @order.shipping_address.last_name %></strong> &nbsp;&nbsp;&nbsp;&nbsp; Phone: <strong><%= @order.shipping_address.phone %></strong> &nbsp;&nbsp;&nbsp;&nbsp; Email: <strong><%= @order.email %></strong><p></p>
    <strong><%= @order.shipping_address.address1 %><br>
      <% if !@order.shipping_address.address2.blank? %>
        <%= @order.shipping_address.address2 %><br>
      <% end %>
      <%= @order.shipping_address.city %>, <%= @order.shipping_address.state.abbr%> <%= @order.shipping_address.zipcode %></strong>
  </div>
</div>')