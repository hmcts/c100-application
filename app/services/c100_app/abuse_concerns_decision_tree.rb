module C100App
  class AbuseConcernsDecisionTree < BaseDecisionTree
    def destination
      case step_name
      when :question
        after_question_step
      when :details
        after_details_step
      when :contact
        edit('/steps/petition/orders')
      else
        raise InvalidStep, "Invalid step '#{step_name}'"
      end
    end

    private

    def abuse_subject
      AbuseSubject.new(step_params[:subject])
    end

    def abuse_kind
      AbuseType.new(step_params[:kind])
    end

    def abuse_answer
      GenericYesNo.new(step_params[:answer])
    end

    def after_question_step
      case abuse_subject
      when AbuseSubject::APPLICANT
        applicant_questions_destination
      when AbuseSubject::CHILDREN
        children_questions_destination
      end
    end

    def after_details_step
      case abuse_subject
      when AbuseSubject::APPLICANT
        applicant_details_destination
      when AbuseSubject::CHILDREN
        children_details_destination
      end
    end

    def applicant_questions_destination
      case abuse_answer
      when GenericYesNo::YES
        edit(:details, subject: abuse_subject, kind: abuse_kind)
      else
        applicant_details_destination
      end
    end

    def applicant_details_destination
      case abuse_kind
      when AbuseType::OTHER
        edit('/steps/court_orders/has_orders')
      else
        questions_destination(AbuseSubject::APPLICANT)
      end
    end

    def children_questions_destination
      case abuse_answer
      when GenericYesNo::YES
        edit(:details, subject: abuse_subject, kind: abuse_kind)
      else
        children_details_destination
      end
    end

    def children_details_destination
      case abuse_kind
      when AbuseType::OTHER
        show(:applicant_info)
      else
        questions_destination(AbuseSubject::CHILDREN)
      end
    end

    # Note: this is a lot of branching but makes for a more readable code, and is easier to
    # change the ordering. It could be refactored once we have the abuse details step.
    #
    def questions_destination(subject)
      case abuse_kind
      when AbuseType::SEXUAL
        edit(:question, subject: subject, kind: AbuseType::PHYSICAL)
      when AbuseType::PHYSICAL
        edit(:question, subject: subject, kind: AbuseType::FINANCIAL)
      when AbuseType::FINANCIAL
        edit(:question, subject: subject, kind: AbuseType::PSYCHOLOGICAL)
      when AbuseType::PSYCHOLOGICAL
        edit(:question, subject: subject, kind: AbuseType::EMOTIONAL)
      when AbuseType::EMOTIONAL
        edit(:question, subject: subject, kind: AbuseType::OTHER)
      else
        raise InvalidStep, "Unknown abuse kind: #{abuse_kind}"
      end
    end
  end
end
