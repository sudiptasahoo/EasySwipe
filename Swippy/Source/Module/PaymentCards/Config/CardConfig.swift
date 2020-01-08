//
//  CardConfig.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 08/01/20.
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

struct CardConfig {
    
    static let `default` = CardConfig()
    
    let carSwipeBehaviour: CardSwipeBehaviour = .credLike
    let cardAutoClosingBehaviour: CardAutoClosingBehaviour = .delayed
    
    ///The percentage of the card to be opened max eitehr on left or right. This is calculated against the card width
    let openPercentage: CGFloat = 0.60
    
    ///The minimum swipe distance to be considered for the successfull transition to left/right/center. This is calculated against the card width
    let panThresholdPercentage: CGFloat = 0.10
    
    ///The percentage of the card of the opened/auto swiped while demo
    let demoSwipePercentage: CGFloat = 0.20
}
