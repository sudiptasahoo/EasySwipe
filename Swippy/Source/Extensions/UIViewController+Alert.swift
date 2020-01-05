//
//  UIViewController+Alert.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 05/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// Shows popup using UIAlertController with the supplied paramaters
    func showAlert(title: String, message: String, retryAction: (() -> Void)? = nil) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if retryAction != nil {
            alertViewController.addAction(UIAlertAction(title: Strings.cancel, style: .default))
        }
        let title = (retryAction == nil) ? Strings.ok : Strings.retry
        alertViewController.addAction(UIAlertAction(title: title, style: .default) { _ in
            retryAction?()
        })
        present(alertViewController, animated: true)
    }
    
}
