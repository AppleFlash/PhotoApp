//
//  ImageLoadProvider.swift
//  PhotoApp
//
//  Created by Vladislav Sedinkin on 14.04.18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

class ImageLoadProvider {
    
    private var operationQueue = OperationQueue ()
    let imageURL: URL
    
    init(imageURL: URL, completion: @escaping LoadImageCompletion) {
        self.imageURL = imageURL
        
        let dataLoad = ImageLoadOperation(imageURL: imageURL, completionImage: completion)
        operationQueue.addOperation(dataLoad)
    }
    
    func cancel() {
        operationQueue.cancelAllOperations()
    }
    
}

extension ImageLoadProvider: Hashable {
    var hashValue: Int {
        return imageURL.hashValue
    }
}

extension ImageLoadProvider: Equatable {
 
    static func ==(lhs: ImageLoadProvider, rhs: ImageLoadProvider) -> Bool {
        return lhs.imageURL.absoluteString == rhs.imageURL.absoluteString
    }
    
}
