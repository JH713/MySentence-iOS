//
//  QuoteCell.swift
//  mySentence
//
//  Created by 이지현 on 2023/11/24.
//

import UIKit
import SnapKit

class QuoteCell: UITableViewCell {
    static let identifier = "QuoteCell"
    
    private lazy var quoteLabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont(name: "YESMyoungjo-Regular", size: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(quoteLabel)
        quoteLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    func configure(_ text: String?) {
        quoteLabel.text = text
        quoteLabel.sizeToFit()
    }
    
}
