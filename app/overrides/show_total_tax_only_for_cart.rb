Deface::Override.new(:virtual_path => 'spree/orders/_adjustments',
                     :name => 'show_total_tax_only_for_cart_ruby_logic',
                     :replace => "erb[silent]:contains('@order.all_adjustments.tax.eligible.group_by')",
                     :text => '<% if @order.additional_tax_total > 0.00 %>')


Deface::Override.new(:virtual_path => 'spree/orders/_adjustments',
                     :name => 'show_total_tax_only_for_cart_body',
                     :replace => "erb[loud]:contains(':type => Spree.t(:tax)')",
                     :text => '<tr class="adjustment">
    <td colspan="4" align="right"><h5>Tax:</h5></td>
    <td colspan="2">
      <h5><%= Spree::Money.new(@order.additional_tax_total, :currency => @order.currency) %></h5>
    </td>
  </tr>')