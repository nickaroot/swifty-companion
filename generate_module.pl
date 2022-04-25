#!/usr/bin/perl
# **************************************************************************** #
#                                                                              #
#                                                         ::::::   ::::::      #
#    gen.pl                                              :+:+:       :+:       #
#                                                       +:+ +:+     +:+        #
#    By: nickaroot <nickaroot.me>                      +:+   +:+   +:+         #
#                                                     +#+     +#+ +#+          #
#    Created: 2019/05/20 03:54:02 by nickaroot       #+#       #+#+#           #
#    Updated: 2019/05/20 04:47:37 by nickaroot      ####       ####.me         #
#                                                                              #
# **************************************************************************** #

use strict;
use warnings;
use POSIX qw(strftime);
use File::Path qw(make_path);

main();

sub main {

    if ($#ARGV < 0) {
        
        my $usage = <<~EOF;
            usage: ./generate_module.pl <ModuleName> [<DeveloperName>]
            
            ex.: ./generate_module.pl SampleModule
            
            ex.: ./generate_module.pl SampleModule Craig Frederighi
            EOF

        print $usage;

        exit;

    }

    my $projectName = shift @ARGV;
    my @parsedDeveloperName = `finger \$(whoami)` =~ /Name: ([a-zA-Z0-9 ]{1,})/;
    my $developerName = $#ARGV > 0 ? shift @ARGV : shift @parsedDeveloperName;

    path($projectName);
    package_swift($projectName);
    di($projectName, $developerName);
    interactor($projectName, $developerName);
    nodes($projectName, $developerName);
    presenter($projectName, $developerName);
    router($projectName, $developerName);
    view($projectName, $developerName);
    tests($projectName);
    tuist_dependencies($projectName);
    tuist_project($projectName);

}

sub path($) {
    my ($projectName) = @_;

    `mkdir -p Targets/${projectName}`;
}

sub package_swift($) {
    my ($projectName) = @_;

    my $package = <<~EOF;
        // swift-tools-version:5.5

        import PackageDescription

        let package = Package(
            name: "${projectName}",
            platforms: [
                .iOS(.v15),
            ],
            products: [
                .library(
                    name: "${projectName}",
                    targets: ["${projectName}"]),
            ],
            dependencies: [
                .package(
                    name: "NeedleFoundation",
                    url: "https://github.com/uber/needle",
                    branch: "master"
                ),
                .package(url: "https://github.com/nickaroot/TextureUI.git", branch: "master"),
                .package(name: "SCUI", path: "../SCUI"),
                .package(name: "SCAPI", path: "../SCAPI"),
            ],
            targets: [
                .target(
                    name: "${projectName}",
                    dependencies: [
                        "NeedleFoundation",
                        "TextureUI",
                        "SCUI",
                        "SCAPI",
                    ]),
                .testTarget(
                    name: "${projectName}Tests",
                    dependencies: ["${projectName}"]),
            ]
        )
        EOF

    die "Unable to create Targets/${projectName}/Package.swift\n" unless(open PACKAGEFILE, ">Targets/${projectName}/Package.swift");

    print PACKAGEFILE $package;

    close PACKAGEFILE;
}

sub source_header($$$) {

    my ($moduleFileName, $projectName, $developerName) = @_;
    my $date = strftime "%d.%m.%Y", localtime;

    my $header = <<~EOF;
        //
        //  $moduleFileName
        //
        //  Created by $developerName on $date.
        //
        EOF

    return $header;

}

sub create_source($$$$) {

    my ($path, $fileName, $source, $isMainFile) = @_;

    if ($isMainFile) {

        die "Unable to create $path\n" unless(make_path "Targets/${path}");

    }

    die "Unable to create Targets/$path/$fileName\n" unless(open SOURCEFILE, ">Targets/$path/$fileName");

    print SOURCEFILE $source;

    close SOURCEFILE;

}

sub di($$) {

    my ($projectName, $developerName) = @_;

    component($projectName, $developerName);
    dependency($projectName, $developerName);

}

