//
//  PhotoListViewController.swift
//  PhotoApp
//
//  Created by Vladislav Sedinkin on 13.04.18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

class PhotoListViewController: UIViewController, KeyboardShowable {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var photosCollectionView: PhotosCollectionView! {
        didSet {
            photosCollectionView.presenter = self
        }
    }
    @IBOutlet private weak var initialFetchActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private var bottomKeyboardConstraint: NSLayoutConstraint!
    
    private lazy var noResultsView: NoResultsView = NoResultsView()
    private lazy var loadService: LoadPhotoService = LoadPhotoService()
    private(set) lazy var photos: [Photo] = [Photo]()
    
    private var page: Int = 0
    private let fetchDistance: Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeyboardObservers { [unowned self] (keyboardInfo) in
            self.bottomKeyboardConstraint.constant = keyboardInfo.position
            UIView.animate(withDuration: keyboardInfo.duration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    private func searchNew(term: String) {
        page = 0
        
        startActivityIndicator()
        loadService.initialSearchImages(for: term, completion: {  [weak self] photos in
            guard let strongSelf = self else {
                return
            }
            if photos.isEmpty {
                strongSelf.showNoResultsView()
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
    
    private func showNoResultsView() {
        view.addSubview(noResultsView)
        noResultsView.translatesAutoresizingMaskIntoConstraints = false
        noResultsView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        noResultsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        noResultsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        noResultsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func hideNoResultsView() {
        noResultsView.removeFromSuperview()
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
        guard let searchText = searchBar.text else {
            return
        }
        guard loadService.lastTerm != searchText else {
            return
        }
        
        hideNoResultsView()
        photos.removeAll()
        photosCollectionView.reloadData()
        searchNew(term: searchText)
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsSearchResultsButton = false
    }
    
}
