class AddVersionToC100Application < ActiveRecord::Migration[5.1]
  def change
    add_column :c100_applications, :version, :integer, default: 1
  end
end

# Note: to bump the `version` of the c100 application records, create
# a new migration to execute the following method:
#
# change_column_default(
#   :c100_applications,
#   :version,
#   from: 1,
#   to: 2
# )
