class StepController < ApplicationController
  before_action :check_c100_application_presence
  before_action :check_application_payment_status
  before_action :check_application_not_completed, :check_application_not_screening, except: [:show]

  before_action :update_navigation_stack, only: [:show, :edit]

  def previous_step_path
    # Second to last element in the array, will be nil for arrays of size 0 or 1
    current_c100_application&.navigation_stack&.slice(-2) || root_path
  end
  helper_method :previous_step_path

  def fast_forward_to_cya?
    navigation_stack.fast_forward_to_cya?
  end
  helper_method :fast_forward_to_cya?

  private

  def update_and_advance(form_class, opts = {})
    hash = extract_parameters(form_class)
    record = opts[:record]

    @form_object = form_class.new(
      hash.merge(c100_application: current_c100_application, record: record)
    )

    if save_draft?
      # Validations will not be run when saving a draft, and because there is
      # only a possible destination, we can also bypass the decision tree code.
      @form_object.save!
      redirect_to new_user_registration_path
    elsif @form_object.save
      if fast_forward_to_cya?
        redirect_to edit_steps_application_check_your_answers_path
      else
        redirect_to destination(step_params: hash, opts: opts)
      end
    else
      render opts.fetch(:render, :edit)
    end
  end

  def destination(step_params:, opts:)
    decision_tree_class.new(
      c100_application: current_c100_application,
      record: opts[:record],
      step_params: step_params,
      # Used when the step name in the decision tree is not the same as the first
      # (and usually only) attribute in the form.
      as: opts[:as],
      next_step: params[:next_step].presence
    ).destination
  end

  def extract_parameters(form_class)
    normalise_date_attributes!(
      permitted_params(form_class).to_h
    )
  end

  def permitted_params(form_class)
    params
      .fetch(form_class.model_name.singular, {})
      .permit(form_attribute_names(form_class) + additional_permitted_params)
  end

  # Some form objects might contain complex attribute structures or nested params.
  # Override in subclasses to declare any additional parameters that should be permitted.
  def additional_permitted_params
    []
  end

  def save_draft?
    params[:commit_draft].present?
  end

  def form_attribute_names(form_class)
    form_class.attribute_set.map do |attr|
      attr_name = attr.name
      primitive = attr.primitive.to_s

      # Avoid having to declare collection attributes `Array[String]` in permitted params.
      case primitive
      when 'Array'
        [attr_name, attr_name => []]
      else
        attr_name
      end
    end
  end

  # Converts multi-param Rails date attributes to an array that can be coerced more easily.
  # Uses the `(1i)` part to know the position in the array (index 0 being nil).
  #
  # Example: {'birth_date(1i)' => '2008', 'birth_date(2i)' => '11', 'birth_date(3i)' => '22'}
  # will be converted to an array attribute named `birth_date` with values: [nil, 2008, 11, 22]
  #
  def normalise_date_attributes!(hash)
    regex = /(?<name>.+)\((?<index>[1-3])i\)$/ # captures the attribute name and index (1 to 3)
    new_hash = {}

    hash.each do |key, value|
      next unless key =~ regex

      hash.delete(key)

      name  = Regexp.last_match(:name)
      index = Regexp.last_match(:index).to_i

      new_hash[name] ||= []
      new_hash[name][index] = value.to_i
    end.merge!(
      new_hash
    )
  end

  def navigation_stack
    @_navigation_stack ||= C100App::NavigationStack.new(
      current_c100_application, request
    )
  end

  def update_navigation_stack
    navigation_stack.update!
  end
end
