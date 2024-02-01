### Creating Vivado Project

To create the Vivado project for the first time, navigate to the repo root directory and run:

`source ./scripts/project.tcl`

### Syncing Vivado Project Files

Once the project has been created, sources included in the project will not be added/removed automatically. This can be accomplished using "File > Add or create design sources". A script has been added to this repo to automatically perform this syncing. It should be run from the repo root directory as follows:

`source ./scripts/update_sources.tcl`

### Update Vivado Autogen Files

When you add sources to the project, you will also want to update the corresponding autogenerated tcl file. This enables other users to replicate your project. To update this file, you will want click File \> Project \> Write Tcl. When the window pops up, ensure that all options are unchecked. Then, set the path of the autogenerated file to repo root directory. If you do not set the path to the repo root directory, the tcl file will not work as intended. Once the file has been write to the root directory, move it into the scripts directory, overwriting the existing tcl file. Then, commit your updates. 

### Computing Critical Paths

Critical paths can be manually computed by setting the top-level module, adjusting the DATAWIDTH parameter, running synthesis, and reporting timing. The top-level module can be set in Tools \> Settings \> General. Then the DATAWIDTH parameter can be set using the following command:

`set_property generic {DATAWIDTH=<data_width>} [current_fileset]`

where \<data_width\> is a value in the set {2,8,16,32,64}. Next, synthesis can be run by clicking "Run Synthesis". After synthesis has been completed, the synthesized design must be opened. Then, a timing report can be generated by clicking Reports \> Timing \> Timing Summary. Proceed with the default options. The path with the largest delay should appear under the unconstrained paths.

These steps have been consolidated into a single script, which performs this process for each module and DATAWIDTH. This script can be run using the following command:

`source ./scripts/get_critical_paths.tcl`

Note that the output will be printed to the terminal by default. It can be routed to a file with the following command:

`source ./scripts/get_critical_paths.tcl > fileName.txt`

### Estimating Critical Path of Behavioral Netlists

A python convenience function has been created to estimated the critical path of a behavioral netlist. It requires critical path data from each of the subcomponents. It can be called as follows

`python ./scripts/estimate_critical_path.py ./circuits/<circuit_filename>`

where \<circuit_filename\> is the name of the behavioral netlist circuit.

### Git Commands

Git can be downloaded using the following link: [https://git-scm.com/downloads](https://git-scm.com/downloads). Once you have git installed, open git bash. Within git bash, navigate to the directory you wish to clone the repo into. This can be done using the following command.

`cd <directory>`

where \<directory\> is the directory you wish to clone the repo into.

Then, clone the repo with the following command:

`git clone <url>`

where \<url\> is the URL of the git repo.

All development should be done in a separate branch. To create a separate branch off main. Start by checking out main (If you just cloned the repo, main will be checked out by default). Main can be checked out using the following command:

`git checkout main`

Before branching, update main using the following command:

`git pull`

Then, checkout a new branch with the following command:

`git checkout -b <branch>`

where \<branch\> is the branch you want to checkout. You can name your branch as desired. One possible naming convention for branches is issue\<issue_number\>_\<issue_description\>, where \<issue_number\> and \<issue_description\> refer to the issue you are trying to resolve.

Once you have created a development branch, you can start development. You should be able to see modified and untracked files using the following command:

`git status`

You can make multiple commits as you work through issues. To perform a commit, first add the relevant files. You can add files using the following command:

`git add <filename>`

where \<filename\> is the name of the file you wish to add. You can also add all files with the following command:

`git add -A`

Once you have added all the relevant files, you will want to issue the following command:

`git commit -m "<commit_message>`

where \<commit_message\> is a very short description of your commit. Then, push your branch to the repo with the following command:

`git push`

If this is the first time you are pushing to your branch, you will want to issue the command as follows:

`git push --set-upstream origin <branch_name>`

where \<branch_name\> is the name of the branch you wish to commit to. Don't worry if you don't issue the right push command, git will give you the right command.

Once you have finished all development on your branch, you can create a pull request. Once your pull request has been approved, it will automatically be merged with main.
