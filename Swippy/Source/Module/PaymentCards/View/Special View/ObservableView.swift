//
//  ObservableView.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 06/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

public protocol ViewBoundsObserving: class {
    // Notifies the delegate that view's `bounds` has changed.
    // Use `view.bounds` to access current bounds
    func boundsDidChange(_ view: ObservableView, from previousBounds: CGRect);
}

/// You can observe bounds change with this view subclass via `ViewBoundsObserving` delegate.
public class ObservableView: UIView {

    public weak var boundsDelegate: ViewBoundsObserving?

    private var previousBounds: CGRect = .zero

    public override func layoutSubviews() {
        if (bounds != previousBounds) {
            print("Bounds changed from \(previousBounds) to \(bounds)")
            boundsDelegate?.boundsDidChange(self, from: previousBounds)
            previousBounds = bounds
        }

        // UIView's implementation will layout subviews for using Auto Resizing mask or Auto Layout constraints.
        super.layoutSubviews()
    }
}
