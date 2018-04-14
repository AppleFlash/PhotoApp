//
//  PhotoCollectionViewCell.swift
//  PhotoApp
//
//  Created by Vladislav Sedinkin on 13.04.18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet private weak var photoImage: UIImageView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    var photo: Photo? {
        didSet {
            updateImageView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateImageView()
    }
    
    func updateImageView() {
        if let image = photo?.smallImage {
            photoImage.image = image
            photoImage.alpha = 0
            UIView.animate(withDuration: 0.2, animations: {
                self.photoImage.alpha = 1.0
                self.spinner.alpha = 0
            }, completion: { _ in
                self.spinner.stopAnimating()
            })
            
        } else {
            photoImage.image = nil
            photoImage.alpha = 0
            spinner.alpha = 1.0
            spinner.startAnimating()
        }
    }
    
}
