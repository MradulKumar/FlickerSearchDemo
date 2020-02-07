//
//  DownloadRequest.swift
//  FlickerImageSearchDemo
//
//  Created by Mradul Kumar  on 30/01/20.
//  Copyright © 2020 Mradul Kumar . All rights reserved.
//

import Foundation
import UIKit


enum Result <T> {
    case Success(T)
    case Failure(String)
    case Error(String)
}

enum DownloadRequestMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    
    var value: String {
        return self.rawValue
    }
}

class DownloadRequest: NSMutableURLRequest {
    
    convenience init?(dRequestMethod: DownloadRequestMethod, urlString: String, bodyParams: [String: Any]? = nil) {
        
        guard let url =  URL.init(string: urlString) else {
            return nil
        }
        
        self.init(url: url)
        
        do {
            if let bodyParams = bodyParams {
                let data = try JSONSerialization.data(withJSONObject: bodyParams, options: .prettyPrinted)
                self.httpBody = data
            }
        } catch {
            
        }
        
        self.httpMethod = dRequestMethod.value
        
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}
