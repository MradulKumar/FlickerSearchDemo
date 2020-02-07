//
//  ImageDownloadManager.swift
//  FlickerImageSearchDemo
//
//  Created by Mradul Kumar  on 30/01/20.
//  Copyright © 2020 Mradul Kumar . All rights reserved.
//

import Foundation
import UIKit

typealias ImageClosure = (_ result: Result<UIImage>, _ url: String) -> Void

class ImageDownloadManager: NSObject {
    
    static let shared = ImageDownloadManager()
    
    private var operationQueue = OperationQueue()
    private var dictionaryBlocks = [UIImageView: (String, ImageClosure, ImageDownloadOperation)]()
    
    private override init() {
        operationQueue.maxConcurrentOperationCount = 100
    }
    
    func addOperation(url: String, imageView: UIImageView, completion: @escaping ImageClosure) {
        
        if let image = ResultsCache.shared.getImageFromCache(key: url)  {
            
            completion(.Success(image), url)
            if let tupple = self.dictionaryBlocks.removeValue(forKey: imageView){
                tupple.2.cancel()
            }
            
        } else {
            
            if !checkOperationExists(with: url,completion: completion) {
                
                if let tupple = self.dictionaryBlocks.removeValue(forKey: imageView){
                    tupple.2.cancel()
                }
                
                let newOperation = ImageDownloadOperation(url: url) { (image,downloadedImageURL) in
                    
                    if let tupple = self.dictionaryBlocks[imageView] {
                        
                        if tupple.0 == downloadedImageURL {
                            
                            if let image = image {
                                
                                ResultsCache.shared.saveImageToCache(key: downloadedImageURL, image: image)
                                tupple.1(.Success(image), downloadedImageURL)
                                
                                if let tupple = self.dictionaryBlocks.removeValue(forKey: imageView){
                                    tupple.2.cancel()
                                }
                                
                            } else {
                                tupple.1(.Failure("Not fetched"), downloadedImageURL)
                            }
                            
                            _ = self.dictionaryBlocks.removeValue(forKey: imageView)
                        }
                    }
                }
                
                dictionaryBlocks[imageView] = (url, completion, newOperation)
                operationQueue.addOperation(newOperation)
            }
        }
    }
    
    func checkOperationExists(with url: String, completion: @escaping ImageClosure) -> Bool {
        
        if let arrayOperation = operationQueue.operations as? [ImageDownloadOperation] {
            let opeartions = arrayOperation.filter{$0.url == url}
            return opeartions.count > 0 ? true : false
        }
        
        return false
    }
    
    func cancelAllDownloadOperations() {
        operationQueue.cancelAllOperations()
    }
    
    func updateOperationsPriority(forImages images:[FlickrPhoto]) {
        if let arrayOperation = operationQueue.operations as? [ImageDownloadOperation] {
            for operation in arrayOperation {
                for item in images {
                    if(operation.url == item.imageURL) {
                        operation.queuePriority = .veryHigh
                    }else{
                        operation.queuePriority = .normal
                    }
                }
                
            }
        }
    }
}
