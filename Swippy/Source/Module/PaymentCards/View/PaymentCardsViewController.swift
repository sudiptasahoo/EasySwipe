//
//  PaymentCardsViewController.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 03/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

final class PaymentCardsViewController: UIViewController {
    
    //MARK: Properties
    var presenter: PaymentCardsViewOutput?
    var viewState: ViewState = .none
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.sectionIndexBackgroundColor = .clear
        tableView.backgroundColor = .pageBackground
        tableView.backgroundView?.backgroundColor = .pageBackground
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.keyboardDismissMode = .onDrag
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.accessibilityIdentifier = UITestIdentifiers.cardTable
        tableView.separatorColor = .clear
        tableView.prepareForAutolayout()
        
        return tableView
    }()
    
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
        refreshUI()
        presenter?.fetchCards()
    }
    
    //MARK: Private Methods
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.register(PaymentCardCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
    }
    
    //Configure Views and subviews
    private func setupViews() {
        setupTableView()
    }
    
    //Apply Theming for views here
    private func themeViews() {
        self.title = "cards"
        view.signatureThemify()
    }
    
    //Apply AutoLayout Constraints
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension PaymentCardsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.pCardViewModel.cardCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let card = try? presenter?.pCardViewModel.getCard(at: indexPath.row) else {
            fatalError("TableView numberOfRowsInSection not configured correctly")
        }
        
        let cell = tableView.dequeueReusableCell(for: indexPath) as PaymentCardCell
        cell.configure(with: card)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //presenter?.viewCardDetails(at: indexPath.row)
    }
}

extension PaymentCardsViewController: PaymentCardsViewInput {
    
    func updateViewState(with state: ViewState) {
        viewState = state
        refreshUI()
    }
    
    fileprivate func refreshUI() {
        switch viewState {
            case .none:
                //Can be implemented to show shimmering effect when first time the screen is shown
                break
            case .content:
                tableView.isHidden = false
                tableView.reloadData()
            case .loading:
                //can be used to show loader on the screen
                break
            case .error(let message):
                //This way error handling can be improved. May be through Snackbar
                showAlert(title: Strings.error, message: message)
        }
    }
    
    func insertCards(at indexPaths: [IndexPath]) {
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
}
