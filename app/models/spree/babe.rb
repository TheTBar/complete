module Spree
  class Babe < ActiveRecord::Base
    
    CUP_SIZES = [ "A", "B", "C", "D", "DD", "F" ]
    BAND_SIZES = [ "30", "32", "34", "36", "38" ]
    BOTTOMS_SIZES = [ "XS", "S", "M", "L", "XL" ]
    #BOTTOMS_SIZES = [ "XSmall", "Small", "Medium", "Large", "XLarge" ]
    
    belongs_to :body_type

    def my_body_type
      self.body_type.name
    end

    def set_personality_from_trait_array(chosen_traits)
      self.vixen_value = 0
      self.flirt_value = 0
      self.romantic_value = 0
      self.sophisticate_value = 0
      chosen_traits.each do |t|
        self.vixen_value += t.vixen_value
        self.flirt_value += t.flirt_value
        self.romantic_value += t.romantic_value
        self.sophisticate_value += t.sophisticate_value
      end

      self.vixen_value = (self.vixen_value / chosen_traits.length).round(2)
      self.flirt_value = (self.flirt_value / chosen_traits.length).round(2)
      self.romantic_value = (self.romantic_value / chosen_traits.length).round(2)
      self.sophisticate_value = (self.sophisticate_value / chosen_traits.length).round(2)
    end

    def personality
      personality = Hash.new
      personality['vixen_value'] = self.vixen_value
      personality['flirt_value'] = self.flirt_value
      personality['sophisticate_value'] = self.sophisticate_value
      personality['romantic_value'] = self.romantic_value
      personality.sort_by {|_key, value| value}.reverse.first 2
    end

    def bra_size
      "#{self.band}#{self.cup}".upcase
    end

    def soonik_bra_size
      if self.band < 32 && self.cup.downcase == 'a'
        return 'soonik bra xsmall'
      elsif self.band < 33 && self.cup.downcase == 'a'
        return 'soonik bra small'
      elsif self.band > 33 && self.band < 37 && (self.cup.downcase == 'a' || self.cup.downcase == 'b')
        return 'soonik bra medium'
      elsif self.band > 37  && (self.cup.downcase == 'a' || self.cup.downcase == 'b')
        return 'soonik bra large'
      else
        return 'NOSOONIK'
      end
    end

    def size_value_for_size_option_type_name(size_type_name)
      if size_type_name.downcase == 'named sizes'
        return self.bottoms
      elsif size_type_name.downcase == 'bra sizes'
        return self.bra_size
      elsif size_type_name.downcase == 'number sizes'
        return self.number_size
      elsif size_type_name.downcase == 'soonik named sizes'
        return self.soonik_bra_size
      elsif size_type_name.downcase == 'one size'
        return 'one size'
      end
    end

    private

    def initialize(attributes={})
      super
      self.vixen_value ||= 0
      self.flirt_value ||= 0
      self.romantic_value ||= 0
      self.sophisticate_value ||= 0
    end

  end
end
