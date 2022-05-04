class DomesticExemptions < ValueObject
  VALUES = [
    GROUP_POLICE = new(:group_police),
    POLICE = [
      new(:police_arrested),
      new(:police_caution),
      new(:police_ongoing_proceedings),
      new(:police_conviction),
      new(:police_dvpn)
    ].freeze,

    GROUP_COURT = new(:group_court),
    COURT = [
      new(:court_bound_over),
      new(:court_protective_injunction),
      new(:court_undertaking),
      new(:court_finding_of_fact),
      new(:court_expert_report)
    ].freeze,

    GROUP_SPECIALIST = new(:group_specialist),
    SPECIALIST = [
      new(:specialist_examination),
      new(:specialist_referral)
    ].freeze,

    GROUP_LOCAL_AUTHORITY = new(:group_local_authority),
    LOCAL_AUTHORITY = [
      new(:local_authority_marac),
      new(:local_authority_la_ha),
      new(:local_authority_public_authority)
    ].freeze,

    GROUP_DA_SERVICE = new(:group_da_service),
    DA_SERVICE = [
      new(:da_service_idva),
      new(:da_service_isva),
      new(:da_service_organisation),
      new(:da_service_refuge_refusal)
    ].freeze,

    RIGHT_TO_REMAIN = new(:right_to_remain),
    FINANCIAL_ABUSE = new(:financial_abuse),
    DOMESTIC_NONE = new(:domestic_none)
  ].flatten.freeze

  # :nocov:
  def self.values
    VALUES
  end
  # :nocov:
end
