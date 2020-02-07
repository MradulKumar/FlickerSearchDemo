//
//  ImageCollectionViewCell.swift
//  FlickerImageSearchDemo
//
//  Created by Mradul Kumar  on 30/01/20.
//  Copyright © 2020 Mradul Kumar . All rights reserved.
//

import Foundation
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    static let nibName = "ImageCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        imageView.image = nil
    }
    
    var model: ImageModel? {
        didSet {
            if let model = model {
                imageView.image = UIImage(named: "Placeholder")
                imageView.downloadImage(model.imageURL)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func getImage() -> UIImage? {
        return self.imageView.image
    }
}
