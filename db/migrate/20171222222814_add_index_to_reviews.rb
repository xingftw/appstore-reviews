class AddIndexToReviews < ActiveRecord::Migration[5.1]
  def change
    add_index :reviews, :published_at
    add_index :reviews, :external_id, unique: true
  end
end
