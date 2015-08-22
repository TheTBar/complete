require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!


describe "babes link", type: :feature do

  before do
    @city_trait = create(:babe_trait_type, name: 'city')
    create(:babe_trait_value, name: 'city 1', spree_babe_trait_type_id: @city_trait.id, vixen_value: 5, flirt_value: 4, romantic_value: 3, sophisticate_value: 2)
    @date_trait = create(:babe_trait_type, name: 'date')
    create(:babe_trait_value, name: "date 1", spree_babe_trait_type_id: @date_trait.id, vixen_value: 4, flirt_value: 4, romantic_value: 2, sophisticate_value: 1)
    @shoe_trait = create(:babe_trait_type, name: 'shoe', active: false)
    create(:babe_trait_value, name: "shoe 1", spree_babe_trait_type_id: @shoe_trait.id, vixen_value: 1, flirt_value: 5, romantic_value: 5, sophisticate_value: 5)
  end

  context "guest is exploring site" do
    it "should display selections for only the active trait types" do
      visit '/build_your_babe'
      expect(page).to have_content("city")
      expect(page).to have_content("date")
      expect(page).to_not have_content("shoe")
      @shoe_trait.active = true
      @shoe_trait.save
      visit '/build_your_babe'
      expect(page).to have_content("city")
      expect(page).to have_content("date")
      expect(page).to have_content("shoe")
      fill_in_babe
      click_button "Show me the goods"
      babe = Spree::Babe.last
      expect(babe.vixen_value).to eq 3.33
      expect(babe.flirt_value).to eq 4.33
      expect(babe.romantic_value).to eq 3.33
      expect(babe.sophisticate_value).to eq 2.67
      @shoe_trait.active = false
      @shoe_trait.save

    end

    it "should average the babe_trait_values" do
      visit '/build_your_babe'
      expect(current_path).to eql(spree.new_babe_path)
      fill_in_babe
      click_button "Show me the goods"
      babe = Spree::Babe.last
      expect(babe.vixen_value).to eq 4.5
      expect(babe.flirt_value).to eq 4
      expect(babe.romantic_value).to eq 2.5
      expect(babe.sophisticate_value).to eq 1.5
    end

    it "should allow a guest to build a babe" do
      visit '/build_your_babe'
      expect(current_path).to eql(spree.new_babe_path)
      fill_in_babe
      click_button "Show me the goods"
      babe = Spree::Babe.last
      expect(current_path).to eql(spree.my_babes_package_list_path(babe.id))
    end
  end


  context "user logs in" do
    let!(:user) {FactoryGirl.create(:user)}

    before (:each) do
      login_as(user, scope: :spree_user)
    end

    it "should allow the user to load the build a babe page" do
      visit spree.build_your_babe_path
      expect(page).to have_content('Body Type')
    end

    it "should allow the user to save a babe" do
      visit spree.build_your_babe_path
      fill_in_babe
      click_button "Show me the goods"
      babe = Spree::Babe.last
      expect(current_path).to eql(spree.my_babes_package_list_path(babe.id))
    end

    context "user has at least one babe already" do

      let!(:babe1) { create(:babe, name: 'babe1', band: 36, cup: 'DD', bottoms: 'medium', number_size: '3', spree_user_id: user.id)}
      let!(:babe2) { create(:babe, name: 'babe2', band: 36, cup: 'DD', bottoms: 'medium', number_size: '3', spree_user_id: user.id)}

      it "should show a list of the babes" do
        visit spree.babes_path
        expect(page).to have_content('Your Babes')
        expect(page).to have_content('babe1')
        expect(page).to have_content('babe2')
        expect(page).to have_content('Build A New Babe')
      end


      it "should show the babe list page on clicking the build a babe link" do
        visit spree.build_your_babe_path
        expect(current_path).to eql(spree.babes_path)
      end

      it "should allow the user to create another babe" do
        starting_count = Spree::Babe.where("spree_user_id = #{user.id}").count
        visit spree.build_your_babe_path
        click_link "Build A New Babe"
        expect(current_path).to eql(spree.new_babe_path)
        fill_in_babe
        fill_in "babe_name", :with => "New Stella"
        click_button "Show me the goods"
        expect(Spree::Babe.where("spree_user_id = #{user.id}").count).to eq starting_count+1
        expect(Spree::Babe.last.name).to eq "New Stella"
      end


    end

  end

  def fill_in_babe
    fill_in "babe_name", :with => "Stella"
    fill_in "babe_height", :with => "65"
    fill_in "babe_band", :with => "34"
    fill_in "babe_cup", :with => "D"
    fill_in "babe_bottoms", :with => "Medium"
    fill_in "babe_number_size", :with => "3"
  end

end
