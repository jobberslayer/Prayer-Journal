class AddPrayerRequestAnswerColumn < ActiveRecord::Migration
  def self.up
    add_column :prayer_requests, :answered, :boolean
  end

  def self.down
    remove_column :prayer_requests, :answered
  end
end
