//
//  QuotesViewController.swift
//  mySentence
//
//  Created by 이지현 on 2023/11/18.
//

import UIKit
import SnapKit
import FirebaseFirestore

class QuotesViewController: UIViewController {
    
    var data: [String] = []
    
    // MARK: - Properties
    
    private var userManager: UserManager
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private lazy var emptyView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false

        let label = UILabel()
        label.text = "기록된 문장이 없습니다"
        label.textColor = .tertiaryLabel
        label.font = UIFont(name: "YESMyoungjo-Regular", size: 18)
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return view
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
        
        query = baseQuery()
        setupLayout()
        updateEmptyView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeQuery()
    }
    
    // MARK: - Helper Functions

    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func updateEmptyView() {
        emptyView.isHidden = quotes.count != 0
    }
    
    // MARK: - Firebase
    
    var quotes: [Quote] = []
    
    let backgroundView = UIImageView()
    
    private func baseQuery() -> Query {
        return Firestore.firestore().collection("quotes").limit(to: 50)
    }
    
    private var listener: ListenerRegistration?
    private var documents: [DocumentSnapshot] = []
    
    private var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }
    
    private func observeQuery() {
        guard let query = query else { return }
        stopObserving()
        
        listener = query.addSnapshotListener({ [unowned self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            let models = snapshot.documents.map { (document) -> Quote in
                if let model = Quote(dictionary: document.data()) {
                    return model
                } else {
                    // Don't use fatalError here in a real app.
                          fatalError("Unable to initialize type \(Quote.self) with dictionary \(document.data())")
                }
            }
            self.quotes = models
            self.documents = snapshot.documents
            
            if self.documents.count > 0 {
                self.tableView.backgroundView = nil
            } else {
                self.tableView.backgroundView = self.backgroundView
            }
            
            self.tableView.reloadData()
            updateEmptyView()
        })
    }
    
    private func stopObserving() {
        listener?.remove()
    }

}

extension QuotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let quote = quotes[indexPath.row]
        cell.textLabel?.text = quote.quote
        return cell
    }
    
    
}
