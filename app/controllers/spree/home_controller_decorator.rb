module Spree
  HomeController.class_eval do

    caches_page :concierge_page, :about, :ourstory, :privacy_policy, :returns_and_exchanges, :terms_of_use, :sizing
    
    def concierge_page
    end

    def about
    end

    def ourstory
    end

    def privacy_policy
    end

    def returns_and_exchanges
    end

    def terms_of_use
    end

    def sizing
    end

    def how_the_wishlist_works
    end

    def csrf_meta_tags
      render layout: false
    end

  end
end
