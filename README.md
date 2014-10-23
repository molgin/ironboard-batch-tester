# Ironboard Batch Tester

Ironboard Batch Tester uses the new Ironboard gem to run local tests on all your labs at once, so that new grey light on all your old labs can turn green.

----
## Setup

#### 1. Clone this repo.

It doesn’t matter where you put it.

#### 2. Add your details.

Open `ironboard-batch-tester.rb`. Toward the top of the file, you'll see this:

```
# the absolute path to the directory containing all your labs goes here!
# it's ok if you have subfolders
labs_path = "/users/[your details here]"

# your github username here!
username = ""

```

Add that info and save the file.

#### (Optional) Change settings and skip labs.

By default, Batch Tester will keep track of the labs it has tested and found to pass, and will skip them if you re-run it. To turn off this feature and test all labs every time, change `skip_successful_labs_on_rerun` to `false`.

If one of your labs ends up throwing an error, Batch Tester will terminate. If this happens it's probably a problem with your code for that lab just like when RSpec throws an error. If you don't want to fix it right away, you can just add the name of that lab to the `other_labs_to_skip` array, following the format of the other arrays, so that Batch Tester will be able to finish testing the other labs when you re-run it.

----
## Usage

To run Batch Tester, just run `ruby ironboard-batch-tester.rb` from inside the ironboard-batch-tester folder, or run `ruby [path]` from any directory, where [path] is the path to ironboard-batch-tester.rb.

---- 