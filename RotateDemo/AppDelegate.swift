//
//  AppDelegate.swift
//  RotateDemo
//
//  Created by 曾問 on 2022/9/3.
//

import UIKit
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var landscapeWindow: UIWindow? = LandscapeWindow.shared

    var rootContainer: Container = .init()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        injectionRoot(container: rootContainer)

        let window = UIWindow()
        guard let rootVC = rootContainer.resolve(MainViewController.self, argument: MainViewController.Direction.vertical) else { return false }

        window.rootViewController = rootVC
        window.makeKeyAndVisible()

        self.window = window

        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if window == self.window {
            debug("main window. root: \(String(describing: window?.rootViewController.self))")
            return .portrait
        } else if window == self.landscapeWindow {
            debug("landscape window. root: \(String(describing: window?.rootViewController.self))")
            return .landscape
        } else {
            debug("unknown window. root: \(String(describing: window?.rootViewController.self))")
            return .portrait
        }
    }

    private func injectionRoot(container: Container) {
        container.register(MainViewController.self) { _, direction in
            return .init(direction: direction)
        }
    }
}

extension UIApplication {
    static var main: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
}
