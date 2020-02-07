//
//  FlickerSearchService.swift
//  FlickerImageSearchDemo
//
//  Created by Mradul Kumar  on 30/01/20.
//  Copyright © 2020 Mradul Kumar . All rights reserved.
//

import Foundation
import UIKit

enum FlickrRequestConfig {
    case searchRequest(String, Int)
    var value: DownloadRequest? {
        switch self {
        case .searchRequest(let searchText, let pageNo):
            let urlString = String(format: FlickerImageDownloadDemoConstants.searchURL, searchText, pageNo)
            let reqConfig = DownloadRequest.init(dRequestMethod: .get, urlString: urlString)
            return reqConfig
        }
    }
}


class FlickrSearchService: NSObject {
    
    /// Flickr API Call using the "flickr.photos.search" method, to retrieve photos based on search text from a given page
    ///
    /// - Parameters:
    ///   - text: search term
    ///   - page: which page
    ///   - completion: completion handler to retrieve result
    func request(_ searchText: String, pageNo: Int, completion: @escaping (Result<Photos?>) -> Void) {
        
        guard let request = FlickrRequestConfig.searchRequest(searchText, pageNo).value else {
            return
        }
        
        NetworkManager.shared.request(request) { (result) in
            switch result {
            case .Success(let responseData):
                if let model = self.processResponse(responseData) {
                    if let stat = model.stat, stat.uppercased().contains("OK") {
                        return completion(.Success(model.photos))
                    } else {
                        return completion(.Failure(NetworkManager.errorMessage))
                    }
                } else {
                    return completion(.Failure(NetworkManager.errorMessage))
                }
            case .Failure(let message):
                return completion(.Failure(message))
            case .Error(let error):
                return completion(.Failure(error))
            }
        }
    }
    
    func processResponse(_ data: Data) -> FlickrSearchResults? {
        do {
            let responseModel = try JSONDecoder().decode(FlickrSearchResults.self, from: data)
            return responseModel
            
        } catch {
            print("Data parsing error: \(error.localizedDescription)")
            return nil
        }
    }
}
