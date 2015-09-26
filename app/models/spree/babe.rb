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

    def display_name_babe
      self.name == '' ? 'Your Babe' : self.name
    end

    def display_name_lady
      self.name == '' ? 'Your Lady' : self.name
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
      if self.personality[0][1] == self.personality[1][1]
        primary_personality_values = []
        secondary_personality_values = []
        chosen_traits.each do |t|
          primary_personality_values.push(t[personality[0][0]])
          secondary_personality_values.push(t[personality[1][0]])
        end
        primary_personality_values = primary_personality_values.sort.reverse
        secondary_personality_values = secondary_personality_values.sort.reverse
        primary_total_of_top_n = 0
        secondary_total_of_top_n = 0
        for i in 0..(chosen_traits.size-2)
          primary_total_of_top_n = primary_total_of_top_n + primary_personality_values[i]
          secondary_total_of_top_n = secondary_total_of_top_n + secondary_personality_values[i]
        end

        if primary_total_of_top_n > secondary_total_of_top_n
          self[personality[0][0]] = personality[0][1] + 0.1
        else
          self[personality[1][0]] = personality[1][1] + 0.1
        end
      end
    end

    def words(trait)
      if trait.downcase == 'vixen_value'
        return 'sassy'
      elsif trait.downcase == 'flirt_value'
        return 'flirty'
      elsif trait.downcase == 'sophisticate_value'
        return 'sophisticated'
      elsif trait.downcase == 'romantic_value'
        return 'romantic'
      end
    end

    def personality_statement
      "She's really #{self.words(self.personality[0][0])}, and pretty #{self.words(self.personality[1][0])}."
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

    def size_value_for_size_option_type_name(size_type_name)
      if size_type_name.downcase == 'named sizes'
        return self.bottoms
      elsif size_type_name.downcase == 'bra sizes'
        return self.bra_size
      elsif size_type_name.downcase == 'number sizes'
        return self.number_size
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
