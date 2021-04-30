//
//  NetworkManager.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.04.2021.
//

import Foundation

class RequestSender: IRequestSender {
    
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model, Error>) -> Void) where Parser: IParser {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(.failure(NetworkError.badRequest))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            } else if let response = response as? HTTPURLResponse {
                
                guard response.statusCode == 200 else {
                    completionHandler(.failure(NetworkError.badResponse))
                    return }
                guard let data = data,
                      let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                    completionHandler(.failure(NetworkError.notModel))
                    return
                }
                completionHandler(.success(parsedModel))
            } else {
                completionHandler(.failure(NetworkError.noResponse))
            }
        }
        
        task.resume()
    }
    
}
