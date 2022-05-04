class RelationshipsPresenter
  attr_reader :c100_application

  def initialize(c100_application)
    @c100_application = c100_application
  end

  def relationship_to_children(person_or_people, show_person_name: true, bypass_c8: false)
    unless bypass_c8
      return C8ConfidentialityPresenter.replacement_answer if under_c8?(person_or_people)
    end

    relationships.where(minor: minors, person: person_or_people).map do |relationship|
      show_person_name ? present_relation_with_person(relationship) : present_relation_without_person(relationship)
    end.join("\n")
  end

  private

  def minors
    c100_application.minors
  end

  def relationships
    c100_application.relationships
  end

  # For other parties, we need to hide the relationships if C8 is triggered
  def under_c8?(person_or_people)
    c100_application.confidentiality_enabled? && Array(person_or_people).first.is_a?(OtherParty)
  end

  def i18n_relation(relationship)
    return relationship.relation_other_value if relationship.relation.eql?(Relation::OTHER.to_s)
    I18n.translate!(relationship.relation, scope: 'dictionary.RELATIONS')
  end

  def present_relation_with_person(relationship)
    I18n.translate!(
      'shared.relationship_to_child.show_person_html',
      person_name: relationship.person.full_name,
      child_name: relationship.minor.full_name,
      relation: i18n_relation(relationship)
    )
  end

  def present_relation_without_person(relationship)
    I18n.translate!(
      'shared.relationship_to_child.hide_person_html',
      child_name: relationship.minor.full_name,
      relation: i18n_relation(relationship)
    )
  end
end
