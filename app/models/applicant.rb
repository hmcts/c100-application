class Applicant < Person
  # In the case of more than one applicant, if at least one of them
  # is under age, the whole application is considered as "under age"
  def self.under_age?
    any?(&:under_age)
  end
end
