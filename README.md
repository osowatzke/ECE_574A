### Creating Vivado Project

To create the Vivado project for the first time, navigate to the repo root directory and run:

`source ../scripts/project.tcl`

### Syncing Vivado Project Files

Once the project has been created, sources included in the project will not be added/removed automatically. This can be accomplished using "File > Add or create design sources". A script has been added to this repo to automatically perform this syncing. It should be run from the repo root directory as follows:

`source ../scripts/update_sources.tcl`

### Git Commands

Git can be downloaded using the following link: [https://git-scm.com/downloads](https://git-scm.com/downloads). Once you have git installed, open git bash. Within git bash, navigate to the directory you wish to clone the repo into. This can be done using the following command.

`cd <directory>`

where \<directory\> is the directory you wish to clone the repo into.

Then, clone the repo with the following command:

`git clone <url>`

where \<url\> is the URL of the git repo.

All development should be done in a separate branch. To create a separate branch off master. Start by checking out master (If you just cloned the repo, master will be checked out by default). Master can be checked out using the following command:

`git checkout master`

Before branching, update master using the following command:

`git pull`

Then, checkout a new branch with the following command:

`git checkout -b <branch>'

where \<branch\> is the branch you want to checkout. You can name your branch as desired. One possible naming convention for branches is issue/<issue_number>_<issue_description>, where <issue_number> and <issue_description> refer to the issue you are trying to resolve.

Once you have created a development branch, you can start development. You should be able to see modified and untracked files using the following command:

`git status`

You can make multiple commits as you work through issues. To perform a commit, first add the relevant files. You can add files using the following command:

`git add <filename>`

where \<filename\> is the name of the file you wish to add. You can also add all files with the following command:

`git add -A`

Once you have added all the relevant files, you will want to issue the following command:

`git commit -m "<commit_message>"

where \<commit_message\> is a very short description of your commit. Then, push your branch to the repo with the following command:

`git push`

If this is the first time you are pushing to your branch, you will want to issue the command as follows:

`git push --set-upstream origin <branch_name>`

where \<branch_name\> is the name of the branch you wish to commit to. Don't worry if you don't issue the right push command, git will give you the right command.

Once you have finished all development on your branch, you can create a pull request. Once your pull request has been approved, it will automatically be merged with master.

