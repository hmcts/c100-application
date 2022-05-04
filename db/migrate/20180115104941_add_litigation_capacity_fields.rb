class AddLitigationCapacityFields < ActiveRecord::Migration[5.1]
  def change
    add_column :c100_applications, :reduced_litigation_capacity, :string
    add_column :c100_applications, :participation_capacity_details, :text
    add_column :c100_applications, :participation_referral_or_assessment_details, :text
    add_column :c100_applications, :participation_other_factors_details, :text
  end
end
