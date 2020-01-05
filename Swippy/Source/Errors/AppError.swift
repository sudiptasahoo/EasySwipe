//
//  AppError.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 05/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation

enum AppError: Swift.Error {
    
    case cardError(CardError)
    
    //Just an example implementation. The real implementation will have network failure reason, status code, etc
    case networkError(reason: String)
    
    case unknownError(message: String?)
}

extension AppError: LocalizedError {
    
    var localizedDescription: String? {
        switch self {
            case .cardError(let error):
                return error.errorDescription
            case .networkError(let reason):
                return reason
            case .unknownError(let message):
                return message ?? Errors.somethingWentWrong
        }
    }
    
    /// A localized message describing what error occurred.
    var errorDescription: String? {
        return localizedDescription
    }
}


enum CardError: Swift.Error {
    case noCardPresent
}

extension CardError: LocalizedError {
    
    var localizedDescription: String? {
        switch self {
            case .noCardPresent:
                return Errors.noCard
        }
    }
    
    /// A localized message describing what error occurred.
    var errorDescription: String? {
        return localizedDescription
    }
}
