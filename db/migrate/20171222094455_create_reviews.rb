class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.string :external_id
      t.string :shop_name
      t.string :shop_url
      t.integer :rating
      t.text :body
      t.datetime :published_at
      t.string :appstore
      t.bigint :account_id

      t.timestamps
    end
  end
end
