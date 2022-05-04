require 'rspec/expectations'

RSpec::Matchers.define :have_destination do |controller, action, params = {}|
  match do |decision_tree|
    destination = decision_tree.destination

    destination[:controller] == controller && destination[:action] == action &&
      params.keys.all? { |key| destination[key].to_s == params[key].to_s }
  end

  failure_message do |decision_tree|
    "expected decision tree destination to be an appropriately formatted hash, got '#{decision_tree.destination}'"
  end
end
