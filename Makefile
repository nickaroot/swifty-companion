.PHONY: dependencies generate fastlane-update deploy-beta deploy clear-cached-build clear-generated clean brew sync-all-submodules all

dependencies:
	tuist fetch
	Tuist/Dependencies/SwiftPackageManager/.build/checkouts/needle/Generator/bin/needle generate Targets/SwiftyCompanion/Sources/NeedleGenerated.swift Targets/ --additional-imports "import SCRouter"

generate:
	tuist generate

fastlane-update:
	bundle update fastlane

deploy-beta: fastlane-update
	bundle exec fastlane qa

deploy: fastlane-update
	bundle exec fastlane prod

tuist-clean:
	tuist clean

clear-generated:
	rm -rf *.xcodeproj
	rm -rf *.xcworkspace
	rm -rf Derived
	rm -rf Targets/*/*.xcodeproj
	rm -rf Targets/*/*.xcworkspace
	rm -rf Targets/*/Derived

clear-cached-build:
	rm -rf ${HOME}/Library/Developer/Xcode/DerivedData/*

clean: clear-cached-build clear-generated tuist-clean

brew:
	./install_macos_dependencies.sh

sync-all-submodules:
	./sync_all.sh

all: brew
