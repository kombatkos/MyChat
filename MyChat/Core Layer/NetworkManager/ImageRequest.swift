//
//  Request.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.04.2021.
//

import Foundation

class ImageRequest: IRequest {
    
    private let search = "nature"
    private let count = 200
    
    private var urlString: String? {
        let param = "&q=\(search)&image_type=photo&pretty=true&per_page=\(count)"
        guard let url = Bundle.main.object(forInfoDictionaryKey: "pixaby") as? String else { return nil }
        let urlString = "\(url)\(param)"
        return urlString
    }
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: urlString ?? "") else { return nil }
        return URLRequest(url: url)
    }
    
}
