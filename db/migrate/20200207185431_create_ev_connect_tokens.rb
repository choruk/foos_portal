class CreateEvConnectTokens < ActiveRecord::Migration
  def change
    create_table :ev_connect_tokens do |t|
      t.string :access_token, null: false
      t.string :refresh_token, null: false
      t.datetime :expires_at, null: false

      t.timestamps
    end
  end
end
