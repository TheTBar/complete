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

end
