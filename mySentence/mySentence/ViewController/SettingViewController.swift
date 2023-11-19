//
//  SettingViewController.swift
//  mySentence
//
//  Created by 이지현 on 2023/11/18.
//

import UIKit
import SnapKit

class SettingViewController: UIViewController {

    let userManager: UserManager
    
    init(userManager: UserManager) {
        self.userManager = userManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var logoutButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.title = "Logout"
        button.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc private func logoutButtonPressed() {
        userManager.logoutUser()
    }

}
