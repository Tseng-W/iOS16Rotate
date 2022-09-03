//
//  LandscapeWindow.swift
//  RotateDemo
//
//  Created by 曾問 on 2022/9/3.
//

import UIKit

class LandscapeWindow: UIWindow {
    static let shared: LandscapeWindow = LandscapeWindow(frame: .zero)

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard let previousTraitCollection else {
            debug("PreviousTraitCollection unexpected found nil.")
            return
        }
        debug(root: previousTraitCollection, \.verticalSizeClass)
        debug(root: previousTraitCollection, \.horizontalSizeClass)
    }

    func showLandscapeWindow(rootVC: UIViewController) {
        rootViewController = rootVC

        guard isKeyWindow == false else { return }
        isHidden = false
        frame = UIScreen.main.bounds
        makeKeyAndVisible()
    }

    func dismissWindow() {
        rootViewController = nil
        isHidden = true
    }
}
