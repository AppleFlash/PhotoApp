//
//  LoadPhotoService.swift
//  PhotoApp
//
//  Created by Vladislav Sedinkin on 14.04.18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation

typealias PhotoModelsCompletion = ([Photo]) -> Void
typealias PhotoModelsFailure = (() -> Void)

class LoadPhotoService: NSObject {
    
    private var lastTerm: String?
    private let resultsPerPage: Int = 50
    private var isFetchInProgress: Bool = false
    
    func initialSearchImages(for term: String,
                             resultPerPage: Int = 50,
                             completion: @escaping PhotoModelsCompletion,
                             failure: (() -> Void)? = nil) {
        searchImages(for: term, resultPerPage: resultPerPage, page: 0, completion: completion, failure: failure)
    }
    
    func fetchNextFor(page: Int,
                      resultPerPage: Int = 50,
                      completion: @escaping PhotoModelsCompletion,
                      failure: PhotoModelsFailure? = nil) {
        guard let lastTerm = lastTerm else {
            assertionFailure("Use 'initialSearchImages' before")
            return
        }
        
        searchImages(for: lastTerm, resultPerPage: resultPerPage, page: page, completion: completion, failure: failure)
    }
    
    private func searchImages(for term: String,
                              resultPerPage: Int,
                              page: Int = 0,
                              completion: @escaping PhotoModelsCompletion,
                              failure: PhotoModelsFailure? = nil) {
        guard !isFetchInProgress else {
            print("Photos already fetching...")
            return
        }
        guard let url = PhotosEndpoint.searchUrl(for: term, resultPerPage: resultPerPage, page: page) else {
            failure?()
            return
        }
        
        isFetchInProgress = true
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let responseData = data else {
                print("Bad data")
                DispatchQueue.main.async {
                    failure?()
                    self?.isFetchInProgress = false
                }
                return
            }
            
            do {
                let photoCollection = try JSONDecoder().decode(PhotoCollection.self, from: responseData)
                self?.lastTerm = term
                
                DispatchQueue.main.async {
                    completion(photoCollection.photos)
                    self?.isFetchInProgress = false
                }
            } catch let error {
                DispatchQueue.main.async {
                    failure?()
                    self?.isFetchInProgress = false
                }
                print("Parsing error occured. \(error)")
            }
        }.resume()
        
    }
    
    func loadImage(with url: URL, completion: @escaping (Data) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                print("Load image failure. Error \(error!)")
                return
            }
            guard let imageData = data else {
                return
            }
            
            completion(imageData)
        }.resume()
    }
    
}

