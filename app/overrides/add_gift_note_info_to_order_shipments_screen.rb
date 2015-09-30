Deface::Override.new(:virtual_path => 'spree/admin/orders/edit',
                     :name => 'add_gift_note_info_to_order_shipments_screen',
                     :insert_after => 'erb[loud]:contains("render partial: \'add_product\'")',
                     :text => '<% if !@order.gift_note.blank? %>
                     <div class="panel panel-default" id="gift-note" data-hook="gift-note">
  <div class="panel-heading">
    <h1 class="panel-title">
      Gift Note
    </h1>
  </div>
  <div class="panel-body">
    <strong><%= @order.gift_note %></strong>
  </div>
</div>
<% end %>
')