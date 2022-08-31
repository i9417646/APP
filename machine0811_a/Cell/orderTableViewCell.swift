//
//  orderTableViewCell.swift
//  machine0811_a
//
//  Created by julie on 2021/8/11.
//

import UIKit

class orderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tasks: UILabel!{
        didSet {
            tasks.numberOfLines = 0
        }
    }
    @IBOutlet weak var orderFormNumber: UILabel!{
        didSet {
            orderFormNumber.numberOfLines = 0
        }
    }
    @IBOutlet weak var fifoStartTime: UILabel!{
        didSet {
            fifoStartTime.numberOfLines = 0
        }
    }
    @IBOutlet weak var estimatedTime: UILabel!{
        didSet {
            estimatedTime.numberOfLines = 0
        }
    }
    @IBOutlet weak var StartDate: UILabel!{
        didSet {
            StartDate.numberOfLines = 0
        }
    }

    @IBOutlet weak var StartTime: UILabel!{
        didSet {
            StartTime.numberOfLines = 0
        }
    }
    

   @IBOutlet weak var machineImg: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(url: String) {
        machineImg.load(urlString: url)
    }
//    func configure(url:String){
//        UIImageView.load(urlString: url)
//    }

}
