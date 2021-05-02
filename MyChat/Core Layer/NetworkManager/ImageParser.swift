//
//  Parser.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.04.2021.
//

import Foundation

struct Pixabay: Codable {
    var total: Int
    var totalHits: Int
    var hits: [Hits]?
}

struct Hits: Codable {
    let webformatURL: String?
    let largeImageURL: String?
    var smallImage: String? {
        webformatURL?.replacingOccurrences(of: "_640", with: "_180")
    }
}

class ImageParser: IParser {
    
    typealias Model = Pixabay
    
    func parse(data: Data) -> Model? {
        do {
            return try JSONDecoder().decode(Pixabay.self, from: data)
        } catch {
            print(NetworkError.notModel.localizedDescription)
            return nil
        }
    }
}
