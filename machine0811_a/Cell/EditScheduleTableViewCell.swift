//
//  EditScheduleTableViewCell.swift
//  machine0811_a
//
//  Created by CAX521 on 2021/10/7.
//

import UIKit

class EditScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var BestString: UILabel!
    @IBOutlet weak var TimeString: UILabel!
    @IBOutlet weak var Status: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
