//
//  MenuTableViewCell.swift
//  DrinkAPP
//
//  Created by 廖晨如 on 2022/12/31.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var drinkUIImage: UIImageView!
    @IBOutlet weak var drinkUILabel: UILabel!
    @IBOutlet weak var descriptionUILabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
