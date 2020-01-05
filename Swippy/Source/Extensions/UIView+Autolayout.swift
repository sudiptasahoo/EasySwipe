//
//  UIView+Autolayout.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 05/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    //MARK: AutoLayout
    
    
    /// Pins the view to its superview from all the sides
    /// - Parameter constant: the padding from the superview
    func pinEdgesToSuperView(constant: CGFloat = 0) {
        guard let superview = superview else {
            preconditionFailure("superview is missing for this view")
        }
        translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            safeAreaEdges(to: superview, constant: constant)
        } else {
            pinEdges(to: superview, constant: constant)
        }
    }
    
    /// Pins to the requested superview respecting the safe area
    /// - Parameter constant: padding from the superview's border
    func safeAreaEdges(to superview: UIView, constant: CGFloat) {
        if #available(iOS 11, *) {
            let layoutGuide = superview.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: constant),
                bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: constant),
                leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: constant),
                trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: constant)
            ])
        }
    }
    
    /// Pins the current view with the requested view
    /// - Parameter constant: padding, if any
    func pinEdges(to view: UIView, constant: CGFloat = 0) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// Places the view in the center of the superview
    func centerInSuperView() {
        guard let superview = superview else {
            fatalError("superview is missing for this view")
        }
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }
    
    func prepareForAutolayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
