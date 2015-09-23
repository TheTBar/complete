require 'rails_helper'

describe Spree::Babe, :type => :model do

  let (:babe) { create(:babe, band: 36, cup: 'DD', bottoms: 'medium')}

  it "should return the band size" do
    expect(babe.bra_size).to eq '36DD'
  end

  it "should return the size for the bottom option type" do
    expect(babe.size_value_for_size_option_type_name('named sizes')).to eq 'medium'
  end

  it "should return the size for the bra size option type" do
    expect(babe.size_value_for_size_option_type_name('bra sizes')).to eq '36DD'
  end

  it "should average the personality values" do
    city_trait = create(:babe_trait_type, name: 'city')
    create(:babe_trait_value, name: 'city 1', spree_babe_trait_type_id: city_trait.id, vixen_value: 5, flirt_value: 1, romantic_value: 3, sophisticate_value: 5)
    date_trait = create(:babe_trait_type, name: 'date')
    create(:babe_trait_value, name: "date 1", spree_babe_trait_type_id: date_trait.id, vixen_value: 5, flirt_value: 4, romantic_value: 2, sophisticate_value: 3)
    shoe_trait = create(:babe_trait_type, name: 'shoe')
    create(:babe_trait_value, name: "shoe 1", spree_babe_trait_type_id: shoe_trait.id, vixen_value: 4, flirt_value: 1, romantic_value: 1, sophisticate_value: 4)

    traits = Spree::BabeTraitValue.all
    babe = Spree::Babe.new
    babe.set_personality_from_trait_array(traits)
    personality = babe.personality;
    expect(personality[0][0]).to eq 'vixen_value'
    expect(personality[0][1]).to eq 4.67
    expect(personality[1][0]).to eq 'sophisticate_value'
    expect(personality[1][1]).to eq 4.00
  end

  it "should average the personality values and correct the tie" do
    city_trait = create(:babe_trait_type, name: 'city')
    create(:babe_trait_value, name: 'city 1', spree_babe_trait_type_id: city_trait.id, vixen_value: 5, flirt_value: 1, romantic_value: 3, sophisticate_value: 4)
    date_trait = create(:babe_trait_type, name: 'date')
    create(:babe_trait_value, name: "date 1", spree_babe_trait_type_id: date_trait.id, vixen_value: 3, flirt_value: 4, romantic_value: 2, sophisticate_value: 4)
    shoe_trait = create(:babe_trait_type, name: 'shoe')
    create(:babe_trait_value, name: "shoe 1", spree_babe_trait_type_id: shoe_trait.id, vixen_value: 4, flirt_value: 1, romantic_value: 1, sophisticate_value: 4)

    traits = Spree::BabeTraitValue.all
    babe = Spree::Babe.new
    babe.set_personality_from_trait_array(traits)
    personality = babe.personality;
    expect(personality[1][0]).to eq 'sophisticate_value'
    expect(personality[1][1]).to eq 4.00
    expect(personality[0][0]).to eq 'vixen_value'
    expect(personality[0][1]).to eq 4.10

  end

end
