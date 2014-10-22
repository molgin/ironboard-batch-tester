SERVICE_URL = 'http://ironbroker.flatironschool.com'
SERVICE_ENDPOINT = '/e/flatiron_rspec/build/ironboard'
require 'rspec/ironboard'
require 'colorize'

# the absolute path to the directory containing all your labs goes here!
# it's ok if you have subfolders
labs_path = "/users/[your details here]"

# your github username here!
username = ""

user_id = RSpec::Ironboard::GitHubInteractor.get_user_id_for(username)

labs_without_tests = ["git-merge-conflicts-ruby-006", "countdown-to-midnight-ruby-006",
  "scraping-the-students-page-ruby-006", "debug-me-ruby-006", "rack-todo-ruby-006",
  "config-ru-tutorial-ruby-006", "middleware-tutorial-ruby-006", "sinatra-adventure-ruby-006"]
labs_that_dont_work_with_this_gem = ["first-lab-ruby-006", "activerecord-costume-store-todo-ruby-006",
  "playlister-on-activerecord-ruby-006", "playlister-static-generator-with-ar-ruby-006"]
skipped_labs = labs_without_tests + labs_that_dont_work_with_this_gem

def test_all(path, skipped_labs, username, user_id)
  Dir.chdir path do
    labs = Dir.glob("**/*006/").sort_by{ |f| File.ctime(f) } - skipped_labs
    puts labs
    labs.each do |lab|
      Dir.chdir lab do
        nice_lab_name = lab.sub("-ruby-006","").split("-").map(&:capitalize).join(" ")
        puts "\nChecking #{nice_lab_name}...\n\n".magenta
        repo = RSpec::Ironboard::RepoParser.get_repo
        runner = RSpec::Ironboard::Runner.new(username, user_id, repo, [])
        runner.run
      end
    end
  end
end

test_all(labs_path, skipped_labs, username, user_id)


