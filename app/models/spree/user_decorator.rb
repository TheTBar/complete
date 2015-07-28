module Spree
  User.class_eval do

    def has_babes?
      return (Spree::Babe.where("spree_user_id = #{self.id}").count > 0)
    end

  end
end
