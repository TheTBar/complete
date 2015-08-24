Deface::Override.new(:virtual_path => 'spree/products/_cart_form',
                     :name => 'add_preselect_for_one_size',
                     :insert_after => '[data-hook="inside_product_cart_form"]',
                     :text => '<script type="text/javascript">
                                $(function () {
                                  if (elem = $("#onesize")) {
                                    elem.click();
                                  }
                                });
                              </script>
                              ')