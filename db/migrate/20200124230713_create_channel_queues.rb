class CreateChannelQueues < ActiveRecord::Migration
  def change
    create_table :channel_queues do |t|
      t.string :slack_channel_id, null: false, unique: true
      t.string :slack_channel_name, null: false, unique: true
    end
  end
end
