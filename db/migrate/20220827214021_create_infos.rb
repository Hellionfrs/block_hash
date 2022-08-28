class CreateInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :infos do |t|
      t.text :block
      t.jsonb :block_hash

      t.timestamps
    end
  end
end
