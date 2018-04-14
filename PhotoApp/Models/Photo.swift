//
//  Photo.swift
//  PhotoApp
//
//  Created by Vladislav Sedinkin on 14.04.18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

struct Photo: Decodable {

    enum CodingKeys: String, CodingKey {
        case id, farm, server, secret
    }
    
    let id: String
    let farm: Int
    let server: String
    let secret: String
    var smallImage: UIImage?
    
    var smallImageURL: URL? {
        return imageURL(size: "m")
    }
    
    var bigImageURL: URL? {
        return imageURL(size: "b")
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        farm = try container.decode(Int.self, forKey: .farm)
        server = try container.decode(String.self, forKey: .server)
        secret = try container.decode(String.self, forKey: .secret)
    }
    
    private func imageURL(size: String) -> URL? {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_\(size).jpg")
    }
    
}

extension Photo: Equatable {
    
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
    
}
