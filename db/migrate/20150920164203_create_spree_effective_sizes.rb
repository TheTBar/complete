class CreateSpreeEffectiveSizes < ActiveRecord::Migration
  def change
    create_table :spree_effective_sizes do |t|
      t.references :variant, index: true
      t.string :effective_size
      t.timestamps
    end
  end
end
