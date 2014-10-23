SERVICE_URL = 'http://ironbroker.flatironschool.com'
SERVICE_ENDPOINT = '/e/flatiron_rspec/build/ironboard'
require 'rspec/ironboard'
require 'colorize'

# the absolute path to the directory containing all your labs goes here!
# it's ok if you have subfolders
labs_path = "/users/[your details here]"

# your github username here!
username = ""

# this is a preference. if you run this file more than once,
# it will skip labs it has already tested and found to pass
# unless you change this to false
skip_successful_labs_on_rerun = true

labs_without_tests = ["git-merge-conflicts-ruby-006", "countdown-to-midnight-ruby-006",
  "scraping-the-students-page-ruby-006", "debug-me-ruby-006", "rack-todo-ruby-006",
  "config-ru-tutorial-ruby-006", "middleware-tutorial-ruby-006", "sinatra-adventure-ruby-006", "sinatra-messages-ruby-006"]
labs_that_dont_work_with_this_gem = ["first-lab-ruby-006", "activerecord-costume-store-todo-ruby-006",
  "playlister-on-activerecord-ruby-006", "playlister-static-generator-with-ar-ruby-006"]

# if any labs throw an error, add them here to skip them when you re-run
other_labs_to_skip = []

skipped_labs = labs_without_tests | labs_that_dont_work_with_this_gem | other_labs_to_skip



class IronboardTester
  attr_reader :path
  attr_accessor :username, :skipped_labs, :skip_successful_labs_on_rerun, :passing_labs, :labs, :unskipped, :forced

  def initialize(path, username, skipped_labs, skip_successful_labs_on_rerun)
    @path = path
    @username = username
    @skipped_labs = skipped_labs
    @skip_successful_labs_on_rerun = skip_successful_labs_on_rerun
    @passing_labs = read_or_create_log
    @labs = get_labs
    @unskipped = []
    @forced = false
  end

  def user_id
    @user_id ||= get_user_id
  end

  def username=(name)
    @username = name
    @user_id = get_user_id
    @username
  end

  def get_user_id
    RSpec::Ironboard::GitHubInteractor.get_user_id_for(username)
  end

  def new_runner(lab)
    RSpec::Ironboard::Runner.new(username, user_id, lab_name(lab), [])
  end

  def skip(lab)
    skipped_labs << lab
    unskipped.delete(lab)
  end

  def force(lab)
    self.forced = true
    unskipped << lab
  end

  def test(lab)
    Dir.chdir "#{lab}" do
      runner = new_runner(lab)
      runner.run
      if runner.formatted_results[:failure_count] == 0
        log(lab)
      end
    end
  end

  def log(lab)
    File.open("#{path}/.passing_labs", 'a') do |f|
      f.puts lab_name(lab)
    end
  end

  def skip_successful_labs_on_rerun=(value)
    reset_labs if value == false
    @skip_successful_labs_on_rerun = value
  end

  def reset_labs
    self.labs = get_labs
  end

  def read_or_create_log
    f = File.open("#{path}/.passing_labs", 'a+')
      passing_labs = f.each_line.with_object([]) { |line, ary| ary.push line.strip }
    f.close
    passing_labs
  end

  def get_labs
    Dir.glob("#{path}/**/*006/").sort_by{ |f| File.ctime(f) }
  end

  def skip_passing_labs
    self.skipped_labs = skipped_labs | passing_labs
  end

  def reject_skipped_labs
    skipped_labs.each do |skipped_lab|
      labs.reject! { |lab| lab.include? skipped_lab }
    end
  end

  def lab_name(lab)
    lab.split("/").find { |str| str.include? "-ruby-006" }
  end

  def nice_lab_name(lab)
    lab_name(lab).sub("-ruby-006","").split("-").map(&:capitalize).join(" ")
  end

  def announce(lab)
    puts "\nChecking #{nice_lab_name(lab)}...\n".magenta
  end

  def test_all
    labs.each do |lab|
      announce(lab)
      test(lab)
    end
  end

  def run
    self.passing_labs = read_or_create_log
    skip_passing_labs if skip_successful_labs_on_rerun
    self.skipped_labs = skipped_labs - unskipped if forced
    reject_skipped_labs
    puts "All the non-skipped labs have already been tested and passed!".magenta if labs.empty?
    test_all
  end

end


tester = IronboardTester.new(labs_path, username, skipped_labs, skip_successful_labs_on_rerun)

tester.run
