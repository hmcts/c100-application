class CreateC100Applications < ActiveRecord::Migration[5.0]
  def change
    create_table :c100_applications, id: :uuid do |t|
      t.timestamps
    end
  end
end
