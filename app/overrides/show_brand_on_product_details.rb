Deface::Override.new(:virtual_path => 'spree/products/show',
                     :name => 'show_brand_on_product_details',
                     :insert_before => '[class="product-title"]',
                     :text => '<h1 class="product-brand" itemprop="brand"><%= @product.brand %></h1>');