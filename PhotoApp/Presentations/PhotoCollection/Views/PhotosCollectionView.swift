//
//  PhotosCollectionView.swift
//  PhotoApp
//
//  Created by Vladislav Sedinkin on 14.04.18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

protocol PhotosCollectionPresenter: class {
    
    var photos: [Photo] {get}
    var loadService: LoadPhotoService {get}
    
    func fetchNewPhotosIfNeeded(lineNumber: Int, lineCount: Int, completion: @escaping (Int) -> Void)
    func update(_ photo: Photo)
}

class PhotosCollectionView: UICollectionView {
    
    private static let cellIdentifier: String = "PhotoCollectionViewCell"
    private let numberOfItemsPerLine: Int = 4
    
    private var flowLayout: UICollectionViewFlowLayout {
        return collectionViewLayout as! UICollectionViewFlowLayout
    }
    private var photoLines: Int {
        return numberOfItems(inSection: 0) / numberOfItemsPerLine
    }
    
    private lazy var imageLoadProviders: Set<ImageLoadProvider> = Set<ImageLoadProvider>()
    
    weak var presenter: PhotosCollectionPresenter!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        dataSource = self
        delegate = self
        
        setItemSize()
    }
    
    private func setItemSize() {
        let width = (bounds.width / CGFloat(numberOfItemsPerLine)) - flowLayout.minimumInteritemSpacing
        let height = width
        
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    private func lineNumber(at indexPath: IndexPath) -> Int {
        return indexPath.item / numberOfItemsPerLine
    }
    
    private func insertNewPhotos(count: Int) {
        let existingCount = numberOfItems(inSection: 0)
        
        var indexPaths = [IndexPath]()
        for indexToInsert in existingCount..<(existingCount + count) {
            indexPaths.append(IndexPath(item: indexToInsert, section: 0))
        }
        
        performBatchUpdates({
            insertItems(at: indexPaths)
        })
    }
    
    private func photo(at indexPath: IndexPath) -> Photo {
        return presenter.photos[indexPath.item]
    }
    
    private func smallImageURL(at indexPath: IndexPath) -> URL? {
        return photo(at: indexPath).smallImageURL
    }
    
}

extension PhotosCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionView.cellIdentifier,
                                                  for: indexPath)
    }
    
}

extension PhotosCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let photoCell = cell as? PhotoCollectionViewCell else {
            return
        }
        
        presenter.fetchNewPhotosIfNeeded(lineNumber: lineNumber(at: indexPath),
                                         lineCount: photoLines) { [weak self] newCount in
            self?.insertNewPhotos(count: newCount)
        }
        
        var photo = self.photo(at: indexPath)
        if photo.smallImage != nil {
            photoCell.photo = photo
        } else if let imageURL = photo.smallImageURL {
            let provider = ImageLoadProvider(imageURL: imageURL) {  [weak self] image in
                guard let strongSelf = self else { return }
                photo.smallImage = image
                strongSelf.presenter.update(photo)
                photoCell.photo = photo
            }
            imageLoadProviders.insert(provider)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        imageLoadProviders.filter { $0.imageURL == smallImageURL(at: indexPath) }.forEach {
            $0.cancel()
            imageLoadProviders.remove($0)
        }
    }
    
}
