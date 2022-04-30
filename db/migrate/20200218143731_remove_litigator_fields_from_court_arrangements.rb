class RemoveLitigatorFieldsFromCourtArrangements < ActiveRecord::Migration[5.2]
  def change
    remove_column :court_arrangements, :reduced_litigation_capacity, :string
    remove_column :court_arrangements, :participation_capacity_details, :text
    remove_column :court_arrangements, :participation_other_factors_details, :text
    remove_column :court_arrangements, :participation_referral_or_assessment_details, :text
  end
end
