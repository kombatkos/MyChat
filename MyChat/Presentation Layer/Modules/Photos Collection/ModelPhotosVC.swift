//
//  ModelAvatarList.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 18.04.2021.
//

import UIKit

protocol IModelPhotosVC {
    var photos: [Hits]? {get set}
    func fetchURLs(completion: @escaping (Result<[Hits]?, Error>) -> Void)
    func fetchImage(urlString: String?, completion: @escaping (UIImage?) -> Void)
}
let imageCashe = NSCache<NSString, UIImage>()

class ModelPhotosVC: IModelPhotosVC {
    
    let imageService: IImageService
    
    init(imageService: IImageService) {
        self.imageService = imageService
    }
    
    var photos: [Hits]? = []
    
    func fetchURLs(completion: @escaping (Result<[Hits]?, Error>) -> Void) {
        DispatchQueue.global(qos: .default).async {
            self.imageService.getImageURL { result in
                completion(result)
            }
        }
    }
    
    func fetchImage(urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = urlString else { return }
        guard let url = URL(string: urlString) else { return }
        
        if let cacheImage = imageCashe.object(forKey: url.absoluteString as NSString) {
            completion(cacheImage)
        } else {
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else { return }
                imageCashe.setObject(image, forKey: url.absoluteString as NSString)
                
                completion(image)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
