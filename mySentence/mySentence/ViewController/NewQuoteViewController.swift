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
    
    private let textViewPlaceHolder = "문장을 기록하세요"
    private lazy var textView = {
        let textView = UITextView()
        textView.backgroundColor = .systemBackground
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.text = textViewPlaceHolder
        textView.textColor = .secondaryLabel
        textView.font = UIFont(name: "YESMyoungjo-Regular", size: 16)
        textView.delegate = self
        
        //done 버튼 만들기
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([flexible, doneButton], animated: false)
        textView.inputAccessoryView = toolbar
        
        return textView
    }()
    
    @objc func doneButtonTapped() {
        textView.resignFirstResponder()
    }
    
    private lazy var saveButton = {
        var configuration = UIButton.Configuration.filled()
        
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont(name: "YESMyoungjo-Regular", size: 16)
        
        configuration.attributedTitle = AttributedString("기록하기", attributes: titleContainer)
        configuration.baseBackgroundColor = UIColor(red: 1.0, green: 0.75, blue: 0.8, alpha: 1.0)
        
        let button = UIButton(configuration: configuration)
        
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
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(20)
            make.height.equalTo(200)
        }
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Selectors
    
    @objc private func saveButtonPressed() {
        let collection = Firestore.firestore().collection("quotes")
        
        if let text = textView.text {
            let quote = Quote(quote: text, tag: ["me", "love"])
            collection.addDocument(data: quote.dictionary)
            setTextViewPlaceholder()
        }

        textView.resignFirstResponder()
    }
    
    private func setTextViewPlaceholder() {
        textView.text = textViewPlaceHolder
        textView.textColor = .secondaryLabel
    }


}

extension NewQuoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            setTextViewPlaceholder()
        }
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
