//
//  NewQuoteViewController.swift
//  mySentence
//
//  Created by 이지현 on 2023/11/18.
//

import UIKit
import Firebase
import FirebaseFirestore

class NewQuoteViewController: UIViewController {

    // MARK: - Properties
    
    private var userManager: UserManager
    
    private lazy var saveButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = UIColor(red: 1.0, green: 0.75, blue: 0.8, alpha: 1.0)
        button.configuration?.title = "저장"
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return button
    }()

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
        view.backgroundColor = .systemBackground
        
        setupLayout()
    }
    
    // MARK: - Helper Functions
    
    private func setupLayout() {
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Selectors
    
    @objc private func saveButtonPressed() {
        let collection = Firestore.firestore().collection("quotes")
        
        let quote = Quote(quote: "jihyeole", tag: ["me", "love"])
        
        collection.addDocument(data: quote.dictionary)
    }


}

protocol DocumentSerializable {
    init?(dictionary: [String: Any])
}

struct Quote {
    var quote: String
    var tag: [String]
    
    var dictionary: [String: Any] {
        return [
            "quote": quote,
            "tag": tag
        ]
    }

}

extension Quote: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let quote = dictionary["quote"] as? String,
              let tag = dictionary["tag"] as? [String] else { return nil }
        
        self.init(quote: quote, tag: tag)
    }
}
