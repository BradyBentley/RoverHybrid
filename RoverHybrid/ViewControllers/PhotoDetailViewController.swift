//
//  PhotoDetailViewController.swift
//  RoverHybrid
//
//  Created by Brady Bentley on 12/20/18.
//  Copyright © 2018 Brady. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var cameraNameLabel: UILabel!
    @IBOutlet weak var solLabel: UILabel!
    @IBOutlet weak var earthDateLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func updateViews(){
        guard let photo = photo else { return }
        cameraNameLabel.text = photo.camerasName
        solLabel.text = "\(photo.sol)"
        earthDateLabel.text = photo.earthDate
        
        let cache = BBPhotoCache.shared
        if let imageData = cache?.imageData(forIdentifier: photo.identifier) {
            let image = UIImage(data: imageData)
            cameraImageView.image = image
        } else {
            BBMarsRoverClient.fetchImageData(forPhoto: photo) { (data, _) in
                if data == nil {
                    print("Error fetching data for images")
                }
                guard let data = data else { return }
                if let image = UIImage(data: data), self.photo == photo {
                    DispatchQueue.main.async {
                        self.cameraImageView.image = image
                    }
                }
            }
        }
    }

    var photo: BBRoverPhotos?{
        didSet{
            updateViews()
        }
    }
}

