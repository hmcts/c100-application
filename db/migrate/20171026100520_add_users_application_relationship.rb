class AddUsersApplicationRelationship < ActiveRecord::Migration[5.0]
  def change
    add_reference :c100_applications, :user, type: :uuid, foreign_key: true
  end
end
