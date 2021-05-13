//
//  RequestFactory.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.04.2021.
//

import Foundation

struct RequestFactory {
    
    struct PixabayRequests {
        
        static func searchImages() -> RequestConfig<ImageParser> {
            let request = ImageRequest()
            let parser = ImageParser()
            
            return RequestConfig<ImageParser>(request: request, parser: parser)
        }
        
    }
    
}
