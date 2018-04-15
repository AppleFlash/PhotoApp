//
//  PhotosEndpoint.swift
//  PhotoApp
//
//  Created by Vladislav Sedinkin on 15.04.18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation

struct PhotosEndpoint {
    
    static let apiKey = "4a8dbeea5d279a33fc8ecc91d8f9ea72"
    static let url = "https://api.flickr.com/services/rest/?method=flickr.photos.search"
    static let format = "json"
    
    static func searchUrl(for term: String, resultPerPage: Int, page: Int = 0) -> URL? {
        let escapedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let stringURL = "\(url)&api_key=\(apiKey)&text=\(escapedTerm)&format=\(format)&per_page=\(resultPerPage)&page=\(page)&nojsoncallback=?"
        
        guard let url = URL(string: stringURL) else {
            print("Cannot get url from \(stringURL)")
            return nil
        }
        
        return url
    }
    
}
