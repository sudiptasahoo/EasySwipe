//
//  UIColor+Theme.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 05/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    
    class var signature: UIColor{
        return UIColor(red: 88/255, green: 226/255, blue: 194/255, alpha: 1)
    }
    
    class var signatureLight: UIColor{
        return UIColor(red: 219/255, green: 246/255, blue: 241/255, alpha: 1)
    }
    
    class var pageBackground: UIColor{
        return UIColor(red: 18/255, green: 20/255, blue: 28/255, alpha: 1)
    }
    
    class var bottomCardBackground: UIColor{
        return UIColor(red: 25/255, green: 31/255, blue: 42/255, alpha: 1)
    }
    
    class var primaryTextColor: UIColor{
        return .white
    }
    
    class var secondaryTextColor: UIColor{
        return UIColor(red: 162/255, green: 164/255, blue: 168/255, alpha: 1)
    }
    
    class var successGreen: UIColor{
        return UIColor(red: 80/255, green: 200/255, blue: 120/255, alpha: 1)
    }
    
    class var failRed: UIColor{
        return UIColor(red: 204/255, green: 51/255, blue: 51/255, alpha: 1)
    }
}
