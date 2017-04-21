//
//  AppDelegate.swift
//  FDMS
//
//  Created by Huy Pham on 3/30/17.
//  Copyright © 2017 Framgia. All rights reserved.
//
import Alamofire
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let manager = NetworkReachabilityManager(host: kBaseURL)
        guard let networkManager = manager else {
            return true
        }
        networkManager.listener = { status in
            switch status {
            case .unknown:
                print("\(status)")
            default:
                print("\(status)")
            }
            print("Network Status Changed: \(status)")
        }
        networkManager.startListening()
        return true
    }

}

