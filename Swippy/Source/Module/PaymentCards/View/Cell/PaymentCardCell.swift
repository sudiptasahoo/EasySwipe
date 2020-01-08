//
//  PaymentCardCell.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 05/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

protocol PaymentCardCellDelegate {
    
    ///Action tapped from the Back View
    func actionPerformed(of type: PCardAction, indexPath: IndexPath)
    
    ///Only relays if there is a change in the state of the card
    func cardSwipped(to direction: CardDirection, at indexPath: IndexPath)
}

class PaymentCardCell: UITableViewCell, Reusable {
    
    
    //MARK:- Front Card View
    private lazy var cardView: CardView = {
        let view = CardView()
        view.backgroundColor = .bottomCardBackground
        view.delegate = self
        return view
    }()
    
    //MARK:- View Behind the Card
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .bottomCardBackground
        view.prepareForAutolayout()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var backViewStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 0
        stack.prepareForAutolayout()
        return stack
    }()
    
    //MARK:- Bottom Hanging Due View
    private lazy var dueView: DueView = {
        let view = DueView()
        view.backgroundColor = .bottomCardBackground
        return view
    }()
    
    //MARK:- Action UI Elements
    private lazy var actionView: ActionView = {
        let view = ActionView()
        view.delegate = self
        view.backgroundColor = .bottomCardBackground
        return view
    }()
    
    var delegate: PaymentCardCellDelegate?
    var config: CardConfig!
    
    //MARK: - Constraints
    var actionLeftConstraint: NSLayoutConstraint!
    var actionRightConstraint: NSLayoutConstraint!
    var dueViewHeightConstraint: NSLayoutConstraint!
    
    //MARK:- IndexPath Information
    var indexPath: IndexPath!
    
    // MARK: - Lifecycle methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        makeConstraintAdjustments()
        themify()
        addTapGestures()
        addPanGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //Restoring cardView position back to center
        cardView.animateCard(to: .center, animated: false)
    }
    
    // MARK: - Private methods
    
    private func themify() {
        selectionStyle = .none
        signatureThemify()
    }
    
    private func addPanGesture() {
        let pan = UIPanGestureRecognizer(target: cardView, action: #selector(cardView.handlePan(recognizer:)))
        pan.delegate = self
        cardView.addGestureRecognizer(pan)
    }
    
    private func addTapGestures() {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(handleCardTap))
        tap1.numberOfTapsRequired = 1
        tap1.delegate = self
        backView.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(handleCardTap))
        tap2.numberOfTapsRequired = 1
        tap2.delegate = self
        cardView.addGestureRecognizer(tap2)
    }
    
    private func addViews() {
        
        backView.addSubview(actionView)
        backViewStack.addArrangedSubview(backView)
        backViewStack.addArrangedSubview(dueView)
        contentView.addSubview(backViewStack)
        contentView.addSubview(cardView)
    }
    
    private func makeConstraintAdjustments() {
        
        NSLayoutConstraint.activate([
            backViewStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            backViewStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            backViewStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            backViewStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            backView.heightAnchor.constraint(equalToConstant: CardUI.cardHeight)
        ])
        
        dueViewHeightConstraint = dueView.heightAnchor.constraint(equalToConstant: CardUI.dueViewHeight)
        dueViewHeightConstraint.priority = UILayoutPriority(rawValue: 999)
        dueViewHeightConstraint.isActive = true
        actionLeftConstraint = actionView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 36)
        actionRightConstraint = actionView.leadingAnchor.constraint(equalTo: backView.centerXAnchor, constant: 8)
        
        NSLayoutConstraint.activate([
            actionView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: backView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: backView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: CardUI.cardHeight)
        ])
    }
    
    @objc func handleCardTap(recognizer: UIPanGestureRecognizer) {
        
        if closeCardIfOpen() {
            delegate?.actionPerformed(of: .view_details, indexPath: indexPath)
        }
    }
    
    private func adjustActionPosition(with direction: CardDirection) {
        
        switch direction {
            case .left:
                actionLeftConstraint.isActive = false
                actionRightConstraint.isActive = true
            case .right:
                actionRightConstraint.isActive = false
                actionLeftConstraint.isActive = true
            default: break
        }
    }

    //MARK:- Public Methods
    func demoAnimationAndHint(to direction: CardDirection) {
        cardView.animateCard(to: direction, demo: true)
    }
    
    ///Closes and returns if it was closed
    @discardableResult
    func closeCardIfOpen() -> Bool {
        if cardView.cellSwipeState != .center {
            cardView.animateCard(to: .center)
            return false
        }
        return true
    }
    
    func configure(with card: PCard, indexPath: IndexPath, config: CardConfig = .default) {
        
        self.indexPath = indexPath
        self.config = config
        cardView.configure(with: card, config: config)
        if let due = card.due {
            dueView.configure(with: due)
            dueViewHeightConstraint.constant = CardUI.dueViewHeight
            backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            dueView.hide(hide: true)
            dueViewHeightConstraint.constant = CGFloat.zero
            backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        actionView.addActions(from: card)
    }
}

extension PaymentCardCell: ActionViewDelegate {
    
    func executeAction(action: PCardAction) {
        delegate?.actionPerformed(of: action, indexPath: indexPath)
        closeCardIfOpen()
    }
}

extension PaymentCardCell: CardViewDelegate {
    
    func cardSwipped(to direction: CardDirection){
        delegate?.cardSwipped(to: cardView.cellSwipeState, at: indexPath)
    }
    
    func cardSwipeStart(towards direction: CardDirection) {
        //Action position
        adjustActionPosition(with: direction)
    }
}

extension PaymentCardCell {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer.isKind(of: UIPanGestureRecognizer.self)) {
            let t = (gestureRecognizer as! UIPanGestureRecognizer).translation(in: self)
            let verticalness = abs(t.y)
            if (verticalness > 0) {
                //Ignore the Vertical gestures and pass them to the tableview below
                return false
            }
        }
        //Capture all other gestures in this cell. eg. Tap, Horizontal Pan
        return true
    }
}
