# Pass a match expression as an optional argument to only run mutant
# on classes that match. Example: `rake mutant TaxTribs::ZendeskSender`
#
task :mutant => :environment do
  vars = 'RAILS_ENV=test NOCOVERAGE=true'
  flags = '--use rspec --fail-fast'

  unless system("#{vars} mutant #{flags} #{classes_to_mutate.join(' ')}")
    raise 'Mutation testing failed'
  end

  exit
end

task(:default).prerequisites << task(:mutant)

private

def classes_to_mutate
  Rails.application.eager_load!

  case ARGV[1]
    when nil
      # Quicker run, reduced testing scope (random sample), default option
      puts '> running quick sample mutant testing'
      form_objects.sample(5) + decision_trees_and_services.sample(3) + models
    when 'all'
      # Complete coverage, very long run time
      puts '> running complete mutant testing'
      form_objects + decision_trees_and_services + models
    else
      # Individual class testing, very quick
      Array(ARGV[1])
  end
end

# As the current models are just empty shells for ActiveRecord relationships,
# and we don't even have corresponding spec tests for those, there is no point
# in including these in the mutation test, and thus we can save some time.
# Only include in this collection the models that matter and have specs.
#
def models
  %w(C100Application User).freeze
end

# Everything inheriting from `BaseForm` and inside namespace `Steps`
# i.e. all classes in `/app/forms/steps/**/*`
#
def form_objects
  BaseForm.descendants.map(&:name).grep(/^Steps::/)
end

# Everything inside `C100App` namespace
# i.e. all classes in `/app/services/c100_app/*`
#
def decision_trees_and_services
  C100App.constants.map { |symbol| C100App.const_get(symbol) }
end
