class AddDefaultValueToUsers < ActiveRecord::Migration
  def change
    # alter table  users  add column  last_login timestamp not null default NOW();
    change_column :users, :email,:string, null: true, default: nil
  end
end
