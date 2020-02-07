//
//  CollectionViewReusableFooterView.swift
//  FlickerImageSearchDemo
//
//  Created by Mradul Kumar  on 31/01/20.
//  Copyright © 2020 Mradul Kumar . All rights reserved.
//

import Foundation
import UIKit

class CollectionViewReusableFooterView: UICollectionReusableView {
    
    static let reusableIdentifier:String = "CollectionViewReusableFooterViewId"
    private var indicator:UIActivityIndicatorView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.indicator = UIActivityIndicatorView.init(style: .medium)
        self.indicator?.color = UIColor.darkGray
        self.addSubview(self.indicator!)
        self.indicator?.translatesAutoresizingMaskIntoConstraints = false
        self.indicator?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.indicator?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        stopAnimating()
    }

    func stopAnimating() {
        self.indicator?.stopAnimating()
    }

    func startAnimating() {
        self.indicator?.startAnimating()
    }
    
}
