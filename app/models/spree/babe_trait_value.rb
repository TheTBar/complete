module Spree
  class BabeTraitValue < ActiveRecord::Base
    belongs_to :spree_babe_trait_type, :class_name => 'Spree::BabeTraitType'
  end
end