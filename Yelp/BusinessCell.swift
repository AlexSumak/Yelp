//
//  BusinessCell.swift
//  Yelp
//
//  Created by  Alex Sumak on 2/14/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    //cell imageViews
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    
    //cell labels
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    var business: Business!{
        didSet{
            //set business name
            nameLabel.text = business.name
            
            //set image of a restaraunt
            thumbImageView.setImageWith(business.imageURL!)
        
            //set the rest of the stuff
            categoriesLabel.text = business.categories
            addressLabel.text = business.address
            reviewsCountLabel.text = "\(business.reviewCount!)Reviews"
            ratingImageView.setImageWith(business.ratingImageURL!)
            distanceLabel.text = business.distance
            
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //make rounded image thumbImageView
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
        
        // setting width for namelabel
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
