//
//  DueView.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 08/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

class DueView: UIView {
    
    private lazy var dueTitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 10)
        lbl.textColor = .secondaryTextColor
        lbl.numberOfLines = 1
        lbl.prepareForAutolayout()
        return lbl
    }()
    
    private lazy var dueValueLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textColor = .primaryTextColor
        lbl.numberOfLines = 1
        lbl.prepareForAutolayout()
        return lbl
    }()
    
    private lazy var dueStateLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 10)
        lbl.textColor = .primaryTextColor
        lbl.numberOfLines = 1
        lbl.prepareForAutolayout()
        return lbl
    }()
    
    private lazy var dueStateView: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.prepareForAutolayout()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addCustomView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        prepareForAutolayout()
        layer.cornerRadius = 12
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        clipsToBounds = true
        dueTitleLbl.text = "total due"
    }
    
    private func addCustomView() {
        
        let dStack = UIStackView(arrangedSubviews: [dueTitleLbl, dueValueLbl])
        dStack.alignment = .center
        dStack.axis = .vertical
        dStack.spacing = 4
        dStack.distribution = .equalCentering
        dStack.prepareForAutolayout()
        
        dueStateView.addSubview(dueStateLbl)
        NSLayoutConstraint.activate([
            dueStateLbl.leadingAnchor.constraint(equalTo: dueStateView.leadingAnchor, constant: 12),
            dueStateLbl.trailingAnchor.constraint(equalTo: dueStateView.trailingAnchor, constant: -12),
            dueStateLbl.topAnchor.constraint(equalTo: dueStateView.topAnchor),
            dueStateLbl.bottomAnchor.constraint(equalTo: dueStateView.bottomAnchor),
            dueStateView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        let hStack = UIStackView(arrangedSubviews: [dStack, dueStateView])
        hStack.axis = .horizontal
        hStack.distribution = .equalSpacing
        hStack.alignment = .center
        hStack.prepareForAutolayout()
        addSubview(hStack)
        
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CardUI.inset.left),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CardUI.inset.right),
            hStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with due: PCardDue){
        hide(hide: false)
        dueValueLbl.text = due.currency + " " + String(due.amount)
        dueStateLbl.text = due.state.getDueTitle()
        switch due.state {
            case .fullyPaid:
                dueStateView.layer.borderColor = UIColor.successGreen.cgColor
                dueStateLbl.textColor = .successGreen
            
            case .due( _): fallthrough
            default:
                dueStateView.layer.borderColor = UIColor.failRed.cgColor
                dueStateLbl.textColor = .failRed
        }
    }
    
    func hide(hide: Bool) {
        dueTitleLbl.isHidden = hide
        dueValueLbl.isHidden = hide
        dueStateLbl.isHidden = hide
        dueStateView.isHidden = hide
    }
}
