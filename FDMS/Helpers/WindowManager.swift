//
//  WindowManager.swift
//  FDMS
//
//  Created by Huy Pham on 4/7/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation
import MBProgressHUD

class WindowManager: NSObject {
    
    static let shared: WindowManager = WindowManager()
    private var window: UIWindow? = UIApplication.shared.keyWindow

    // MARK: - ProgressView properties
    
    lazy var progressWindow: UIWindow = {
        let aWindow = UIWindow(frame: UIScreen.main.bounds)
        aWindow.windowLevel = UIWindowLevelStatusBar + 0.2
        aWindow.isOpaque = true
        return aWindow
    }()
    lazy var progressView: MBProgressHUD = {
        let pView = MBProgressHUD(view: self.progressWindow)
        pView.animationType = .fade
        pView.isUserInteractionEnabled = true
        pView.label.text = "Loading".localized
        return pView
    }()
    
    // MARK: - AlertView properties
    
    lazy var alertWindow: UIWindow = {
        let awindow = UIWindow(frame: UIScreen.main.bounds)
        awindow.windowLevel = UIWindowLevelAlert + 0.1
        awindow.isOpaque = true
        awindow.rootViewController = UIViewController()
        return awindow
    }()
    
    func getCurrentWindowLevel() -> CGFloat {
        if let window = self.window {
            return window.windowLevel
        }
        return UIWindowLevelStatusBar
    }
    
    // MARK: - Progress Action
    
    func showProgressView() {
        self.progressWindow.windowLevel = self.getCurrentWindowLevel() + 0.2
        DispatchQueue.main.async {
            self.progressWindow.isHidden = false
            self.progressView.frame = CGRect(x: 0, y: 0,
                                             width: self.progressWindow.bounds.size.width,
                                             height: self.progressWindow.bounds.size.height)
            self.progressView.removeFromSuperview()
            self.progressWindow.addSubview(self.progressView)
            self.progressWindow.bringSubview(toFront: self.progressView)
            self.progressView.show(animated: true)
        }
    }
    
    func hideProgressView() {
        DispatchQueue.main.async {
            self.progressView.hide(animated: false)
            self.progressWindow.isHidden = true
        }
    }
    
    // MARK: - Alert Action
    
    func showMessage(message: String, title: String?, completion: ((UIAlertAction) -> Void)?) {
        self.alertWindow.windowLevel = self.getCurrentWindowLevel() + 0.1
        let alertController = UIAlertController(title: title ?? "Alert".localized, message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized,
                                     style: .default) { [weak self] (action) in
            self?.alertWindow.isHidden = true
            completion?(action)
        }
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.alertWindow.isHidden = false
            self.alertWindow.rootViewController?.present(alertController, animated: true,
                                                         completion: nil)
        }
    }
    
    func directionTabbarVC() {
        guard let window = self.window else {
            return
        }
        let tabbarViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "MainTabBarVC")
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromTop, animations: { 
            window.rootViewController = tabbarViewController
        }, completion: nil)
    }
    
}
