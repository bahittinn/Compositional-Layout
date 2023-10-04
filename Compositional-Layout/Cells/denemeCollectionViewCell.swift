//
//  denemeCollectionViewCell.swift
//  Compositional-Layout
//
//  Created by Bahittin on 4.10.2023.
//

import UIKit

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
        imageV.image = UIImage(named: Name)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(imageV)
        imageV.frame = bounds
    }
}
