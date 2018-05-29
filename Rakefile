task(:default) { sh %( rake --tasks ) }

namespace :test do
  desc "Run Chef's code-style linter, cookstyle"
  task :lint do
    sh %( chef exec cookstyle )
  end

  desc "Run Chef's cookbook linter, foodcritic"
  task :critic do
    sh %( chef exec foodcritic . )
  end

  task foodcritic: [:critic]

  desc "Run Chef's linter and attempt to auto-correct offenses"
  task :lintfix do
    sh %( chef exec cookstyle --auto-correct )
  end

  desc 'Run the unit tests'
  task :unit do
    sh %( chef exec rspec spec/ )
  end

  task spec: [:unit]

  desc 'Spin up the kitchen instances for integration testing'
  task :provision do
    sh %( chef exec kitchen create )
  end

  desc 'Apply the cookbook to the running kitchen instances'
  task :deploy do
    sh %( chef exec kitchen converge )
  end

  desc 'Run the integration tests against already running kitchen instances'
  task :verify do
    sh %( chef exec kitchen verify )
  end

  desc 'Run the integration tests start to finish'
  task :integration do
    sh %( chef exec kitchen test )
  end

  desc 'Cleanup various artificats like lockfiles and running kitchen instances'
  task :cleanup do
    rm_rf ['Berksfile.lock', 'Gemfile.lock']
    sh %( chef exec kitchen destroy )
    rm_rf '.kitchen'
  end

  desc 'Run all tests in the following order: Lint => Critic => Unit => Integration'
  task all: %i(lint critic unit integration)

  desc 'Start `guard` for continuous testing'
  task :guard do
    sh %( bundle exec guard start )
  end
end
