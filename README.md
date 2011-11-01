# NewDot

The New API for interfacing with FamilySearch using Apple technologies.

## Installation

Clone NewDot into your project as a Git submodule, then clone the other sub-submodules that NewDot depends on:

	git submodule add git@github.com:FSDEV/NewDot.git vendor/NewDot
	cd vendor/NewDot
	git submodule init
	git submodule update
	
From here you have two options: link to a Static Library, or copy file references into your project.

The static library is slightly more flexible, and allows you to hide the implementation of NewDot from your application promoting encapsulation. However, some testing has found that Xcode fails (badly) at discovering user headers. I don't have a definitive solution to fix the problem, though it is somewhat reproduceable.

In the event that you experience this, or just don't want to bother dealing with this potential failure, use the "File References" instructions.
	
### Static Library

Add the NewDot project to your Xcode project workspace; under your application's Build Phases tab, add "NewDot" as a Target Dependency. To your project add the linker flags `-all_load -ObjC` to ensure that categories are loaded correctly. Finally, ensure that you add `$(BUILT_PRODUCTS_DIR)` (non-recursive) to your User Header Search Paths.

You should now be linking against the NewDot library. The headers are accessed using a prefix. For example, if I wanted to import `NDService.h`, I would import `NewDot/NDService.h`.

### File References

Do not add the NewDot project to your Xcode project workspace. Instead, open the NewDot directory and drag the following files into your project from Finder:

*Headers and Implementation* (Grab both the `.h` and `.m` file of these)

* NDService
* NDService+Identity
* NDService+FamilyTree
* NDService+Discussions
* NDService+Reservation
* NDService+Implementation
* NSDictionary+Merge
* NSArray+Chunky
* NSString+LastWord
* NSData+StringValue (not actually required, but calling `fs_UTF8String` on `NSData` during debugging can be helpful)
* NSURL+QueryStringConstructor
* NSString+Base64
* JSONKit

From there you should be good to go. Be warned that your code may break when you update if I add new files (in which case you'll have to drag them into your project) or if I remove files (in which case you'll get red files in Xcode - just delete them and you should be good).

## Licensing

NewDot is licensed under the [Firestorm Development Open-Source License](http://fsdev.net/fdosl/). More information can be found in the file `COPYING.md`.