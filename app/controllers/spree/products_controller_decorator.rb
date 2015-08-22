module Spree
  ProductsController.class_eval do

    def show_package
      @taxon = Taxon.friendly.find(params[:id])
      return unless @taxon
      @searcher = build_searcher(params.merge(taxon: @taxon.id, include_images: true))
      @products = @searcher.retrieve_products.sort_by { |p| p.product_size_type.name} # makes sure bras are always displayed first
      @pre_selected_sizes = []
      if session.key?(:babe_id)
        @products.each do |product|
          @pre_selected_sizes.push(Spree::Babe.find(session[:babe_id]).size_value_for_size_option_type_name(product.product_size_type.name))
        end
      end
    end
  end
end
