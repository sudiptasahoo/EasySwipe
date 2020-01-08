//
//  swift
//  Swippy
//
//  Created by Sudipta Sahoo on 08/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

protocol CardViewDelegate {
    func cardSwipped(to direction: CardDirection)
    func cardSwipeStart(towards direction: CardDirection)
}

class CardView: UIView {
    
    private lazy var cardTitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textColor = .primaryTextColor
        lbl.numberOfLines = 2
        lbl.prepareForAutolayout()
        lbl.addSignatureShadow()
        return lbl
    }()
    
    private lazy var cardNoLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textColor = .primaryTextColor
        lbl.numberOfLines = 1
        lbl.prepareForAutolayout()
        lbl.addSignatureShadow()
        return lbl
    }()
    
    private lazy var cardHolderNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textColor = .primaryTextColor
        lbl.numberOfLines = 1
        lbl.prepareForAutolayout()
        lbl.addSignatureShadow()
        return lbl
    }()
    
    private let bankImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.prepareForAutolayout()
        return imageView
    }()
    
    private let networkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.prepareForAutolayout()
        return imageView
    }()
    
    private let cardBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.prepareForAutolayout()
        return imageView
    }()
    
    //MARK:- Swipe Coordinates
    var startLocation: CGPoint!
    var cellSwipeState: CardDirection = .center
    var delegate: CardViewDelegate?
    var config: CardConfig!
    
    //MARK: - Boundaries
    var CARD_CENTER: CGFloat = 0.0
    var CARD_SWIPE_THRESHOLD: CGFloat = 0.0
    var CARD_CENTER_LEFT_THRESHOLD: CGFloat = 0.0
    var CARD_CENTER_RIGHT_THRESHOLD: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addCustomView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBoundaries()
    }
    
    private func setupView() {
        prepareForAutolayout()
        layer.cornerRadius = 12
        clipsToBounds = true
    }
    
    private func addCustomView() {
        
        addSubview(cardBackgroundImageView)
        addSubview(cardTitleLbl)
        addSubview(cardNoLbl)
        addSubview(cardHolderNameLbl)
        addSubview(bankImageView)
        addSubview(networkImageView)
        
        NSLayoutConstraint.activate([
            cardBackgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            cardBackgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardBackgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardBackgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            
            cardTitleLbl.topAnchor.constraint(equalTo: topAnchor, constant: CardUI.inset.top),
            cardTitleLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CardUI.inset.left),
            cardTitleLbl.trailingAnchor.constraint(equalTo: bankImageView.leadingAnchor, constant: -8),
            
            cardHolderNameLbl.topAnchor.constraint(equalTo: cardNoLbl.bottomAnchor, constant: 8),
            cardHolderNameLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CardUI.inset.left),
            cardHolderNameLbl.trailingAnchor.constraint(equalTo: networkImageView.leadingAnchor, constant: -8),
            cardHolderNameLbl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: CardUI.inset.bottom),
            
            cardNoLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CardUI.inset.left),
            cardNoLbl.trailingAnchor.constraint(equalTo: cardHolderNameLbl.trailingAnchor),
            
            bankImageView.topAnchor.constraint(equalTo: topAnchor, constant: CardUI.inset.top),
            bankImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CardUI.inset.right),
            bankImageView.heightAnchor.constraint(equalToConstant: CardUI.cardWidth * 0.15),
            bankImageView.widthAnchor.constraint(equalToConstant: CardUI.cardWidth * 0.3),
            
            networkImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: CardUI.inset.bottom),
            networkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CardUI.inset.right),
            networkImageView.heightAnchor.constraint(equalToConstant: CardUI.cardWidth * 0.1),
            networkImageView.widthAnchor.constraint(equalToConstant: CardUI.cardWidth * 0.2)
        ])
        
    }
    
    private func setupBoundaries() {
        
        assert(config.panThresholdPercentage < config.openPercentage, "panThresholdPercentage should be less than openPercentage")
        
        CARD_CENTER = center.x
        let cardDisplacement = config.openPercentage * CardUI.cardWidth
        let CARD_LEFT_BOUNDARY = CARD_CENTER + ((CardUI.cardWidth - cardDisplacement) - CardUI.cardWidth/2)
        let CARD_RIGHT_BOUNDARY = CARD_CENTER - ((CardUI.cardWidth - cardDisplacement) - CardUI.cardWidth/2)
        CARD_SWIPE_THRESHOLD = CardUI.cardWidth * config.panThresholdPercentage
        CARD_CENTER_LEFT_THRESHOLD = CARD_LEFT_BOUNDARY - CardUI.cardWidth/2
        CARD_CENTER_RIGHT_THRESHOLD = CARD_RIGHT_BOUNDARY + CardUI.cardWidth/2
    }
        
    //MARK:- Gesture Handling
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self)
        
        switch recognizer.state {
            case .began:
                startLocation = center
            
            case .changed:
                updateCardCenterX(to: center.x + translation.x)
                recognizer.setTranslation(CGPoint.zero, in: self)
            
            case .ended:
                recognizer.setTranslation(CGPoint.zero, in: self)
                
                let stopLocation = center
                let swipeDisplacement = stopLocation.x - startLocation.x
                let swipedDistance = abs(swipeDisplacement)
                
                //Ignoring no displacement condition
                guard swipeDisplacement != 0 else { return }
                
                switch swipeDisplacement > 0 ? CardDirection.right : CardDirection.left {
                    
                    case .left:
                        //Detect threshold and animate
                        if center.x < CARD_CENTER {
                            if swipedDistance > CARD_SWIPE_THRESHOLD {
                                animateCard(to: .left)
                            } else {
                                animateCard(to: .center)
                            }
                        }
                        
                        if center.x > CARD_CENTER {
                            if swipedDistance > CARD_SWIPE_THRESHOLD {
                                animateCard(to: .center)
                            } else {
                                animateCard(to: .right)
                            }
                    }
                    
                    case .right:
                        //Detect threshold and animate
                        if center.x > CARD_CENTER {
                            
                            if swipedDistance > CARD_SWIPE_THRESHOLD {
                                animateCard(to: .right)
                            } else {
                                animateCard(to: .center)
                            }
                        }
                        if center.x < CARD_CENTER {
                            if swipedDistance > CARD_SWIPE_THRESHOLD {
                                animateCard(to: .center)
                            } else {
                                animateCard(to: .left)
                            }
                    }
                    
                    default: break
                }
                
                if case .delayed = config.cardAutoClosingBehaviour {
                    updateSwipeState(to: getDirection(fromCenterX: center.x))
            }
            default: break
        }
    }
    
    private func updateCardCenterX(to x: CGFloat) {
        
        if case .immeadiate = config.cardAutoClosingBehaviour {
            updateSwipeState(to: getDirection(fromCenterX: center.x))
        }
        
        switch config.carSwipeBehaviour {
            case .credLike:
                if x >= CARD_CENTER_LEFT_THRESHOLD && x <= CARD_CENTER_RIGHT_THRESHOLD {
                    center = CGPoint(x: x, y: center.y)
            }
            
            case .spring:
                center = CGPoint(x: x, y: center.y)
        }
        
        delegate?.cardSwipeStart(towards: getDirection(fromCenterX: center.x))
    }
    
    private func getDirection(fromCenterX x: CGFloat) -> CardDirection {
        
        if x < CARD_CENTER {
            return .left
        } else if x > CARD_CENTER {
            return .right
        } else {
            return .center
        }
    }
    
    private func updateSwipeState(to state: CardDirection) {
        if cellSwipeState != state {
            cellSwipeState = state
            delegate?.cardSwipped(to: cellSwipeState)
        }
    }
    
    //MARK:- Public Methods
    func animateCard(to direction: CardDirection, animated: Bool = true, demo: Bool = false) {
        
        UIView.animate(withDuration: animated ? 0.2 : 0.0, delay: 0.0, options: .curveEaseInOut, animations: {
            switch direction {
                case .left:
                    let x = demo ? self.CARD_CENTER - self.config.demoSwipePercentage * CardUI.cardWidth : self.CARD_CENTER_LEFT_THRESHOLD
                    self.updateCardCenterX(to: x)
                case .right:
                    let x = demo ? self.CARD_CENTER + self.config.demoSwipePercentage * CardUI.cardWidth : self.CARD_CENTER_RIGHT_THRESHOLD
                    self.updateCardCenterX(to: x)
                case .center:
                    self.updateCardCenterX(to: self.CARD_CENTER)
            }
        }) { (completed) in
            self.updateSwipeState(to: self.getDirection(fromCenterX: self.center.x))
        }
    }
    
    func configure(with card: PCard, config: CardConfig){
        self.config = config
        cardTitleLbl.text = card.title
        cardNoLbl.text = card.number
        cardHolderNameLbl.text = card.cardHolderName
        if let logo = card.bankName.getLogoName() {
            bankImageView.image = UIImage(named: logo)
        } else {
            bankImageView.image = nil
        }
        
        if let logo = card.type.getLogoName() {
            networkImageView.image = UIImage(named: logo)
        } else {
            networkImageView.image = nil
        }
        
        if let background = card.bankName.getCardBackground() {
            cardBackgroundImageView.image = UIImage(named: background)
        } else {
            cardBackgroundImageView.image = nil
            cardBackgroundImageView.backgroundColor = .gray //Default background if any new card is introduced in the backend
        }
    }
}
