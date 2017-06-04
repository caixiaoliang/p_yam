class AddResetPassword < ActiveRecord::Migration
  def change
    add_column :users, :reset_digest,:string
    add_column :users, :reset_sent_at,:datetime
    add_column :users, :open_id, :string
  end
end
