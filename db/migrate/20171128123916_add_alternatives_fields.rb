class AddAlternativesFields < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :alternative_negotiation_tools, :string
    add_column :c100_applications, :alternative_mediation, :string
    add_column :c100_applications, :alternative_lawyer_negotiation, :string
    add_column :c100_applications, :alternative_collaborative_law, :string
    add_column :c100_applications, :alternative_court, :string
  end
end
