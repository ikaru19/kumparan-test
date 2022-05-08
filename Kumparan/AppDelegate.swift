//
//  AppDelegate.swift
//  Kumparan
//
//  Created by Engineering on 04/05/22.
//

import UIKit
import Cleanse

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var propertyInjector: PropertyInjector<AppDelegate>!
    var _injectorResolver: InjectorResolver!
    var _vcResolver: ViewControllerResolver!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        propertyInjector = try! ComponentFactory.of(AppComponent.self).build(())
        propertyInjector.injectProperties(into: self)
        precondition(_injectorResolver != nil)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: ProvideInjectorResolver, ProvideViewControllerResolver {
    /// Since we don't control creation of our AppDelegate, we have to use "property injection" to populate
    /// our required properties
    func injectProperties(_ injectorResolver: InjectorResolver, _ vcResolver: ViewControllerResolver) {
        _injectorResolver = injectorResolver
        _vcResolver = vcResolver
    }

    var injectorResolver: InjectorResolver {
        _injectorResolver
    }
    var vcResolver: ViewControllerResolver {
        _vcResolver
    }
}