sub component($$) {

    my ($projectName, $developerName) = @_;

    my $moduleName = "Component";
    my $moduleFullName = "${projectName}${moduleName}";
    my $modulePath = "${projectName}/Sources/${projectName}/DI";
    my $moduleFileName = "${moduleFullName}.swift";

    my $dependencyName = lcfirst substr $projectName, 4;

    my $moduleHeader = source_header($moduleFileName, $projectName, $developerName);

    my $moduleBody = <<~EOF;
        import NeedleFoundation

        public final class ${projectName}Component: Component<${projectName}Dependency> {
            public typealias View = ${projectName}View
            public typealias ViewInput = ${projectName}ViewInput
            public typealias ViewOutput = ${projectName}ViewOutput

            public typealias Interactor = ${projectName}Interactor
            public typealias InteractorInput = ${projectName}InteractorInput
            public typealias InteractorOutput = ${projectName}InteractorOutput

            public typealias Presenter = ${projectName}Presenter<View>
            public typealias PresenterInput = ${projectName}PresenterInput

            public typealias Router = ${projectName}Router
            typealias RouterInput = ${projectName}RouterInput

            public typealias MainNode = ${projectName}MainNode

            // MARK: - View

            public var view: View {
                View { [self] view in
                    view.presenter = presenter
                    view.node.delegate = presenter

                    mutablePresenter.view = view
                    mutablePresenter.interactor = interactor
                    mutablePresenter.router = router

                    mutableInteractor.presenter = presenter
                }
            }

            // MARK: - Interactor

            var interactor: Interactor { mutableInteractor }

            var mutableInteractor: Interactor { shared { Interactor() } }

            // MARK: - Presenter

            public var presenter: Presenter { mutablePresenter }

            var mutablePresenter: Presenter { shared { Presenter() } }

            // MARK: - Router

            var router: Router { mutableRouter }

            var mutableRouter: Router { shared { Router(routable: dependency.${dependencyName}Routable) } }
        }
        EOF

    my $moduleSource = <<~EOF;
        ${moduleHeader}
        ${moduleBody}
        EOF

    create_source($modulePath, $moduleFileName, $moduleSource, 1);

}

sub dependency($$) {

    my ($projectName, $developerName) = @_;

    my $moduleName = "Dependency";
    my $moduleFullName = "${projectName}${moduleName}";
    my $modulePath = "${projectName}/Sources/${projectName}/DI";
    my $moduleFileName = "${moduleFullName}.swift";

    my $moduleHeader = source_header($moduleFileName, $projectName, $developerName);

    my $dependencyName = lcfirst substr $projectName, 4;

    my $moduleBody = <<~EOF;
        import NeedleFoundation

        public protocol ${projectName}Dependency: Dependency {
            var ${dependencyName}Routable: ${projectName}Routable { get }
        }
        EOF

    my $moduleSource = <<~EOF;
        ${moduleHeader}
        ${moduleBody}
        EOF

    create_source($modulePath, $moduleFileName, $moduleSource, 0);

}


sub interactor($$) {

    my ($projectName, $developerName) = @_;

    my $moduleName = "Interactor";
    my $moduleFullName = "${projectName}${moduleName}";
    my $modulePath = "${projectName}/Sources/${projectName}/${moduleName}";
    my $moduleFileName = "${moduleFullName}.swift";

    my $moduleHeader = source_header($moduleFileName, $projectName, $developerName);

    my $moduleBody = <<~EOF;
        import SCUI

        public final class ${projectName}Interactor: SCInteractorProtocol {
            typealias Component = ${projectName}Component

            weak var presenter: Component.InteractorOutput!
        }
        EOF

    my $moduleSource = <<~EOF;
        ${moduleHeader}
        ${moduleBody}
        EOF

    create_source($modulePath, $moduleFileName, $moduleSource, 1);

    interactorInput($projectName, $developerName, $moduleName);
    interactorOutput($projectName, $developerName, $moduleName);

}

sub interactorInput($$$) {

    my ($projectName, $developerName, $moduleName) = @_;

    my $moduleFullName = "${projectName}${moduleName}";
    my $moduleSuffix = "Input";
    my $moduleSuffixName = "${moduleFullName}${moduleSuffix}";
    my $modulePath = "${projectName}/Sources/${projectName}/${moduleName}";
    my $moduleFileName = "${moduleSuffixName}.swift";

    my $moduleHeader = source_header($moduleFileName, $projectName, $developerName);

    my $moduleBody = <<~EOF;
        import SCUI

        public protocol ${projectName}InteractorInput: SCInteractorInputProtocol {}

        extension ${projectName}Interactor: ${projectName}InteractorInput {}
        EOF

    my $moduleSource = <<~EOF;
        ${moduleHeader}
        ${moduleBody}
        EOF

    create_source($modulePath, $moduleFileName, $moduleSource, 0);

}

