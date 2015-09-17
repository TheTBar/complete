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
        @products.each_with_index do |product,index|
          @pre_selected_sizes.push(index.to_s+'-'+Spree::Babe.find(session[:babe_id]).size_value_for_size_option_type_name(product.product_size_type.name))
        end
      end
    end

    def index
      @searcher = build_searcher(params.merge(include_images: true))
      @products = @searcher.retrieve_products.includes(:option_types)
      @products = @products.includes(:option_types).where("spree_products.show_in_main_search" => true).order('priority asc')
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end

  end
end
