class AddBelongsToComments < ActiveRecord::Migration[5.2]
  def change
    add_reference :comments, :posts
  end
end
