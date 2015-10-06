module Spree
  class BabesController < Spree::StoreController

    before_action :set_babe, only: [:show, :edit, :update, :destroy]


    # need to figure out how to get the session token onto the form for submission if the page is cached
    #caches_page :new

    def index

      #@babes = Babe.where("spree_user_id = #{spree_current_user.id} OR guest_token = '#{cookies.signed[:guest_token]}'")
      # babe_params = {}
      # babe_params['spree_user_id'] = spree_current_user.id if spree_current_user
      # babe_params['guest_token'] = cookies.signed[:guest_token] if cookies.signed[:guest_token].present?
      # @babes = Babe.where(babe_params).where_values.reduce(:or)

      if spree_current_user && !cookies.signed[:guest_token].present?
        @babes = Babe.where(:spree_user_id => spree_current_user.id)
      elsif !spree_current_user && cookies.signed[:guest_token].present?
        @babes = Babe.where(:guest_token => cookies.signed[:guest_token])
      elsif spree_current_user && cookies.signed[:guest_token].present?
        @babes = Babe.where("spree_user_id = #{spree_current_user.id} OR guest_token = '#{cookies.signed[:guest_token]}'")
      else
        redirect_to new_babe_path
      end

      if spree_current_user && spree_current_user.id == 1
        @babes = @babes.last(5)
      end
      @babes
    end

    def current_guest_token_has_babes?
      if cookies.signed[:guest_token].present?
        return (Spree::Babe.where("guest_token = '#{cookies.signed[:guest_token]}'").count > 0)
      end
    end

    def access_concierge
      if (spree_current_user && spree_current_user.has_babes?) || current_guest_token_has_babes?
        redirect_to babes_path
      else
        redirect_to new_babe_path
      end
    end

    def new
      @babe = Babe.new
      @active_traits = Spree::BabeTraitType.where("active = ?",true)
    end

    def create
      babe_personality_traits = []
      for i in 1..params[:number_of_active_traits].to_i
        babe_personality_traits.push(Spree::BabeTraitValue.find(params["babe_trait_#{i}"]))
      end
      @babe = Spree::Babe.new(babe_params)
      setBottomSize(@babe.bottoms);
      @babe.spree_user_id = spree_current_user.id if spree_current_user
      @babe.set_personality_from_trait_array(babe_personality_traits) if babe_personality_traits.size > 0
      @babe.guest_token = cookies.signed[:guest_token] if cookies.signed[:guest_token].present?
      respond_to do |format|
        if @babe.save
          format.html {redirect_to my_babes_package_list_path(@babe)}
        else
          format.html { render :new }
        end
      end
    end

    

    def destroy
      @babe.destroy
      respond_to do |format|
        format.html { redirect_to build_your_babe_path, notice: 'Your babe was successfully deleted. Hopefully you will find plenty of new distractions.' }
      end
    end

    private

    def set_babe
      @babe = Babe.find(params[:id])
    end
    
    def setBottomSize(bottoms)
      bottom_hash = {'XS'=>'XSmall','S'=>'Small','M'=>'Medium','L'=>'Large','XL'=>'XLarge'}
      number_size_hash = {'XSmall'=>'1','Small'=>'2','Medium'=>'3','Large'=>'4','XLarge'=>'5'}
      if bottom_hash[bottoms]
        @babe.bottoms = bottom_hash[bottoms]
      end
      @babe.number_size = number_size_hash[@babe.bottoms]
    end

    def babe_params
      params.require(:babe).permit(:spree_user_id, :body_type_id, :name, :height, :band, :cup, :bottoms, :number_size, :vixen_value, :romantic_value, :flirt_value, :sophisticate_value, :guest_email)
    end


  end
end