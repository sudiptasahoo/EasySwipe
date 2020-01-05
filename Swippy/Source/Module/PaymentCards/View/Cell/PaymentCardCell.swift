//
//  PaymentCardCell.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 05/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

class PaymentCardCell: UITableViewCell, Reusable {
    
    private lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.prepareForAutolayout()
        return lbl
    }()
    
    // MARK: - Lifecycle methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        makeConstraintAdjustments()
        themify()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func addViews(){
        contentView.addSubview(titleLbl)
    }
    
    private func makeConstraintAdjustments() {
        
        NSLayoutConstraint.activate([
            titleLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            titleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func themify() {
        selectionStyle = .none
        backgroundColor = .signature
    }
    
    func configure(with card: PCard) {
        
        titleLbl.text = card.title + "\n" + card.number + "\n" + card.cardHolderName
    }
}
