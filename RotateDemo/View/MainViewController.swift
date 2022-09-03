//
//  ViewController.swift
//  RotateDemo
//
//  Created by 曾問 on 2022/9/3.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {

    enum Direction {
        case vertical, horizontal
    }

    private let direction: Direction
    private let disposedBag: DisposeBag = .init()

    init(direction: Direction) {
        self.direction = direction
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        direction == .vertical ? .portrait : .landscape
    }

    private let fullScreenButton: UIButton = create { button in
        button.setTitle("Fullscreen", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindView()
    }

    private func setupUI() {
        let bgView: UIView = .init()
        bgView.backgroundColor = .gray
        view.backgroundColor = direction == .vertical ? .white : .blue
        view.addSubview(bgView)
        view.addSubview(fullScreenButton)
        bgView.snp.makeConstraints { make in
            make.centerX.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        fullScreenButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    private func bindView() {
        fullScreenButton.rx.tap
            .asDriver()
            .drive(fullscreenAction)
            .disposed(by: disposedBag)
    }

    private var fullscreenAction: Binder<Void> {
        return .init(self) { vc, _ in
            guard vc.direction == .vertical else {
                LandscapeWindow.shared.dismissWindow()
                return
            }

            let injectDirection: Direction = vc.direction == .vertical ? .horizontal : .vertical
            guard let targetVC = UIApplication.main?.rootContainer.resolve(MainViewController.self, argument: injectDirection) else {
                debug("MainViewController inject failed.")
                return
            }
            LandscapeWindow.shared.showLandscapeWindow(rootVC: targetVC)
            let toLandscape = vc.direction == .vertical
            if #available(iOS 16, *) {
                guard let scene = UIApplication.shared.connectedScenes.first else {
                    debug("Scene not exist")
                    return
                }
                guard let windowScene = scene as? UIWindowScene else {
                    debug("Scene isn't window scene")
                    return
                }
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: toLandscape ? .landscape : .portrait)) { error in
                    debug(error.localizedDescription)
                }
            } else {
                // MARK: Untested
                let direction: UIInterfaceOrientation = toLandscape ? .landscapeLeft : .portrait
                UIDevice.current.setValue(direction.rawValue, forKey: "orientation")
            }
        }
    }
}
