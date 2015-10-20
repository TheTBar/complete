Deface::Override.new(:virtual_path => 'spree/shared/_order_details',
                     :name => 'show_total_tax_only_for_order_show',
                     :replace_contents => '[data-hook="order_details_tax_adjustments"]',
                     :text => '
        <tr class="total">
          <td colspan="4" align="right" class="text-muted"><strong>Total Tax:</strong></td>
          <td class="total"><span><%= Spree::Money.new(order.additional_tax_total, currency: order.currency) %></span></td>
        </tr>
        ')

Deface::Override.new(:virtual_path => 'spree/shared/_order_details',
                     :name => 'remove_extra_promotion_row',
                     :remove => '[data-hook="order_details_adjustments"]'
                     )
