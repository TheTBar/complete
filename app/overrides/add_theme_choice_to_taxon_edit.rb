Deface::Override.new(:virtual_path => 'spree/admin/taxons/_form',
                     :name => 'add_theme_choice_to_taxon_edit',
                     :insert_before => "erb[loud]:contains('f.field_container :meta_title')",
                     :text => '
<%= f.field_container "theme_taxon_id" do %>
  <%= f.label "theme_taxon_id", Spree.t("Theme") %><p>
  <%#= select_tag(:theme_taxon_id, options_from_collection_for_select(Spree::Taxon.where(parent_id: 1).all, :id, :name, :selected => @taxon.theme_taxon_id), { include_blank: true } )%>
  <%= f.select :theme_taxon_id, options_from_collection_for_select(Spree::Taxon.where(parent_id: 1).all, :id, :name, :selected => @taxon.theme_taxon_id), :include_blank => true %>
<% end %>

  ')