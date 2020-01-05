//
//  PaymentCardsViewController.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 03/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

final class PaymentCardsViewController: UIViewController, PaymentCardsViewInput {

    //MARK: Properties
    var presenter: PaymentCardsViewOutput?
    
    //MARK: Initialization
    override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        themeViews()
        setupConstraints()
    }
    
    //MARK: Private Methods
    
    //Configure Views and subviews
    private func setupViews() {
        
    }
    
    //Apply Theming for views here
    private func themeViews() {
        view.backgroundColor = .systemGreen
    }
    
    
    //Apply AutoLayout Constraints
    private func setupConstraints() {
        
    }
    
    //MARK: PaymentCardsViewInput
}
