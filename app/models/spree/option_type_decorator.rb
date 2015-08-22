Spree::OptionType.class_eval do


  def isSizeOptionType?
    self.presentation.downcase == 'size'
  end



end