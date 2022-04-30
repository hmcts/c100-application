class DisablePgStatStatements < ActiveRecord::Migration[5.2]
  def up
    disable_extension 'pg_stat_statements'
  end

  # No `down` on purpose, as we want this to remain disabled,
  # even if we do a rollback.
end
