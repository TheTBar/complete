Deface::Override.new(:virtual_path => 'spree/orders/_form',
                     :name => 'add_gift_note_to_order',
                     :insert_after => '[id="line_items"]',
                     :text => '<tr class="cart-gift-note">
                                <td colspan="6" align="left">Add A Gift Note<span style="font-size: 10pt;padding-left: 15px;">(Handwritten by the TQueen herself)</span><br>
                                  <%= order_form.text_area :gift_note, cols: 40, rows: 4%>
                                </td>
                              </tr>
                     ')
