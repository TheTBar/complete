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
      @taxons = Taxon.get_babes_available_package_list(@babe)
      if @taxons.count < 1
        # here we would want to log the failure to find items so that we can reach out to the customer
        # if its a guest the page should ask for email so we can contact them.
        Spree::BabeProductSearchFailure.new(spree_user_id: current_spree_user.id,spree_babe_id: @babe.id).save if current_spree_user
        render 'no_matching_packages_for_babe'
      end

    end

  end
end
