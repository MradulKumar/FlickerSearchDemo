//
//  FlickerSearchResults.swift
//  FlickerImageSearchDemo
//
//  Created by Mradul Kumar  on 30/01/20.
//  Copyright © 2020 Mradul Kumar . All rights reserved.
//

import Foundation
struct FlickrSearchResults: Codable {
    let stat: String?
    let photos: Photos?
    
    enum CodingKeys: String, CodingKey {
        case stat
        case photos
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        stat = try container.decodeIfPresent(String.self, forKey: .stat)
        photos = try container.decodeIfPresent(Photos.self, forKey: .photos)
    }
}
