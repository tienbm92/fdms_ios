//
//  MainTabBarController.swift
//  FDMS
//
//  Created by Nguyen Quoc Tinh on 4/3/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import BarcodeScanner
import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        createAddButton()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = #colorLiteral(red: 0.5843137255, green: 0.01960784314, blue: 0.1568627451, alpha: 1)
        viewControllers?.insert(BarcodeScannerController(), at: 2)
    }
    
    private func createAddButton() {
        if let middleButtonView = Bundle.main.loadNibNamed("MiddleButton", owner: self,
                 options: nil)?.first as? MiddleButton {
            let screenWidth = UIScreen.main.bounds.size.width
            if let numberOfVC = self.viewControllers?.count {
                middleButtonView.frame.size = CGSize(width: screenWidth / CGFloat(numberOfVC), height: 70)
            }
            middleButtonView.frame.origin.x = 
                self.view.bounds.width / 2 - middleButtonView.frame.size.width / 2
            middleButtonView.frame.origin.y = 
                self.view.bounds.height - middleButtonView.frame.height
            middleButtonView.addTarget(self, 
                action: #selector(scanButtonTapped(sender:)), for: .touchUpInside)
            self.view.addSubview(middleButtonView)
        }
    }
    
    func scanButtonTapped(sender: UIButton) {
        let scanBarcodeController = BarcodeScannerController()
        scanBarcodeController.codeDelegate = self
        scanBarcodeController.errorDelegate = self
        scanBarcodeController.dismissalDelegate = self
        present(scanBarcodeController, animated: true, completion: nil)
    }

}

extension MainTabBarController: BarcodeScannerCodeDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String,
                        type: String) {
        print(code)
        print(type)
        let delayTime = 
            DispatchTime.now() + Double(Int64(6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            controller.resetWithError()
        }
    }
    
}

extension MainTabBarController: BarcodeScannerErrorDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
    
}

extension MainTabBarController: BarcodeScannerDismissalDelegate {
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
