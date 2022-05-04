module Summary
  class AnswerBox < BaseAnswer
    def initialize(name)
      super(name, nil, show: true)
    end

    def to_partial_path
      'steps/completion/shared/answer_box'
    end
  end
end
