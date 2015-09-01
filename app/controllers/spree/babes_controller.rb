module Spree
  class BabesController < Spree::StoreController

    before_action :set_babe, only: [:show, :edit, :update, :destroy]

    def index
      @babes = Babe.where("spree_user_id = #{spree_current_user.id}")
    end

    def access_concierge
      if (spree_current_user && spree_current_user.has_babes?)
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
      if bottom_hash[bottoms]
        @babe.bottoms = bottom_hash[bottoms]
      end
    end

    def babe_params
      params.require(:babe).permit(:spree_user_id, :body_type_id, :name, :height, :band, :cup, :bottoms, :number_size, :vixen_value, :romantic_value, :flirt_value, :sophisticate_value)
    end


  end
end