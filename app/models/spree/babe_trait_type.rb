module Spree
  class BabeTraitType < ActiveRecord::Base
    has_many :spree_babe_trait_values, :class_name => 'Spree::BabeTraitValue'
    validates_presence_of :name
  end
end