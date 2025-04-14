require 'rake'
require_relative 'zeitwerk_loader'

ZeitwerkLoader.setup

task :default do
  system('rake --tasks') || exit(1)
end

# Load all rake tasks from lib/tasks directory
Dir.glob('lib/tasks/**/*.rake').each do |task|
  load task
end
