//
//  ImageLoadProvider.swift
//  PhotoApp
//
//  Created by Vladislav Sedinkin on 14.04.18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation

class ImageLoadProvider {
    
    private lazy var operationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.photo.load.operation"
        
        return queue
    }()
    
    private lazy var loadOperations: [IndexPath: Operation] = [IndexPath: Operation]()
    
    func downloadImage(at url: URL, for indexPath: IndexPath, completion: @escaping LoadImageCompletion) {
        let dataLoad = ImageLoadOperation(imageURL: url, completionImage: completion)
        loadOperations[indexPath] = dataLoad
        
        operationQueue.addOperation(dataLoad)
    }
    
    func cancelDownload(at indexPath: IndexPath) {
        loadOperations[indexPath]?.cancel()
    }

    
}
