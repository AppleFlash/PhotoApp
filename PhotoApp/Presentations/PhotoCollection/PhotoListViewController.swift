//
//  PhotoListViewController.swift
//  PhotoApp
//
//  Created by Vladislav Sedinkin on 13.04.18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

class PhotoListViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var photosCollectionView: PhotosCollectionView! {
        didSet {
            photosCollectionView.presenter = self
        }
    }
    @IBOutlet private weak var initialFetchActivityIndicator: UIActivityIndicatorView!
    
    private(set) lazy var loadService: LoadPhotoService = LoadPhotoService()
    private(set) lazy var photos: [Photo] = [Photo]()
    
    private var page: Int = 0
    private let fetchDistance: Int = 3
    
    private func searchNew(term: String) {
        page = 0
        
        startActivityIndicator()
        loadService.initialSearchImages(for: term, completion: {  [weak self] photos in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.page += 1
            strongSelf.photos = photos
            strongSelf.photosCollectionView.reloadData()
            strongSelf.stopActivityIndicator()
        }) { [weak self] in
            self?.stopActivityIndicator()
        }
    }
    
    private func startActivityIndicator() {
        initialFetchActivityIndicator.startAnimating()
    }
    
    private func stopActivityIndicator() {
        initialFetchActivityIndicator.stopAnimating()
    }

}

extension PhotoListViewController: PhotosCollectionPresenter {
    
    func fetchNewPhotosIfNeeded(lineNumber: Int, lineCount: Int, completion: @escaping (Int) -> Void) {
        guard lineNumber >= lineCount - fetchDistance else {
            return
        }
        
        loadService.fetchNextFor(page: page, completion: { [weak self] newPhotos in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.photos.append(contentsOf: newPhotos)
            completion(newPhotos.count)
        })
    }
    
}

extension PhotoListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsSearchResultsButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            searchNew(term: searchText)
        }
        
        searchBar.resignFirstResponder()
        searchBar.text = nil
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsSearchResultsButton = false
    }
    
}

