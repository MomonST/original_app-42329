# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[7.1]
  def change
      ## Database authenticatable

      # Deviseに必要なカラムを追加
      add_column :users, :email, :string, null: false, default: "" unless column_exists?(:users, :email)
      add_column :users, :encrypted_password, :string, null: false, default: "" unless column_exists?(:users, :encrypted_password)
      add_column :users, :reset_password_token, :string unless column_exists?(:users, :reset_password_token)
      add_column :users, :reset_password_sent_at, :datetime unless column_exists?(:users, :reset_password_sent_at)
      add_column :users, :remember_created_at, :datetime unless column_exists?(:users, :remember_created_at)

      # アプリ固有のカラムを追加（まだない場合）
      add_column :users, :last_name, :string unless column_exists?(:users, :last_name)
      add_column :users, :first_name, :string unless column_exists?(:users, :first_name)
      add_column :users, :last_name_kana, :string unless column_exists?(:users, :last_name_kana)
      add_column :users, :first_name_kana, :string unless column_exists?(:users, :first_name_kana)
      add_column :users, :nickname, :string unless column_exists?(:users, :nickname)
      add_column :users, :birth_date, :date unless column_exists?(:users, :birth_date)

      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      # Uncomment below if timestamps were not included in your original model.
    

      # インデックス追加
      add_index :users, :email, unique: true unless index_exists?(:users, :email)
      add_index :users, :reset_password_token, unique: true unless index_exists?(:users, :reset_password_token)
      add_index :users, :nickname, unique: true unless index_exists?(:users, :nickname)
      add_index :users, :created_at unless index_exists?(:users, :created_at)
      add_index :users, :updated_at unless index_exists?(:users, :updated_at)
      # add_index :users, :confirmation_token,   unique: true
      # add_index :users, :unlock_token,         unique: true
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
