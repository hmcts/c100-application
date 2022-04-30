class DraftPresenter < SimpleDelegator
  def expires_in
    I18n.translate!(:draft_expires_in, scope: 'time', count: remaining_days)
  end

  def expires_in_class
    case remaining_days
    when 0
      'expires-today'
    when 1..5
      'expires-soon'
    else
      ''
    end
  end

  def applicant_name
    applicants.first&.full_name
  end

  private

  def remaining_days
    expiration_date = created_at.days_since(Rails.configuration.x.drafts.expire_in_days).to_date
    (Date.today...expiration_date).count
  end
end
