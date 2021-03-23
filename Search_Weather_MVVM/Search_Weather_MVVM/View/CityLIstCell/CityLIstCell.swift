//
//  CityLIstCell.swift
//  Search_Weather_MVVM
//
//  Created by Mihin  Patel on 22/03/21.
//

import UIKit

class CityLIstCell: UITableViewCell {

    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var btnInfomration: UIButton!
    @IBOutlet weak var btnIsFavorite: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
