# Run rake build tasks.
# Usage: From powershell, after installing chefdk
# chef gem install rake
# rake full

require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'foodcritic'
require 'kitchen'

# Style tests. Rubocop and Foodcritic
namespace :style do
  desc 'Run Ruby style checks'
  # RuboCop::RakeTask.new(:ruby)
  RuboCop::RakeTask.new(:ruby) do |tsk|
    tsk.options = ['-a'] # autocorrect
    tsk.fail_on_error = false
  end

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      fail_tags: ['any']
    }
  end
end

desc 'Run all style checks'
task style: ['style:ruby', 'style:chef']

desc 'Run ChefSpec examples'
RSpec::Core::RakeTask.new(:unit) do |t|
  t.pattern = './**/spec/**/*_spec.rb'
end

# Integration tests. Kitchen.ci
namespace :integration do
  desc 'Run Test Kitchen with Vagrant'
  task :vagrant do
    Kitchen.logger = Kitchen.default_file_logger
    Kitchen::Config.new.instances.each do |instance|
      instance.test(:always)
    end
  end
end

# Default
task default: %w(style unit)

task full: %w(integration:vagrant style unit)
