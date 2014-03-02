class CreateVirals < ActiveRecord::Migration
  def change
    create_table :virals do |t|
      t.belongs_to :user
      t.decimal :bounty, :scale => 8 ,:precision => 20, :default => 0
      t.integer :status
      t.integer :duration
      t.text :body
      t.timestamps
    end
  end
end
