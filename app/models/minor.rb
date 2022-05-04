class Minor < Person
  has_many :relationships, source: :minor, dependent: :destroy

  # We use `Person` for STI but classes or subclasses of `Minor` don't need
  # visibility to all attributes declared in the `people` DB table.
  #
  self.ignored_columns = %w[
    address
    address_unknown
    address_data
    birthplace
    has_previous_name
    previous_name
    home_phone
    home_phone_unknown
    mobile_phone
    mobile_phone_unknown
    email
    email_unknown
    residence_requirement_met
    residence_history
    voicemail_consent
    under_age
  ].freeze
end

# hackhackhack to make sure that c100_application.minors
# includes the subtypes in development
# (autoloading only includes _KNOWN_ subclasses -
# see http://guides.rubyonrails.org/autoloading_and_reloading_constants.html#autoloading-and-sti )
require_dependency 'child'
require_dependency 'other_child'
