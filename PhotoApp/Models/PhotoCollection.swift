//
//  PhotoCollection.swift
//  PhotoApp
//
//  Created by Vladislav Sedinkin on 15.04.18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation

struct PhotoCollection: Decodable {
    
    enum TopLevelCodingKeys: String, CodingKey {
        case topLevelItem = "photos"
    }
    enum DataCodingKeys: String, CodingKey {
        case photos = "photo"
    }
    
    let photos: [Photo]
    
    init(from decoder: Decoder) throws {
        let topLevelContainer = try decoder.container(keyedBy: TopLevelCodingKeys.self)
        let dataContainer = try topLevelContainer.nestedContainer(keyedBy: DataCodingKeys.self, forKey: .topLevelItem)
        
        photos = try dataContainer.decode([Photo].self, forKey: .photos)
    }
    
}
