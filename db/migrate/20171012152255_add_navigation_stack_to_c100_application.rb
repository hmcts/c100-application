class AddNavigationStackToC100Application < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :navigation_stack, :string, array: true, default: []
  end
end
