//
//  ProductTableViewCell.swift
//  TheMallBD2
//
//  Created by Anik S. on 8/9/16.
//  Copyright © 2016 Anik. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var manufacturer: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
