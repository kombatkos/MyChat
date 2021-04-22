//
//  NetworkError.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.04.2021.
//

import Foundation

enum NetworkError: Error {
    case badURL, badResponse, noResponse, notModel, badRequest
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badResponse:
            return NSLocalizedString("Error: This response status code > 200", comment: "")
        case .badURL:
            return NSLocalizedString("Error: This url non valid", comment: "")
        case .notModel:
            return NSLocalizedString("Error: Data does not match model", comment: "")
        case .badRequest:
            return NSLocalizedString("Error: Bad request", comment: "")
        case .noResponse:
            return NSLocalizedString("No response received from the server", comment: "")
        }
    }
}
