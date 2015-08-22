Deface::Override.new(:virtual_path => 'spree/products/show_package',
                     :name => 'add_hidden_babe_id_field_if_present',
                     :insert_after => "erb[loud]:contains('product_count')",
                     :text => "<% if params['babe_id'] %><%= hidden_field_tag 'babe_id', params['babe_id'] %><% end %>"
);
