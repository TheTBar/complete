Deface::Override.new(:virtual_path => 'spree/shared/_user_form',
                     :name => 'add_name',
                     :insert_before => '[id="password-credentials"]',
                     :text => '
                       <div class="form-group">
    <%= f.label :name, Spree.t(:name) %>
    <%= f.text_field :name, :class => "form-control"%>
  </div>
');