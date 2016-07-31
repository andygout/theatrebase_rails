class CreateProductions < ActiveRecord::Migration

  def change
    create_table :productions do |t|
      t.string      :title
      t.string      :alphabetise
      t.string      :url, index: true
      t.date        :first_date
      t.date        :press_date
      t.date        :last_date
      t.boolean     :press_date_tbc
      t.boolean     :previews_only
      t.integer     :dates_info, limit: 2
      t.string      :press_date_wording
      t.string      :dates_tbc_note
      t.string      :dates_note
      t.date        :second_press_date
      t.timestamps  null: false

      t.belongs_to :creator, index: true
      t.belongs_to :updater, index: true
    end

    add_foreign_key :productions, :users, column: :creator_id
    add_foreign_key :productions, :users, column: :updater_id
  end

end
