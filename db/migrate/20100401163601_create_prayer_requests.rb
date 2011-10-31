class CreatePrayerRequests < ActiveRecord::Migration
  def self.up
    create_table :prayer_requests do |t|
      t.integer :user_id
      t.string  :user_name
      t.integer :private
      t.string :title
      t.text :request
      t.timestamps
    end
    
    create_table :prayer_updates do |t|
      t.integer :prayer_request_id
      t.text :message
      t.timestamps
    end
  end

  def self.down
    drop_table :prayer_requests
    drop_table :prayer_updates
  end
end
