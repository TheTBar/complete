module Spree
  ProductsController.class_eval do

    def show_package
      @taxon = Taxon.friendly.find(params[:id])
      return unless @taxon
      @searcher = build_searcher(params.merge(taxon: @taxon.id, include_images: true))
      @products = @searcher.retrieve_products.sort_by { |p| p.product_size_type.name} # makes sure bras are always displayed first
      package_price = 0.00
      @products.each do |p|
        package_price = package_price + p.price_in(current_currency).amount
      end
      @taxon.package_price = sprintf('%.0f', package_price)
      @pre_selected_sizes = []
      if session.key?(:babe_id)
        babe = Spree::Babe.find(session[:babe_id])
        @products.each_with_index do |product,index|
          size = Spree::Variant.size_matching_in_stock_option_value_for_babe(product.id,babe)
          @pre_selected_sizes.push(index.to_s+'-'+size)
        end
      end
    end

    def index
      @searcher = build_searcher(params.merge(include_images: true))
      @products = @searcher.retrieve_products.includes(:option_types)
      @products = @products.includes(:option_types).where("spree_products.show_in_main_search" => true).order('priority asc')
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end

    def show
      @variants = @product.variants_including_master.active(current_currency).includes([:option_values, :images])
      @product_properties = @product.product_properties.includes(:property)
      @taxon = Spree::Taxon.find(params[:taxon_id]) if params[:taxon_id]
      @additional_products = load_additional_products
    end

    def load_additional_products
      additional_products = []
      @product.taxons.each do |taxon|
        if taxon.is_package_node
          taxon.products.each do |taxon_product|
            if taxon_product.id != @product.id
              additional_products.push(taxon_product);
            end
          end
        end
      end
      return additional_products
    end

  end
end
