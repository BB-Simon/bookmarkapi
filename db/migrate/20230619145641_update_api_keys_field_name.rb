class UpdateApiKeysFieldName < ActiveRecord::Migration[7.0]
  def change
    change_table :api_keys do |t|
      t.rename :value, :bookmark_api_token
    end
  end
end
