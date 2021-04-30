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
            let request = ImageRequest(apiKey: "21260623-ed3906ef25d5ee2448a3ad4b3")
            let parser = ImageParser()
            
            return RequestConfig<ImageParser>(request: request, parser: parser)
        }
        
    }
    
}
