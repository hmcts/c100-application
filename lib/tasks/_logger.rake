# This task is intended to enable log to STDOUT for tasks that are called
# via cronjobs or workers. Just use it like this:
#
#   `task task_name: [:stdout_environment] do ...`
#
task :stdout_environment => [:environment] do
  Rails.logger = Logger.new(STDOUT)
  Rails.logger.level = Logger::INFO
end