sub interactorOutput($$$) {

    my ($projectName, $developerName, $moduleName) = @_;

    my $moduleFullName = "${projectName}${moduleName}";
    my $moduleSuffix = "Output";
    my $moduleSuffixName = "${moduleFullName}${moduleSuffix}";
    my $modulePath = "${projectName}/Sources/${projectName}/${moduleName}";
    my $moduleFileName = "${moduleSuffixName}.swift";

    my $moduleHeader = source_header($moduleFileName, $projectName, $developerName);

    my $moduleBody = <<~EOF;
        import SCUI

        public protocol ${projectName}InteractorOutput: SCInteractorOutputProtocol {}
        EOF

    my $moduleSource = <<~EOF;
        ${moduleHeader}
        ${moduleBody}
        EOF

    create_source($modulePath, $moduleFileName, $moduleSource, 0);

}

sub nodes($$) {

    my ($projectName, $developerName) = @_;

    my $moduleName = "Nodes";
    my $modulePath = "${projectName}/Sources/${projectName}/${moduleName}";

    mainNode($projectName, $developerName, $modulePath);

}

sub mainNode($$$) {

    my ($projectName, $developerName, $modulePath) = @_;

    my $moduleName = "MainNode";
    my $moduleFullName = "${projectName}${moduleName}";
    my $moduleFileName = "${moduleFullName}.swift";

    my $moduleHeader = source_header($moduleFileName, $projectName, $developerName);

    my $moduleBody = <<~EOF;
        import AsyncDisplayKit
        import SFSafeSymbols

        import TextureUI

        import SCAssets
        import SCUI

        public final class ${projectName}MainNode: SCMainNode {
            typealias Component = ${projectName}Component

            weak var delegate: ${projectName}Delegate?

            // MARK: - Did Load

            public override func didLoad() {
                super.didLoad()

                backgroundColor = Asset.Colors.neutral0.color

                statusBarBackground = Asset.Colors.neutral0.color
            }

            // MARK: - Layout Specs

            override public func layoutSpecThatFits(_: ASSizeRange) -> ASLayoutSpec {
                LayoutSpec {
                    VStack {

                    }
                }
            }
        }
        EOF

    my $moduleSource = <<~EOF;
        ${moduleHeader}
        ${moduleBody}
        EOF

    create_source($modulePath, $moduleFileName, $moduleSource, 1);

}

sub presenter($$) {

    my ($projectName, $developerName) = @_;

    my $moduleName = "Presenter";
    my $moduleFullName = "${projectName}${moduleName}";
    my $modulePath = "${projectName}/Sources/${projectName}/${moduleName}";
    my $moduleFileName = "${moduleFullName}.swift";

    my $moduleHeader = source_header($moduleFileName, $projectName, $developerName);

    my $moduleBody = <<~EOF;
        import AsyncDisplayKit
        import SCUI
        import SCAssets

        public final class ${projectName}Presenter<ViewInput: ${projectName}Component.ViewInput>: SCPresenterProtocol {
            typealias Component = ${projectName}Component

            weak var view: ViewInput!

            var router: Component.RouterInput!
            var interactor: Component.InteractorInput!

            public func configureView() { }

            public func showView() {
                router.navigationController = view.navigationController
                router.tabBarController = view.tabBarController

                setupNavigationBar()
            }

            public func hideView() {}

            func setupNavigationBar() {
                view.title = " "
                view.statusBarStyle = .default
                view.modalPresentationCapturesStatusBarAppearance = true
                view.isNavigationBarShowing = true
                view.navigationBackButton = UIBarButtonItem()

                do {
                    let appearance = UINavigationBarAppearance()

                    appearance.configureWithTransparentBackground()
                    appearance.backgroundColor = Asset.Colors.neutral0.color

                    view.navigationItem.standardAppearance = appearance
                    view.navigationItem.scrollEdgeAppearance = appearance
                }
            }
        }
        EOF

    my $moduleSource = <<~EOF;
        ${moduleHeader}
        ${moduleBody}
        EOF

    create_source($modulePath, $moduleFileName, $moduleSource, 1);

    presenterInput($projectName, $developerName, $moduleName);
    presenter_interactorOutput($projectName, $developerName, $moduleName);
    presenter_viewOutput($projectName, $developerName, $moduleName);
    presenterDelegate($projectName, $developerName, $moduleName);

}

