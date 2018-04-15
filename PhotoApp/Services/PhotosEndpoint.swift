//
//  PhotosEndpoint.swift
//  PhotoApp
//
//  Created by Vladislav Sedinkin on 15.04.18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation

struct PhotosEndpoint {
    
    private static let apiKey = "50bc4405051042ff93a2d8d89aa64c63"
    private static let secret = "f673492d00d646d0"
    private static let url = "https://api.flickr.com/services/rest/?method=flickr.photos.search"
    private static let format = "json"
    
    static func searchUrl(for term: String, resultPerPage: Int, page: Int = 0) -> URL? {
        let escapedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let stringURL = "\(url)&api_key=\(apiKey)&secret=\(secret)&text=\(escapedTerm)&format=\(format)&per_page=\(resultPerPage)&page=\(page)&nojsoncallback=?"
        
        guard let url = URL(string: stringURL) else {
            print("Cannot get url from \(stringURL)")
            return nil
        }
        
        return url
    }
    
}
