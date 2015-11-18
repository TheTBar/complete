Deface::Override.new(:virtual_path => 'spree/products/show_package',
                     :name => 'add_link_to_babes_selections',
                     :insert_before => '[data-hook="package_left_part_wrap"]',
                     :text => '<% if session[:babe_id] %><div id="back-to-our-picks-for-babe-button" style="padding-top: 15px;">
      <%= link_to "Back To Our Picks For #{Spree::Babe.find(session[:babe_id]).display_name_babe}", my_babes_package_list_path(session[:babe_id]), :class => "btn btn-success our-picks-for-babe-button", :id => "see-our-pics" %>
</div> <%end%>'
                    );

Deface::Override.new(:virtual_path => 'spree/orders/edit',
                     :name => 'remove_or',
                     :remove => "erb[loud]:contains('Spree.t(:or)')"
                    );


Deface::Override.new(:virtual_path => 'spree/orders/edit',
                     :name => 'add_link_to_babes_selections_at_cart',
                     :replace => "erb[loud]:contains('link_to Spree.t(:continue_shopping)')",
                     :text => '
                      <% if session[:babe_id] %>
    <div id="our-picks-for-babe-button">
      <%= link_to "Back To Our Picks For #{Spree::Babe.find(session[:babe_id]).display_name_babe}", my_babes_package_list_path(session[:babe_id]), :class => "btn btn-success", :id => "see-our-pics" %>
</div>
  <% end %>'
                    );