sub presenterInput($$$) {

    my ($projectName, $developerName, $moduleName) = @_;

    my $moduleFullName = "${projectName}${moduleName}";
    my $moduleSuffix = "Input";
    my $moduleSuffixName = "${moduleFullName}${moduleSuffix}";
    my $modulePath = "${projectName}/Sources/${projectName}/${moduleName}";
    my $moduleFileName = "${moduleSuffixName}.swift";

    my $moduleHeader = source_header($moduleFileName, $projectName, $developerName);

    my $moduleBody = <<~EOF;
        import SCUI

        public protocol ${projectName}PresenterInput: SCPresenterInputProtocol {
            func configureView()

            func showView()

            func hideView()
        }

        extension ${projectName}Presenter: ${projectName}PresenterInput {}
        EOF

    my $moduleSource = <<~EOF;
        ${moduleHeader}
        ${moduleBody}
        EOF

    create_source($modulePath, $moduleFileName, $moduleSource, 0);

}

sub presenter_interactorOutput($$$) {

    my ($projectName, $developerName, $moduleName) = @_;

    my $moduleFullName = "${projectName}${moduleName}";
    my $moduleExtension = "InteractorOutput";
    my $moduleExtensionName = "${projectName}${moduleExtension}";
    my $modulePath = "${projectName}/Sources/${projectName}/${moduleName}";
    my $moduleFileName = "${moduleFullName}+${moduleExtensionName}.swift";

    my $moduleHeader = source_header($moduleFileName, $projectName, $developerName);

    my $moduleBody = <<~EOF;
        import Foundation

        extension ${projectName}Presenter: ${projectName}InteractorOutput {}
        EOF

    my $moduleSource = <<~EOF;
        ${moduleHeader}
        ${moduleBody}
        EOF

    create_source($modulePath, $moduleFileName, $moduleSource, 0);

}

sub presenter_viewOutput($$$) {

    my ($projectName, $developerName, $moduleName) = @_;

    my $moduleFullName = "${projectName}${moduleName}";
    my $moduleExtension = "ViewOutput";
    my $moduleExtensionName = "${projectName}${moduleExtension}";
    my $modulePath = "${projectName}/Sources/${projectName}/${moduleName}";
    my $moduleFileName = "${moduleFullName}+${moduleExtensionName}.swift";

    my $moduleHeader = source_header($moduleFileName, $projectName, $developerName);

    my $moduleBody = <<~EOF;
        import Foundation

        extension ${projectName}Presenter: ${projectName}ViewOutput {
            public func didLoad() { configureView() }

            public func willAppear(_: Bool) { showView() }

            public func willDisappear(_: Bool) { hideView() }
        }
        EOF

    my $moduleSource = <<~EOF;
        ${moduleHeader}
        ${moduleBody}
        EOF

    create_source($modulePath, $moduleFileName, $moduleSource, 0);

}

sub presenterDelegate($$$) {

    my ($projectName, $developerName, $moduleName) = @_;

    my $moduleFullName = "${projectName}${moduleName}+${projectName}Delegate";
    my $modulePath = "${projectName}/Sources/${projectName}/${moduleName}";
    my $moduleFileName = "${moduleFullName}.swift";

    my $moduleHeader = source_header($moduleFileName, $projectName, $developerName);

    my $moduleBody = <<~EOF;
    import SCUI

    public protocol ${projectName}Delegate: AnyObject { }

    extension ${projectName}Presenter: ${projectName}Delegate { }
    EOF

    my $moduleSource = <<~EOF;
    ${moduleHeader}
    ${moduleBody}
    EOF

    create_source($modulePath, $moduleFileName, $moduleSource, 0);

}

