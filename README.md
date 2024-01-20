To create the Vivado project for the first time, navigate to the repo root directory and run:

`source ../scripts/project.tcl`

Once the project has been created, sources included in the project will not be added/removed automatically. This can be accomplished using "File > Add or create design sources". A script has been added to this repo to automatically perform this syncing. It should be run from the repo root directory as follows:

`source ../scripts/update_sources.tcl`

Test PR Process
