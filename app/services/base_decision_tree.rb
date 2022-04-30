class BaseDecisionTree
  class InvalidStep < RuntimeError; end

  attr_reader :c100_application, :record, :step_params, :as, :next_step

  def initialize(c100_application:, record: nil, step_params: {}, as: nil, next_step: nil)
    @c100_application = c100_application
    @record = record
    @step_params = step_params
    @as = as
    @next_step = next_step
  end

  private

  def step_name
    (as || step_params.keys.first).to_sym
  end

  def question(attribute_name, record = c100_application)
    value = record.public_send(attribute_name) || 'na'
    GenericYesNo.new(value)
  end

  def selected?(attribute_name, value: 'yes')
    step_params.fetch(attribute_name).eql?(value)
  end

  def show(step_controller)
    {controller: step_controller, action: :show}
  end

  def edit(step_controller, params = {})
    {controller: step_controller, action: :edit}.merge(params)
  end

  def next_record_id(collection_ids, current: record)
    @_next_record_id ||= begin
      return collection_ids.first if current.nil?

      pos = collection_ids.index(current.id)
      collection_ids.at(pos + 1)
    end
  end
end
