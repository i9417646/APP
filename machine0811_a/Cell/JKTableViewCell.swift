//
//  JKTableViewCell.swift
//  machine0811_a
//
//  Created by CAX521 on 2021/9/7.
//

import UIKit
import JKSteppedProgressBar

class JKTableViewCell: UITableViewCell {

    @IBOutlet weak var progressbar: SteppedProgressBar!
    @IBOutlet weak var processcount: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var task: UILabel!
    @IBOutlet weak var estalltime: UILabel!
    
    
    
    var inset: UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 30)
    }
    
    
    func initbar(_ Data: singalWork){
        progressbar.titles = Data.processType
      //  progressbar.esttime = Data.estimatedTime
        progressbar.insets = inset
        //完成的顏色
//        progressbar.activeColor = UIColor.red

//        progressbar.inactiveColor = UIColor.yellow
        //完成的步進
       progressbar.currentTab = 0
        
    }
    func initbarest(_ estTimeString: Any){
        //下面那欄
        progressbar.esttime = estTimeString as! [String]
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(url: String) {
        img.load(urlString: url)
    }

}
