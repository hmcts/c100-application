module Summary
  class FreeTextAnswer < BaseAnswer
    def to_partial_path
      'steps/completion/shared/free_text_row'
    end
  end
end
