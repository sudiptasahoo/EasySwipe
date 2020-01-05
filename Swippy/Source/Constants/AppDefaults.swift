//
//  AppDefaults.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 05/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

//MARK: App Defaults
public enum Defaults {
    static let defaultPageSize: Int = 30
    static let firstPage: Int = 1
    static let defaultPageNum: Int = 0
    static let defaultTotalCount: Int = 0
}

//MARK: Metrics
enum Metrics {
    static let screenWidth = UIScreen.main.bounds.width
}

//MARK:- UI Testing identifiers
public enum UITestIdentifiers {
    static let cardTable = "card_table"
}

enum Errors {
    static let somethingWentWrong = "Something went wrong"
    static let noCard = "No card present at this index"
}
