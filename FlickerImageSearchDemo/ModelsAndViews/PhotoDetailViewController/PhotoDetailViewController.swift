//
//  PhotoDetailViewController.swift
//  FlickerImageSearchDemo
//
//  Created by Mradul Kumar  on 31/01/20.
//  Copyright © 2020 Mradul Kumar . All rights reserved.
//

import Foundation
import UIKit

class PhotoDetailViewController: UIViewController {

    var image:UIImage?
    @IBOutlet var containerView: UIView!
    @IBOutlet var imageView: UIImageView!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = image
    }
    
    @IBAction func crossButtonPressed() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

