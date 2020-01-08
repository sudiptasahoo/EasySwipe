//
//  ActionView.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 08/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

protocol ActionViewDelegate {
    func executeAction(action: PCardAction)
}

class ActionView: UIView {
    
    private lazy var actionStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 24
        stack.prepareForAutolayout()
        return stack
    }()
    
    private let actionInnerStack: UIStackView = {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .fill
        hStack.spacing = 12.0
        hStack.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        hStack.addGestureRecognizer(tapGesture)
        return hStack
    }()
    
    private let actionLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 10)
        lbl.textColor = .secondaryTextColor
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private let actionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24)
        ])
        return imageView
    }()
    
    var delegate: ActionViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        makeConstraintAdjustments()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(actionStack)
        prepareForAutolayout()
    }
    
    private func makeConstraintAdjustments() {
        NSLayoutConstraint.activate([
            actionStack.topAnchor.constraint(equalTo: topAnchor),
            actionStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            actionStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func removeAllActions() {
        for view in actionStack.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
    
    func addActions(from card: PCard) {
        
        removeAllActions()
        guard let actions = card.actions else {return}
        for action in actions {
            
            //Ignore the unknown or newly added actions in the backend
            guard action != .unknown else {continue}
            
            let actionHStack = UIStackView()
            actionHStack.axis = .horizontal
            actionHStack.alignment = .center
            actionHStack.distribution = .fill
            actionHStack.spacing = 12.0
            actionHStack.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
            actionHStack.addGestureRecognizer(tapGesture)
            
            let lbl = UILabel()
            lbl.font = UIFont.boldSystemFont(ofSize: 12)
            lbl.textColor = .secondaryTextColor
            lbl.numberOfLines = 1
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalToConstant: 24),
                imageView.widthAnchor.constraint(equalToConstant: 24)
            ])
            
            lbl.text = action.getTitle()
            imageView.image = UIImage(named: action.getIcon())
            lbl.sizeToFit()
            actionHStack.addArrangedSubview(imageView)
            actionHStack.addArrangedSubview(lbl)
            actionHStack.accessibilityLabel = action.rawValue
            actionStack.addArrangedSubview(actionHStack)
        }
    }
    
    @objc func tapAction(sender: UITapGestureRecognizer) {
        
        if let aLabel = sender.view?.accessibilityLabel, let action = PCardAction(rawValue: aLabel) {
            delegate?.executeAction(action: action)
        }
    }
}
