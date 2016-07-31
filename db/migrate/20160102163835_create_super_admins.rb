class CreateSuperAdmins < ActiveRecord::Migration

  def change
    create_table :super_admins, id: false do |t|
      t.datetime :created_at

      t.belongs_to :user, index: true, foreign_key: true, unique: true
    end
  end

end
