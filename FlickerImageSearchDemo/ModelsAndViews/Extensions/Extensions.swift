//
//  Extensions.swift
//  FlickerImageSearchDemo
//
//  Created by Mradul Kumar  on 30/01/20.
//  Copyright © 2020 Mradul Kumar . All rights reserved.
//

import Foundation
import UIKit


extension UIImageView {
    
    func downloadImage(_ url: String) {
        ImageDownloadManager.shared.addOperation(url: url,imageView: self) {
            [weak self](result,downloadedImageURL)  in
            DispatchQueue.main.async {
                switch result {
                case .Success(let image):
                    self?.image = image
                case .Failure(_):
                    break
                case .Error(_):
                    break
                }
            }
        }
    }
    
}
