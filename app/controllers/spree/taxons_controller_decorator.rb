module Spree
  TaxonsController.class_eval do

    def show
      @taxon = Taxon.friendly.find(params[:id])
      return unless @taxon

      @searcher = build_searcher(params.merge(taxon: @taxon.id, include_images: true))
      @products = @searcher.retrieve_products
      @taxonomies = Spree::Taxonomy.includes(root: :children)
      if @taxon.parent && @taxon.parent.name == "Themes"
        @themed_packages = Taxon.where(:theme_taxon_id => @taxon.id).all
      end
    end

    def my_babes_package_list
      @babe = Spree::Babe.find(params[:id])
      #set babe_id on session
      session[:babe_id] = @babe.id
      @taxons = Taxon.get_babes_package_list(@babe)
      return unless @taxons
    end

  end
end
