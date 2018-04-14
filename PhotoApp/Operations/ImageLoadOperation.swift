//
//  ImageLoadOperation.swift
//  PhotoApp
//
//  Created by Vladislav Sedinkin on 15.04.18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

typealias LoadImageCompletion = (UIImage?) -> Void
class ImageLoadOperation: AsyncOperation {
    
    private let imageURL: URL
    private let completionImage: LoadImageCompletion
    private lazy var loadService: LoadPhotoService = LoadPhotoService()
    
    public init(imageURL: URL, completionImage: @escaping LoadImageCompletion) {
        self.imageURL = imageURL
        self.completionImage = completionImage
        
        super.init()
    }
    
    override func main() {
        guard !isCancelled else { return }
        
        loadService.loadImage(with: imageURL) { [weak self] (data) in
            guard let strognSelf = self else { return }
            guard !strognSelf.isCancelled else { return }
            guard let imageData = UIImage(data: data) else { return }
            if strognSelf.isCancelled { return }
            
            OperationQueue.main.addOperation {
                strognSelf.completionImage(imageData)
            }
            strognSelf.state = .finished
        }
    }
    
}
