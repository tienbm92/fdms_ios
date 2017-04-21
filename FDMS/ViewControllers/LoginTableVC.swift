//
//  LoginTableVC.swift
//  FDMS
//
//  Created by Nguyen Quoc Tinh on 3/31/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class LoginTableVC: UITableViewController {
    
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    fileprivate func pushTabbarVC() {
        guard let tabBarVC = storyboard?.instantiateViewController(withIdentifier: "MainTabBarVC") else {
            return
        }
        self.navigationController?.pushViewController(tabBarVC, animated: true)
    }
    fileprivate func getUser() -> User? {
        return User(email: self.emailTextField?.text, password: self.passwordTextField?.text, error: { (message, _) in
            WindowManager.shared.showMessage(message: message, title: nil, completion: nil)
        })
    }
    
    fileprivate func logIn() {
        guard let user = self.getUser() else {
            return
        }
        self.view.endEditing(true)
        WindowManager.shared.showProgressView()
        UserService.share.login(user: user) { (result) in
            WindowManager.shared.hideProgressView()
            DispatchQueue.main.async {
                switch result {
                case let .success(userResult):
                    if let userResult = userResult as? User {
                        DataStore.shared.user = userResult
                    }
                    WindowManager.shared.directionTabbarVC()
                case let .failure(error):
                    let message = UserService.share.getMessageError()
                    print(error)
                    WindowManager.shared.showMessage(message: message, title: nil, completion: nil)
                }
            }
        }
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        self.logIn()
    }
}
