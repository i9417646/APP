//
//  workTableViewCell.swift
//  machine0811_a
//
//  Created by CAX521 on 2021/9/1.
//

import UIKit

class workTableViewCell: UITableViewCell {

    @IBOutlet weak var orderNBTitle: UILabel!
    
    @IBOutlet weak var OrderFormNumber: UILabel!
    
    @IBOutlet weak var qcSchedule: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
