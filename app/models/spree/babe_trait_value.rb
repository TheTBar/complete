module Spree
  class BabeTraitValue < ActiveRecord::Base
    belongs_to :spree_babe_trait_type, :class_name => 'Spree::BabeTraitType'

    def load_personality_traits(vixen,sophisticate,flirt,romantic)
      self.vixen_value = vixen
      self.sophisticate_value = sophisticate
      self.flirt_value = flirt
      self.romantic_value = romantic
      self.save
    end

  end
end