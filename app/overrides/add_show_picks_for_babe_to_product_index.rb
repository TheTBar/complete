Deface::Override.new(:virtual_path => 'spree/products/index',
                     :name => 'add_show_picks_for_babe_link_to_product_list',
                     :insert_before => "erb[silent]:contains('if params[:keywords]')",
                     :text => '<div class="products-top-section">
  <% if session[:babe_id] %>
    <div id="our-picks-for-babe-button">
      <%= link_to "See Our Picks For #{Spree::Babe.find(session[:babe_id]).display_name_babe}", my_babes_package_list_path(session[:babe_id]), :class => "btn btn-success", :id => "see-our-pics" %>
</div>
  <% end %>
</div>');