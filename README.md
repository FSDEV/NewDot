# NewDot

The New API for interfacing with FamilySearch using Apple technologies.

## Installation

Clone NewDot into your project as a Git submodule, then clone the other sub-submodules that NewDot depends on:

	git submodule add git@github.com:FSDEV/NewDot.git vendor/NewDot
	cd vendor/NewDot
	git submodule init
	git submodule update
	
Add the NewDot project to your Xcode project workspace; under your application's Build Phases tab, add "NewDot" as a Target Dependency. To your project add the linker flags `-all_load -ObjC` to ensure that categories are loaded correctly. Finally, ensure that you add `$(BUILT_PRODUCTS_DIR)` (non-recursive) to your User Header Search Paths.

You should now be linking against the NewDot library. The headers are accessed using a prefix. For example, if I wanted to import `NDService.h`, I would import `NewDot/NDService.h`.

## Licensing

NewDot is licensed under the [Firestorm Development Open-Source License](http://fsdev.net/fdosl/). More information can be found in the file `COPYING.md`.