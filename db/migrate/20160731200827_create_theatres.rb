class CreateTheatres < ActiveRecord::Migration
  def change
    create_table :theatres do |t|
      t.string      :name
      t.string      :alphabetise
      t.timestamps  null: false

      t.belongs_to :creator, index: true
      t.belongs_to :updater, index: true
    end

    add_foreign_key :theatres, :users, column: :creator_id
    add_foreign_key :theatres, :users, column: :updater_id
  end
end
