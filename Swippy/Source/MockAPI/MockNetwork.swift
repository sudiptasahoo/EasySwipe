//
//  MockNetwork.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 05/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation

struct MockNetwork {
    
    func fetchPaymentCards(with page: Int, pageSize: Int) -> PCardResponse? {
        
        if let path = Bundle.main.path(forResource: "MockData", ofType: "json") {
            if let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    return try decoder.decode(PCardResponse.self, from: jsonData)
                } catch let error {
                    print(error)
                    return nil
                }
            }
        }
        
        return nil
    }
}
