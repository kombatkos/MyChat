//
//  ImageService.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.04.2021.
//

import UIKit

protocol IImageService {
    func getImageURL(completion: @escaping (Result<[Hits]?, Error>) -> Void)
}

class ImageService: IImageService {
    
    private let requestSender: IRequestSender?
    
    init(requestSender: IRequestSender?) {
        self.requestSender = requestSender
    }
    
    func getImageURL(completion: @escaping (Result<[Hits]?, Error>) -> Void) {
        let config = RequestFactory.PixabayRequests.searchImages()
        requestSender?.send(config: config) { result in
            switch result {
            case .success(let pixabay):
                completion(.success(pixabay.hits))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
