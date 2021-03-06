# encoding: UTF-8

require 'capybara/rspec'
require 'rspec-html-matchers'

if RUBY_VERSION.to_i >= 2
  require_relative '_config'
else
  require './spec/_config'
end

RSpec.configure do |config|
  # Pour les matchers RSpec
  config.include RSpecHtmlMatchers
  
  Dir["./spec/support/everytime/**/*.rb"].each { |m| require m }
  
  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

# The settings below are suggested to provide a good initial experience
# with RSpec, but feel free to customize to your heart's content.
=begin
  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with
  # `:focus` metadata. When nothing is tagged with `:focus`, all examples
  # get run.
=end
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

=begin
  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended. For more details, see:
  #   - http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax
  #   - http://teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  #   - http://myronmars.to/n/dev-blog/2014/05/notable-changes-in-rspec-3#new__config_option_to_disable_rspeccore_monkey_patching
  config.disable_monkey_patching!

  # This setting enables warnings. It's recommended, but in some cases may
  # be too noisy due to issues in dependencies.
  config.warnings = true

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 10

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed
=end
  
  config.before :all do
    # On initialise tout un tas de fichiers/dossiers qui
    # seront utiles
    mytest.init
  end
  config.after :all do
    # On détruit le dossier temporaire qui a pu être
    # construit pour le module de test
    mytest.pfoldertmp.remove if mytest.pfoldertmp.exist?
  end
  
  config.before :suite do
  end
  config.after :suite do
  end

  # À appeler au début de tous les describes
  def lets_in_describe
    let(:p)           { mytest.pfile }
    let(:pfoldertmp)  { mytest.pfoldertmp }
    let(:pfolder)     { mytest.pfolder }
    let(:pfile)       { mytest.pfile }
    let(:pfileerb)    { mytest.pfileerb }
    let(:pfilemd)     { mytest.pfilemd }
    let(:pfileruby)   { mytest.pfileruby }
    let(:pfilehtml)   { mytest.pfilehtml }
    let(:pinexistant) { mytest.pinexistant }
  end

  def mytest
    @mytest ||= MyTest::new
  end
  
  def debug str
    STDOUT.puts str
  end
  
  
end