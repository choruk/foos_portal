class UpdateEvConnectTokenType < ActiveRecord::Migration
  def up
    change_column :ev_connect_tokens, :access_token, :text
    change_column :ev_connect_tokens, :refresh_token, :text
  end

  def down
    change_column :ev_connect_tokens, :access_token, :string
    change_column :ev_connect_tokens, :refresh_token, :string
  end
end
