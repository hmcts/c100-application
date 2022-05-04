class ChangePassportPossessionToArray < ActiveRecord::Migration[5.2]
  #
  # Note: not doing the cleanup of the old attributes in this migration to
  # minimise the risk of some failure and having to rollback to the old code.
  # Once everything is up and running smoothly we can cleanup the old attributes.
  #
  def up
    add_column :abduction_details, :passport_possession, :string, array: true, default: []
    migrate_passport_data!
  end

  def down
    remove_column :abduction_details, :passport_possession
  end

  private

  def migrate_passport_data!
    AbductionDetail.find_each(batch_size: 25) do |record|
      choices = []

      choices.push(Relation::MOTHER) if record.passport_possession_mother?
      choices.push(Relation::FATHER) if record.passport_possession_father?
      choices.push(Relation::OTHER)  if record.passport_possession_other?

      record.update_column(
        :passport_possession,
        choices.map(&:to_s)
      )
    end
  end
end
