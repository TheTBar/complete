module Spree
  class EffectiveSize < ActiveRecord::Base

    belongs_to :variant

    validates_presence_of :effective_size


    def self.create_new_record(variant_id,effective_size)
      es = Spree::EffectiveSize.new
      es.variant_id = variant_id;
      es.effective_size = effective_size
      es.save
    end

  end
end
