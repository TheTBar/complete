class AddQuestionVerbiageToSpreeBabeTraitTypes < ActiveRecord::Migration
  def change
    add_column :spree_babe_trait_types, :question_verbiage, :string, null: false, default: "Need Question Verbiage"
  end
end
