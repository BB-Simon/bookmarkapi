class CreateApiKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :api_keys do |t|
      t.string :bookmark_api_key
      t.string :value

      t.timestamps
    end
  end
end