sub router($$) {

    my ($projectName, $developerName) = @_;

    my $moduleName = "Router";
    my $moduleFullName = "${projectName}${moduleName}";
    my $modulePath = "${projectName}/Sources/${projectName}/${moduleName}";
    my $moduleFileName = "${moduleFullName}.swift";

    my $moduleHeader = source_header($moduleFileName, $projectName, $developerName);

    my $moduleBody = <<~EOF;
        import UIKit
        import SCUI

        public final class ${projectName}Router: SCRouterProtocol {
            public weak var navigationController: UINavigationController?
            public weak var tabBarController: UITabBarController?

            weak var routable: ${projectName}Routable!

            init(
                routable: ${projectName}Routable
            ) {
                self.routable = routable
            }
        }
        EOF

    my $moduleSource = <<~EOF;
        ${moduleHeader}
        ${moduleBody}
        EOF

    create_source($modulePath, $moduleFileName, $moduleSource, 1);

    routerInput($projectName, $developerName, $moduleName);
    routable($projectName, $developerName, $moduleName);
}

sub routerInput($$$) {

    my ($projectName, $developerName, $moduleName) = @_;

    my $moduleFullName = "${projectName}${moduleName}";
    my $moduleSuffix = "Input";
    my $moduleSuffixName = "${moduleFullName}${moduleSuffix}";
    my $modulePath = "${projectName}/Sources/${projectName}/${moduleName}";
    my $moduleFileName = "${moduleSuffixName}.swift";

    my $moduleHeader = source_header($moduleFileName, $projectName, $developerName);

    my $moduleBody = <<~EOF;
        import UIKit
        import SCUI

        protocol ${projectName}RouterInput: SCRouterInputProtocol {
            var navigationController: UINavigationController? { get set }
            var tabBarController: UITabBarController? { get set }
        }

        extension ${projectName}Router: ${projectName}RouterInput {}
        EOF

    my $moduleSource = <<~EOF;
        ${moduleHeader}
        ${moduleBody}
        EOF

    create_source($modulePath, $moduleFileName, $moduleSource, 0);

}

sub routable($$$) {

    my ($projectName, $developerName, $moduleName) = @_;

    my $moduleFullName = "${projectName}Routable";
    my $modulePath = "${projectName}/Sources/${projectName}/${moduleName}";
    my $moduleFileName = "${moduleFullName}.swift";

    my $moduleHeader = source_header($moduleFileName, $projectName, $developerName);

    my $moduleBody = <<~EOF;
    import Foundation

    public protocol ${moduleFullName}: AnyObject { }
    EOF

    my $moduleSource = <<~EOF;
    ${moduleHeader}
    ${moduleBody}
    EOF

    create_source($modulePath, $moduleFileName, $moduleSource, 0);

}

sub view($$) {

    my ($projectName, $developerName) = @_;

    my $moduleName = "View";
    my $moduleFullName = "${projectName}${moduleName}";
    my $modulePath = "${projectName}/Sources/${projectName}/${moduleName}";
    my $moduleFileName = "${moduleFullName}.swift";

    my $moduleHeader = source_header($moduleFileName, $projectName, $developerName);

    my $moduleBody = <<~EOF;
        import AsyncDisplayKit
        import SCUI

        public final class ${projectName}View: ASDKViewController<${projectName}Component.MainNode>, SCViewProtocol {
            public typealias Component = ${projectName}Component

            public var presenter: Component.ViewOutput!

            public var statusBarStyle: UIStatusBarStyle = .default {
                didSet { setNeedsStatusBarAppearanceUpdate() }
            }

            override public var preferredStatusBarStyle: UIStatusBarStyle { return statusBarStyle }

            let onDidLoad: ((${projectName}View) -> Void)?

            public init(
            _ onDidLoad: ((${projectName}View) -> Void)? = nil
            ) {
                self.onDidLoad = onDidLoad

                super.init(node: MainNode())
            }

            \@available(*, unavailable) required init?(
            coder _: NSCoder
            ) { fatalError("init(coder:) not implemented") }

            override public func viewDidLoad() {
                super.viewDidLoad()

                onDidLoad?(self)

                presenter.didLoad()
            }

            override public func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)

                presenter.willAppear(animated)
            }

            override public func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)

                presenter.willDisappear(animated)
            }
        }
        EOF

    my $moduleSource = <<~EOF;
        ${moduleHeader}
        ${moduleBody}
        EOF

    create_source($modulePath, $moduleFileName, $moduleSource, 1);

    viewInput($projectName, $developerName, $moduleName);
    viewOutput($projectName, $developerName, $moduleName);

}

