//
//  RootViewController.swift
//  mySentence
//
//  Created by 이지현 on 2023/11/18.
//

import UIKit

class RootViewController: UIViewController {
    
    private lazy var userManager = UserManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
        
        userManager.delegate = self
        userManager.fetchUser()
    }
    

}

extension RootViewController: UserManagerDelegate {
    func didLogoutUser() {
        navigationController?.popToRootViewController(animated: true)
        didUpdateUser()
    }
    
    func didUpdateUser() {
        if userManager.user == nil {
            navigationController?.pushViewController(LoginViewController(userManager: userManager), animated: false)
        } else {
            navigationController?.pushViewController(HomeViewController(userManager: userManager), animated: false)
        }
    }
}
