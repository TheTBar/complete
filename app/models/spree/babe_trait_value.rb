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

    def get(personality_field)
      if personality_field == 'vixen_value'
        self.vixen_value
      elsif personality_field == 'flirt_value'
        self.flirt_value
      elsif personality_field == 'romantic_value'
        self.romantic_value
      elsif personality_field == 'sophisticate_value'
        self.sophisticate_value
      end
    end

  end
end