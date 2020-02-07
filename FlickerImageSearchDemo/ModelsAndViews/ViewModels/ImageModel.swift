//
//  ImageModel.swift
//  FlickerImageSearchDemo
//
//  Created by Mradul Kumar  on 30/01/20.
//  Copyright © 2020 Mradul Kumar . All rights reserved.
//

import Foundation
import UIKit

struct ImageModel {

    let imageURL: String
    
    init(withPhoto photo: FlickrPhoto) {
        imageURL = photo.imageURL
    }
}
