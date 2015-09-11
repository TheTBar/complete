Deface::Override.new(:virtual_path => 'spree/products/_thumbnails',
                     :name => 'use_larger_image_for_rollover_image',
                     :replace => "erb[loud]:contains('i.attachment.url(:product)')",
                     :text => '
<%= link_to(image_tag(i.attachment.url(:mini), class: "thumbnail"), i.attachment.url(:product2)) %>

  ')