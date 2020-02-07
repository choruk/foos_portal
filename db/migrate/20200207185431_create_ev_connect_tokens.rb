class CreateEvConnectTokens < ActiveRecord::Migration
  def change
    create_table :ev_connect_tokens do |t|
      t.string :access_token
      t.string :refresh_token
      t.datetime :expires_at

      t.timestamps
    end
  end
end
