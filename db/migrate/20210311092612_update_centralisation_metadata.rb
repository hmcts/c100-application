class UpdateCentralisationMetadata < ActiveRecord::Migration[5.2]
  #
  # This task is only needed to "backport" the new metadata attribute `centralised`, to the
  # already centralised courts that took part starting 02 Mar 2021 09:00:00, in the first rollout.
  #
  # This is needed as the metadata was not created back then. New completions on or after this
  # migration will already include the `centralised` attribute (true/false).
  #
  FIRST_BATCH_DATE = DateTime.new(2021, 3, 1, 9)
  FIRST_BATCH_COURTS = [
    'Brighton County Court',
    'Chelmsford Justice Centre',
    'Leeds Combined Court Centre',
    'Medway County Court and Family Court',
    'West London Family Court',
  ].freeze

  def up
    CompletedApplicationsAudit.where(
      'completed_at >= :date', date: FIRST_BATCH_DATE
    ).where(court: FIRST_BATCH_COURTS).each do |record|
      record.update_column(:metadata, record.metadata.merge(centralised: true))
    end
  end
end
