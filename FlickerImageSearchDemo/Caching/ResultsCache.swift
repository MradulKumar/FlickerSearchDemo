//
//  ResultsCache.swift
//  FlickerImageSearchDemo
//
//  Created by Mradul Kumar  on 30/01/20.
//  Copyright © 2020 Mradul Kumar . All rights reserved.
//

import Foundation
import UIKit

class ResultsCache: NSObject {

    static let shared = ResultsCache()
    
    private(set) var cache: NSCache<AnyObject, AnyObject> = NSCache()
    
    func getImageFromCache(key: String) -> UIImage? {
        if (self.cache.object(forKey: key as AnyObject) != nil) {
            return self.cache.object(forKey: key as AnyObject) as? UIImage
        } else {
            return nil
        }
    }
    
    func saveImageToCache(key: String, image: UIImage) {
        self.cache.setObject(image, forKey: key as AnyObject)
    }
    
}
