//
//  denemeCollectionViewCell.swift
//  Compositional-Layout
//
//  Created by Bahittin on 4.10.2023.
//

import UIKit
import SDWebImage

class denemeCollectionViewCell: UICollectionViewCell {
 
    let imageV: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "bell")
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .black
        return image
    }()
    
    public func configureImage(with Name: String) {
        let url = URL(string: Name)
        imageV.sd_setImage(with: url)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(imageV)
        imageV.frame = bounds
    }
}