sub viewInput($$$) {

    my ($projectName, $developerName, $moduleName) = @_;

    my $moduleFullName = "${projectName}${moduleName}";
    my $moduleSuffix = "Input";
    my $moduleSuffixName = "${moduleFullName}${moduleSuffix}";
    my $modulePath = "${projectName}/Sources/${projectName}/${moduleName}";
    my $moduleFileName = "${moduleSuffixName}.swift";

    my $moduleHeader = source_header($moduleFileName, $projectName, $developerName);

    my $moduleBody = <<~EOF;
        import AsyncDisplayKit
        import SCUI

        public protocol ${projectName}ViewInput: SCViewInputProtocol {
            var presenter: ${projectName}Component.ViewOutput! { get set }

            var navigationController: UINavigationController? { get }
            var tabBarController: UITabBarController? { get }

            var node: ${projectName}Component.MainNode! { get }

            var title: String? { get set }

            var statusBarStyle: UIStatusBarStyle { get set }

            var modalPresentationCapturesStatusBarAppearance: Bool { get set }

            var isNavigationBarShowing: Bool? { get set }

            var navigationBackButton: UIBarButtonItem? { get set }

            var navigationItem: UINavigationItem { get }

            var neverShowPlaceholders: Bool { get set }
        }

        extension ${projectName}View: ${projectName}ViewInput {}
        EOF

    my $moduleSource = <<~EOF;
        ${moduleHeader}
        ${moduleBody}
        EOF

    create_source($modulePath, $moduleFileName, $moduleSource, 0);

}

sub viewOutput($$$) {

    my ($projectName, $developerName, $moduleName) = @_;

    my $moduleFullName = "${projectName}${moduleName}";
    my $moduleSuffix = "Output";
    my $moduleSuffixName = "${moduleFullName}${moduleSuffix}";
    my $modulePath = "${projectName}/Sources/${projectName}/${moduleName}";
    my $moduleFileName = "${moduleSuffixName}.swift";

    my $moduleHeader = source_header($moduleFileName, $projectName, $developerName);

    my $moduleBody = <<~EOF;
        import SCUI

        public protocol ${projectName}ViewOutput: SCViewOutputProtocol {
            func didLoad()

            func willAppear(_ animated: Bool)

            func willDisappear(_ animated: Bool)
        }
        EOF

    my $moduleSource = <<~EOF;
        ${moduleHeader}
        ${moduleBody}
        EOF

    create_source($modulePath, $moduleFileName, $moduleSource, 0);

}

sub tests($) {
    my ($projectName) = @_;

    die "Unable to create Targets/${projectName}/Tests\n" unless(make_path "Targets/${projectName}/Tests");
}

sub tuist_dependencies($) {
    my ($projectName) = @_;

    die "Unable to create Tuist/Dependencies.swift\n" unless(open DEPENDENCIESFILE_READ, "<Tuist/Dependencies.swift");

    my $dependencies = do { local $/; <DEPENDENCIESFILE_READ> };

    close DEPENDENCIESFILE_READ;

    $dependencies =~ s/    \]\,/        .local(path: "Targets\/${projectName}"),\n    ],/g;

    die "Unable to create Tuist/Dependencies.swift\n" unless(open DEPENDENCIESFILE_WRITE, ">Tuist/Dependencies.swift");

    print DEPENDENCIESFILE_WRITE $dependencies;

    close DEPENDENCIESFILE_WRITE;
}

sub tuist_project($) {
    my ($projectName) = @_;

    die "Unable to create Project.swift\n" unless(open PROJECTFILE_READ, "<Project.swift");

    my $project = do { local $/; <PROJECTFILE_READ> };

    close PROJECTFILE_READ;

    $project =~ s/            \]\n        \)\,\n    \]\,/                .external(name: "${projectName}"),\n            ]\n        ),\n    ],/g;

    die "Unable to create Project.swift\n" unless(open PROJECTFILE_WRITE, ">Project.swift");

    print PROJECTFILE_WRITE $project;

    close PROJECTFILE_WRITE;
}
