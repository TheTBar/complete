Deface::Override.new(:virtual_path => 'spree/shared/x_header',
                     :name => 'add_landing_page',
                     :insert_after => '#spree-header > .container',
                     :text => '<% if  ["concierge_page"].include? params[:action] %>
    <div class="homegirl">
    </div>
  <% end %>');