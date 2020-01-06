//
//  PaymentCardCell.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 05/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

enum CardDirection {
    case left, right, center
}

enum CardSwipeBehaviour {
    case credLike
    case spring
}

enum CardAutoClosingBehaviour {
    case immeadiate
    case delayed
}

protocol PaymentCardCellDelegate {
    func actionPerformed(of type: PCardAction, indexPath: IndexPath)
    
    //Only relays if there is a change in the state of the card
    func cardSwipped(to direction: CardDirection, at indexPath: IndexPath)
}

class PaymentCardCell: UITableViewCell, Reusable {
    
    private lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.prepareForAutolayout()
        return lbl
    }()
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.prepareForAutolayout()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.prepareForAutolayout()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    //MARK:- Action UI Elements
    private lazy var actionStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 24
        stack.prepareForAutolayout()
        return stack
    }()
    
    private let actionView: UIStackView = {
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
        lbl.textColor = .white
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
    
    var delegate: PaymentCardCellDelegate?
    var cellSwipeState: CardDirection = .center
    var carSwipeBehaviour: CardSwipeBehaviour = .credLike
    var cardAutoClosingBehaviour: CardAutoClosingBehaviour = .delayed
    
    //MARK: - Constraints
    var actionLeftConstraint: NSLayoutConstraint!
    var actionRightConstraint: NSLayoutConstraint!
    
    //MARK: - Boundaries
    var CARD_CENTER: CGFloat = 0.0
    var CARD_LEFT_BOUNDARY: CGFloat = 0.0
    var CARD_RIGHT_BOUNDARY: CGFloat = 0.0
    var CARD_SWIPE_THRESHOLD: CGFloat = 0.0
    var CARD_CENTER_LEFT_THRESHOLD: CGFloat = 0.0
    var CARD_CENTER_RIGHT_THRESHOLD: CGFloat = 0.0
    
    //MARK:- Swipe Coordinates
    var startLocation: CGPoint!
    
    //MARK:- IndexPath Information
    var indexPath: IndexPath!
    
    // MARK: - Lifecycle methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        makeConstraintAdjustments()
        themify()
        addPanGesture()
        addTapGestures()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //Restoring cardView position back to center
        cardView.center = CGPoint(x: contentView.center.x, y: cardView.center.y)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBoundaries()
    }
    
    // MARK: - Private methods
    
    private func addPanGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        pan.delegate = self
        cardView.addGestureRecognizer(pan)
    }
    
    private func addTapGestures() {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(handleBottomTap))
        tap1.numberOfTapsRequired = 1
        tap1.delegate = self
        bottomView.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(handleCardTap))
        tap2.numberOfTapsRequired = 1
        tap2.delegate = self
        cardView.addGestureRecognizer(tap2)
    }
    
    private func addViews(){
        cardView.addSubview(titleLbl)
        bottomView.addSubview(actionStack)
        contentView.addSubview(bottomView)
        contentView.addSubview(cardView)
    }
    
    private func makeConstraintAdjustments() {
        
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
        
        actionLeftConstraint = actionStack.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 36)
        actionRightConstraint = actionStack.leadingAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 8)
        
        NSLayoutConstraint.activate([
            actionStack.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: Metrics.cardHeight),
            cardView.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLbl.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 30),
            titleLbl.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLbl.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            titleLbl.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -30)
        ])
    }
    
    private func themify() {
        selectionStyle = .none
        backgroundColor = .signature
    }
    
    func configure(with card: PCard, indexPath: IndexPath) {
        
        self.indexPath = indexPath
        var message = card.title + "\n" + card.number + "\n" + card.cardHolderName
        if let due = card.due {
            message += "\n\n" + "Due: \(due.currency) \(due.amount)"
        }
        titleLbl.text = message
        
        let bottomViewHeight = card.due != nil ? Metrics.cardHeight + 60 : Metrics.cardHeight
        NSLayoutConstraint.activate([
            bottomView.heightAnchor.constraint(greaterThanOrEqualToConstant: bottomViewHeight)
        ])
        
        removeAllActions()
        addActions(from: card)
    }
    
    
    //MARK: Actions
    
    private func removeAllActions() {
        for view in actionStack.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
    
    private func addActions(from card: PCard) {
        
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
            lbl.font = UIFont.boldSystemFont(ofSize: 10)
            lbl.textColor = .white
            lbl.numberOfLines = 1
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalToConstant: 24),
                imageView.widthAnchor.constraint(equalToConstant: 24)
            ])

            switch action {
                case .view_details:
                    lbl.text = Strings.viewDetails
                    imageView.image = UIImage(named: "view-details")
                case .pay_now:
                    lbl.text = Strings.payNow
                    imageView.image = UIImage(named: "view-details")
                case .view_last_statement:
                    lbl.text = Strings.viewLastStatement
                    imageView.image = UIImage(named: "view-details")
                default: break
            }
            lbl.sizeToFit()
            actionHStack.addArrangedSubview(imageView)
            actionHStack.addArrangedSubview(lbl)
            actionHStack.accessibilityLabel = action.rawValue
            actionStack.addArrangedSubview(actionHStack)
        }
    }
    
    @objc func tapAction(sender: UITapGestureRecognizer) {
        
        if let aLabel = sender.view?.accessibilityLabel, let action = PCardAction(rawValue: aLabel) {
            delegate?.actionPerformed(of: action, indexPath: indexPath)
            closeCardIfOpen()
        }
    }
    
    //MARK:- Gesture
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: cardView)
        
        switch recognizer.state {
            case .began:
                startLocation = cardView.center
            
            case .changed:
                updateCardCenterX(to: cardView.center.x + translation.x)
                recognizer.setTranslation(CGPoint.zero, in: cardView)
            
            case .ended:
                recognizer.setTranslation(CGPoint.zero, in: cardView)
                
                let stopLocation = cardView.center
                let swipedDistance = abs(stopLocation.x - startLocation.x)
                print("swipedDistance: \(swipedDistance)")
                
                switch recognizer.horizontalDirection(target: cardView) {
                    
                    case .left:
                        
                        //Detect threshold and animate
                        if cardView.center.x < CARD_CENTER {
                            
                            if swipedDistance > CARD_SWIPE_THRESHOLD {
                                animateCard(to: .left)
                            } else {
                                animateCard(to: .center)
                            }
                        }
                        
                        if cardView.center.x > CARD_CENTER {
                            if swipedDistance > CARD_SWIPE_THRESHOLD {
                                animateCard(to: .center)
                            } else {
                                animateCard(to: .right)
                            }
                    }
                    
                    case .right:
                        
                        //Detect threshold and animate
                        if cardView.center.x > CARD_CENTER {
                            
                            if swipedDistance > CARD_SWIPE_THRESHOLD {
                                animateCard(to: .right)
                            } else {
                                animateCard(to: .center)
                            }
                        }
                        
                        if cardView.center.x < CARD_CENTER {
                            if swipedDistance > CARD_SWIPE_THRESHOLD {
                                animateCard(to: .center)
                            } else {
                                animateCard(to: .left)
                            }
                    }
                    
                    default: break
            }
            if case .delayed = cardAutoClosingBehaviour {
                updateSwipeState(fromCenterX: cardView.center.x)
            }
            default: break
        }
    }
    
    @objc func handleBottomTap(recognizer: UIPanGestureRecognizer) {
        
        if closeCardIfOpen() {
            delegate?.actionPerformed(of: .view_details, indexPath: indexPath)
        }
    }
    
    @objc func handleCardTap(recognizer: UIPanGestureRecognizer) {
        
        if closeCardIfOpen() {
            delegate?.actionPerformed(of: .view_details, indexPath: indexPath)
        }
    }
    
    ///Closes and returns if it was closed
    @discardableResult
    func closeCardIfOpen() -> Bool {
        if cellSwipeState != .center {
            animateCard(to: .center)
            return false
        }
        return true
    }
    
    private func adjustActionVisibility() {
                
        if cardView.center.x < CARD_CENTER {
            actionRightConstraint.isActive = true
            actionLeftConstraint.isActive = false
        } else if cardView.center.x > CARD_CENTER {
            actionRightConstraint.isActive = false
            actionLeftConstraint.isActive = true
        }
    }
    
    private func setupBoundaries() {
        
        assert(Card.panThresholdPercentage < Card.openPercentage, "panThresholdPercentage should be less than openPercentage")

        CARD_CENTER = contentView.center.x
        let cardDisplacement = Card.openPercentage * 0.01 * Metrics.cardWidth
        CARD_LEFT_BOUNDARY = CARD_CENTER + ((Metrics.cardWidth - cardDisplacement) - Metrics.cardWidth/2)
        CARD_RIGHT_BOUNDARY = CARD_CENTER - ((Metrics.cardWidth - cardDisplacement) - Metrics.cardWidth/2)
        CARD_SWIPE_THRESHOLD = Metrics.cardWidth * Card.panThresholdPercentage * 0.01
        CARD_CENTER_LEFT_THRESHOLD = CARD_LEFT_BOUNDARY - Metrics.cardWidth/2
        CARD_CENTER_RIGHT_THRESHOLD = CARD_RIGHT_BOUNDARY + Metrics.cardWidth/2
    }
    
    private func animateCard(to direction: CardDirection) {
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            switch direction {
                case .left: self.updateCardCenterX(to: self.CARD_CENTER_LEFT_THRESHOLD)
                case .right: self.updateCardCenterX(to: self.CARD_CENTER_RIGHT_THRESHOLD)
                case .center: self.updateCardCenterX(to: self.CARD_CENTER)
            }
        }) { (completed) in
            self.updateSwipeState(fromCenterX: self.cardView.center.x)
        }
    }
    
    func demoAnimateAndHint(to direction: CardDirection) {
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            switch direction {
                case .left: self.updateCardCenterX(to: self.CARD_CENTER - Card.demoSwipePercentage * 0.01 * Metrics.cardWidth)
                case .right: self.updateCardCenterX(to: self.CARD_CENTER + Card.demoSwipePercentage * 0.01 * Metrics.cardWidth)
                case .center: self.updateCardCenterX(to: self.CARD_CENTER)
            }
        }) { (completed) in
            self.updateSwipeState(fromCenterX: self.cardView.center.x)
        }
    }
    
    private func updateCardCenterX(to x: CGFloat) {
        
        if case .immeadiate = cardAutoClosingBehaviour {
            updateSwipeState(fromCenterX: cardView.center.x)
        }
        
        switch carSwipeBehaviour {
            case .credLike:
                if x >= CARD_CENTER_LEFT_THRESHOLD && x <= CARD_CENTER_RIGHT_THRESHOLD {
                    cardView.center = CGPoint(x: x, y: cardView.center.y)
                }
            
            case .spring:
                cardView.center = CGPoint(x: x, y: cardView.center.y)
        }
        
        //Action visibility
        adjustActionVisibility()
    }
    
    private func updateSwipeState(fromCenterX x: CGFloat) {
        let oldSwipeState = cellSwipeState
        if x == CARD_CENTER {
            cellSwipeState = .center
        } else if x > CARD_CENTER {
            cellSwipeState = .right
        } else {
            cellSwipeState = .left
        }
        
        if oldSwipeState != cellSwipeState {
            delegate?.cardSwipped(to: cellSwipeState, at: indexPath)
        }
    }
}

extension PaymentCardCell {
    
    override func gestureRecognizerShouldBegin(_ g: UIGestureRecognizer) -> Bool {
        if (g.isKind(of: UIPanGestureRecognizer.self)) {
            let t = (g as! UIPanGestureRecognizer).translation(in: cardView)
            let verticalness = abs(t.y)
            if (verticalness > 0) {
                return false
            }
        }
        return true
    }
}
