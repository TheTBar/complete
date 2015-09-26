Deface::Override.new(:virtual_path => 'spree/checkout/_summary',
                     :name => 'show_total_tax_only_for_checkout_summary',
                     :replace_contents => '[data-hook="order_details_tax_adjustments"]',
                     :text => '  <% if @order.additional_tax_total > 0.00 %>
    <tr class="total">
      <td>Tax:</td>
      <td><%= Spree::Money.new(@order.additional_tax_total, :currency => @order.currency).to_html %></td>
    </tr>
  <% end %>');