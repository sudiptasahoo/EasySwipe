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
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.prepareForAutolayout()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.prepareForAutolayout()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: - Lifecycle methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        makeConstraintAdjustments()
        themify()
        addPanGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //Restoring cardView position back to center
        cardView.center = CGPoint(x: contentView.center.x, y: cardView.center.y)
    }
    
    // MARK: - Private methods
    
    private func addPanGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        pan.delegate = self
        cardView.addGestureRecognizer(pan)
    }
    
    @objc func handlePan (recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: cardView)

        if recognizer.state == .ended {
            recognizer.view?.center.x = self.cardView.center.x
            recognizer.setTranslation(CGPoint.zero, in: self.cardView)
            
        } else if recognizer.state == .changed{
            let view = recognizer.view
            view!.center = CGPoint(x:view!.center.x + translation.x, y:view!.center.y)
            recognizer.setTranslation(CGPoint.zero, in: self.cardView)
        }
    }
    
    private func addViews(){
        cardView.addSubview(titleLbl)
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
    
    func configure(with card: PCard) {
        
        var message = card.title + "\n" + card.number + "\n" + card.cardHolderName
        if let due = card.due {
            message += "\n\n" + "Due: \(due.currency) \(due.amount)"
        }
        titleLbl.text = message
        
        let bottomViewHeight = card.due != nil ? Metrics.cardHeight + 60 : Metrics.cardHeight
        NSLayoutConstraint.activate([
            bottomView.heightAnchor.constraint(greaterThanOrEqualToConstant: bottomViewHeight)
        ])
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
