//
//  Request.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.04.2021.
//

import Foundation

class ImageRequest: IRequest {
    
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    private let search = "nature"
    private let count = 200
    
    private var urlString: String {
        let param = "?key=\(apiKey)&q=\(search)&image_type=photo&pretty=true&per_page=\(count)"
        let urlString = "https://pixabay.com/api/\(param)"
        return urlString
    }
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }
    
}
