class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :slack_user_id, null: false
      t.string :slack_user_name, null: false

      t.timestamps
    end
  end
end
