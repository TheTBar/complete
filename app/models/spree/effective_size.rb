module Spree
  class EffectiveSize < ActiveRecord::Base

    belongs_to :spree_variant

    validates_presence_of :effective_size


  end
end
