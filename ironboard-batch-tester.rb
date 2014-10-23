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

user_id = RSpec::Ironboard::GitHubInteractor.get_user_id_for(username)

labs_without_tests = ["git-merge-conflicts-ruby-006", "countdown-to-midnight-ruby-006",
  "scraping-the-students-page-ruby-006", "debug-me-ruby-006", "rack-todo-ruby-006",
  "config-ru-tutorial-ruby-006", "middleware-tutorial-ruby-006", "sinatra-adventure-ruby-006"]
labs_that_dont_work_with_this_gem = ["first-lab-ruby-006", "activerecord-costume-store-todo-ruby-006",
  "playlister-on-activerecord-ruby-006", "playlister-static-generator-with-ar-ruby-006"]

# if any labs throw an error, add them here to skip them when you re-run
other_labs_to_skip = []

skipped_labs = labs_without_tests + labs_that_dont_work_with_this_gem + other_labs_to_skip

def test_all(path, skipped_labs, username, user_id, skip_successful_labs_on_rerun)
  Dir.chdir path do
    f = File.open('.passing_labs', 'a+')
    passing_labs = f.each_line.with_object([]) { |line, ary| ary.push line.strip }
    f.close
    labs = Dir.glob("**/*006/").sort_by{ |f| File.ctime(f) }
    # puts labs
    skipped_labs += passing_labs if skip_successful_labs_on_rerun
    skipped_labs.each do |skipped_lab|
      labs.reject! { |lab| lab.include? skipped_lab }
    end
    puts "All the non-skipped labs have already been tested and passed!" if labs.empty?
    labs.each do |lab|
      Dir.chdir lab do
        lab_name = lab.split("/").find { |str| str.include? "-ruby-006" }
        nice_lab_name = lab_name.sub("-ruby-006","").split("-").map(&:capitalize).join(" ")
        puts "\nChecking #{nice_lab_name}...\n\n".magenta
        repo = RSpec::Ironboard::RepoParser.get_repo
        runner = RSpec::Ironboard::Runner.new(username, user_id, repo, [])
        runner.run
        if runner.formatted_results[:failure_count] == 0
          File.open("#{path}/.passing_labs", 'a') do |f|
            f.puts lab_name
          end
        end
      end
    end
  end
end

test_all(labs_path, skipped_labs, username, user_id, skip_successful_labs_on_rerun)


