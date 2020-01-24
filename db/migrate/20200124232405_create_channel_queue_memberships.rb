class CreateChannelQueueMemberships < ActiveRecord::Migration
  def change
    create_table :channel_queue_memberships do |t|
      t.references :user, foreign_key: true, null: false
      t.references :channel_queue, foreign_key: true, null: false

      t.index [:user_id, :channel_queue_id], unique: true

      t.timestamps
    end
  end
end
