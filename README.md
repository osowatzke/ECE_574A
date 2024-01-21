### Creating Vivado Project

To create the Vivado project for the first time, navigate to the repo root directory and run:

`source ../scripts/project.tcl`

### Syncing Vivado Project Files

Once the project has been created, sources included in the project will not be added/removed automatically. This can be accomplished using "File > Add or create design sources". A script has been added to this repo to automatically perform this syncing. It should be run from the repo root directory as follows:

`source ../scripts/update_sources.tcl`

### Git Commands

Git can be downloaded using the following link: [https://git-scm.com/downloads](https://git-scm.com/downloads). Once you have git installed, open git bash. Within git bash, navigate to the directory you wish to clone the repo into. This can be done using the following command.

`cd <dirname>`

where <dirname> is the directory you wish to clone the repo into.

Then, clone the repo with the following command:

`git clone <url>`

where <url> is the URL of the git repo.
