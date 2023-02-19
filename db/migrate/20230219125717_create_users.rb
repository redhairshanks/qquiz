class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name
      t.string :email, index: { unique: true, name: 'unique_emails' }
      t.string :password_digest
      t.timestamps
    end
  end
end
