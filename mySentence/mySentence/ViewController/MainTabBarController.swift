//
//  MainTabBarController.swift
//  mySentence
//
//  Created by 이지현 on 2023/11/18.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private var userManager: UserManager
    
    // MARK: - Lifecycle
    
    init(userManager: UserManager) {
        self.userManager = userManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        setupTabBar()
    }
    
    // MARK: - Helper Functions
    
    private func setupTabBar() {
        viewControllers = [
            setupVC(viewController: QuotesViewController(userManager: userManager), title: "문장", image: UIImage(systemName: "quote.closing")),
            setupVC(viewController: NewQuoteViewController(userManager: userManager), title: "기록하기", image: UIImage(systemName: "pencil.line")),
            setupVC(viewController: SettingViewController(userManager: userManager), title: "설정", image: UIImage(systemName: "gearshape.fill"))
        ]
    }
    
    private func setupVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }

}
