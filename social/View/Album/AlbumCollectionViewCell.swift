//
//  AlbumCollectionViewCell.swift
//  social
//
//  Created by Gabriel Lucas Santos on 23/05/21.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
    func setup(photo: UIImage) {
        self.photo.image = photo
    }
}
