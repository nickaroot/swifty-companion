import AsyncDisplayKit
import NeedleFoundation
import SCAPI
import SCAssets
import SCHelpers
import SCProfile
import SCRouter
import SCSearch
import SCUI

// swiftlint:disable unused_declaration
fileprivate let needleDependenciesHash: String? = nil

// MARK: - Traversal Helpers

fileprivate func parent1(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent
}

// MARK: - Providers

fileprivate class SCProfileDependency3afbb2180a917688d861Provider: SCProfileDependency {
    var api: SCAPI {
        return sCRouterComponent.api
    }
    var profileRoutable: SCProfileRoutable {
        return sCRouterComponent.profileRoutable
    }
    private let sCRouterComponent: SCRouterComponent
    init(
        sCRouterComponent: SCRouterComponent
    ) {
        self.sCRouterComponent = sCRouterComponent
    }
}
/// ^->SCRouterComponent->SCProfileComponent
fileprivate func factory819fc7aa954da5f214d0eb2ee765ed2175b4e3cc(
    _ component: NeedleFoundation.Scope
) -> AnyObject {
    return SCProfileDependency3afbb2180a917688d861Provider(
        sCRouterComponent: parent1(component) as! SCRouterComponent
    )
}
fileprivate class SCSearchDependency12410841107ce11010c1Provider: SCSearchDependency {
    var api: SCAPI {
        return sCRouterComponent.api
    }
    var searchRoutable: SCSearchRoutable {
        return sCRouterComponent.searchRoutable
    }
    private let sCRouterComponent: SCRouterComponent
    init(
        sCRouterComponent: SCRouterComponent
    ) {
        self.sCRouterComponent = sCRouterComponent
    }
}
/// ^->SCRouterComponent->SCSearchComponent
fileprivate func factorycec883f183fc70d25a06eb2ee765ed2175b4e3cc(
    _ component: NeedleFoundation.Scope
) -> AnyObject {
    return SCSearchDependency12410841107ce11010c1Provider(
        sCRouterComponent: parent1(component) as! SCRouterComponent
    )
}

fileprivate func factoryEmptyDependencyProvider(_ component: NeedleFoundation.Scope) -> AnyObject {
    return EmptyDependencyProvider(component: component)
}

// MARK: - Registration
fileprivate func registerProviderFactory(
    _ componentPath: String,
    _ factory: @escaping (NeedleFoundation.Scope) -> AnyObject
) {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(
        for: componentPath,
        factory
    )
}

fileprivate func register1() {
    registerProviderFactory(
        "^->SCRouterComponent->SCProfileComponent",
        factory819fc7aa954da5f214d0eb2ee765ed2175b4e3cc
    )
    registerProviderFactory(
        "^->SCRouterComponent->SCSearchComponent",
        factorycec883f183fc70d25a06eb2ee765ed2175b4e3cc
    )
    registerProviderFactory("^->SCRouterComponent", factoryEmptyDependencyProvider)
}

public func registerProviderFactories() {
    register1()
}
