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
    private var viewState: ViewState = .none
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.sectionIndexBackgroundColor = .clear
        tableView.backgroundColor = .pageBackground
        tableView.backgroundView?.backgroundColor = .pageBackground
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableView.automaticDimension
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
        title = "cards"
        navigationController?.setNavigationBarHidden(true, animated: false)
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
    
    //Close all cards
    private func closeCards(exceptAt exclusionIndexPath: IndexPath?) {
        for indexPath in tableView.indexPathsForVisibleRows ?? [] {
            if let eIndexPath = exclusionIndexPath {
                guard indexPath != eIndexPath else {continue}
            }
            if let cell = tableView.cellForRow(at: indexPath) as? PaymentCardCell {
                cell.closeCardIfOpen()
            }
        }
    }
    
    //Animate and hint card swipe to user
    private func animateAndHint(wiith directions: [CardDirection], initialDuration: Double = 0.3, duration: Double = 0.5) {
        
        if let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? PaymentCardCell {
            var totalDuration = Double.zero
            for direction in directions {
                DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration + initialDuration) {
                    cell.demoAnimationAndHint(to: direction)
                }
                totalDuration += initialDuration
                DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration + duration) {
                    cell.closeCardIfOpen()
                }
                totalDuration += duration
            }
        }
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
        cell.configure(with: card, indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        closeCards(exceptAt: nil)
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
                animateAndHint(wiith: [.left, .right])
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

extension PaymentCardsViewController: PaymentCardCellDelegate {
    
    func actionPerformed(of type: PCardAction, indexPath: IndexPath) {
        
        switch type {
            case .view_details: presenter?.viewCardDetails(at: indexPath.row)
            case .pay_now: presenter?.payNowCard(at: indexPath.row)
            case .view_last_statement: presenter?.viewLastStatement(at: indexPath.row)
            case .unknown: break
        }
    }
    
    func cardSwipped(to direction: CardDirection, at indexPath: IndexPath) {
        
        switch direction {
            case .left, .right: closeCards(exceptAt: indexPath)
            case .center: break
        }
    }
}
