# Will return:
#   /steps/applicant/:step/:uuid
#   /steps/respondent/:step/:uuid
#   /steps/other_party/:step/:uuid
#
module PersonUrlHelper
  def person_url_for(record, step:)
    polymorphic_path([:steps, record, step])
  end
end
