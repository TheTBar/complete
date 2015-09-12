Spree::Image.class_eval do
  attachment_definitions[:attachment][:styles] = {
      :mini => '48x48>', # thumbs under image
      :small => '100x100>', # images on category view
      :product => '240x240>', # full product image
      :product2 => '400x400>', # bigger product image
      :large => '600x600>' # light box image
  }
end