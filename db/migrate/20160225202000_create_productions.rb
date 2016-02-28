class CreateProductions < ActiveRecord::Migration
  def change
    create_table :productions do |t|
      t.string      :title
      t.timestamps  null: false

      t.belongs_to :creator,
        index: true

      t.belongs_to :updater,
        index: true
    end
    add_foreign_key :productions,
      :users,
      column: :creator_id

    add_foreign_key :productions,
      :users,
      column: :updater_id
  end
end