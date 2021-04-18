class CreateAuthorizations < ActiveRecord::Migration[6.1]
  def change
    create_table :authorizations do |t|
      t.string :subject, unique: true
      t.string :access_token

      t.timestamps
    end
  end
end
