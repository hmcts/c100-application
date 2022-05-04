# frozen_string_literal: true

class PetitionOrder < ValueObject
  VALUES = [
    CHILD_ARRANGEMENTS = [
      CHILD_ARRANGEMENTS_HOME = new(:child_arrangements_home),
      CHILD_ARRANGEMENTS_TIME = new(:child_arrangements_time),
    ].freeze,

    GROUP_PROHIBITED_STEPS = new(:group_prohibited_steps),
    PROHIBITED_STEPS = [
      new(:prohibited_steps_names),
      new(:prohibited_steps_medical),
      new(:prohibited_steps_holiday),
      new(:prohibited_steps_moving),
      new(:prohibited_steps_moving_abroad),
    ].freeze,

    GROUP_SPECIFIC_ISSUES = new(:group_specific_issues),
    SPECIFIC_ISSUES = [
      new(:specific_issues_holiday),
      new(:specific_issues_school),
      new(:specific_issues_religion),
      new(:specific_issues_names),
      new(:specific_issues_medical),
      new(:specific_issues_moving),
      new(:specific_issues_moving_abroad),
      new(:specific_issues_child_return),
    ].freeze,

    # Although there is only one, we use an array for consistency with existing code
    FORMALISE_ARRANGEMENTS = [
      CONSENT_ORDER = new(:consent_order),
    ].freeze,

    OTHER_ISSUE = new(:other_issue),
  ].flatten.freeze

  def self.values
    VALUES
  end

  def self.type_for(sub_type)
    case sub_type.to_s
    when /^child_arrangements_.*/ then 'child_arrangements'
    when /^prohibited_steps_.*/   then 'prohibited_steps'
    when /^specific_issues_.*/    then 'specific_issues'
    when /^consent_order$/        then 'consent_order'
    else
      'other_issue'
    end
  end
end
