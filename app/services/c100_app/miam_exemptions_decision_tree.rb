module C100App
  class MiamExemptionsDecisionTree < BaseDecisionTree
    def destination
      return next_step if next_step

      case step_name
      when :domestic
        edit(:protection)
      when :protection
        edit(:urgency)
      when :urgency
        edit(:adr)
      when :adr
        edit(:misc)
      when :misc
        playback_or_exit_page
      else
        raise InvalidStep, "Invalid step '#{as || step_params}'"
      end
    end

    private

    def playback_or_exit_page
      if has_miam_exemptions?
        show(:reasons_playback)
      else
        show(:exit_page)
      end
    end

    def has_miam_exemptions?
      MiamExemptionsPresenter.new(
        c100_application.miam_exemption
      ).exemptions.any?
    end
  end
end
