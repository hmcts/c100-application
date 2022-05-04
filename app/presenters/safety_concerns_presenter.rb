class SafetyConcernsPresenter < SimpleDelegator
  SafetyConcern = Struct.new(:type_name, :value) do
    def show?
      value.eql?(GenericYesNo::YES.to_s)
    end

    def to_partial_path
      'steps/miam_exemptions/shared/concern'
    end
  end

  def concerns
    concern_types.map do |type|
      SafetyConcern.new(type, self[type])
    end.select(&:show?)
  end

  def concern_types
    [:domestic_abuse, :risk_of_abduction, :children_abuse, :substance_abuse, :other_abuse].freeze
  end
end
