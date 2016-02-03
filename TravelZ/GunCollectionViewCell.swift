//
//  GunCollectionViewCell.swift
//  TravelZ
//
//  Created by Justin on 1/2/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import UIKit

class GunCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gunDescription: UILabel!
    @IBOutlet weak var gunName: UILabel!
    @IBOutlet weak var gunImage: UIImageView!
    @IBOutlet weak var equiped: UIImageView!
    
        // Setup Views
        override func awakeFromNib() {
            super.awakeFromNib()
            
        }
        
    func setViewCell(image: UIImage, name: String, description: String, equiped: Bool) {
        
        gunImage.image = image
        gunName.text = name
        gunDescription.text = description
        
        if (equiped)
        {
            self.equiped.backgroundColor = UIColor.greenColor()
        }
        else
        {
            self.equiped.backgroundColor = UIColor.redColor()
        }
        
        }
        
        // Clear image so cell can be re-used
        override func prepareForReuse() {
            super.prepareForReuse()
            
            // Reset properties to "brand new" state
//            self.imageView.image = nil
//            self.selected = false
//            self.highlighted = true
        }
        
        override var highlighted: Bool {
            didSet {
                // changes state when user presses finger down/up
            }
        }
        
        override var selected: Bool {
            didSet {
                // changes state when the collection view sets this as "selected"
                // usually one or more selections per CollectionView
            }
        }
        
    }
