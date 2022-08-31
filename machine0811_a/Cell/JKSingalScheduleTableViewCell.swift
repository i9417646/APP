//
//  JKSingalScheduleTableViewCell.swift
//  machine0811_a
//
//  Created by CAX521 on 2021/10/15.
//

import UIKit
import JKSteppedProgressBar

class JKSingalScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tasks: UILabel!
    @IBOutlet weak var TotalRealWT: UILabel!
    @IBOutlet weak var TotalEstWT: UILabel!
    @IBOutlet weak var taskImg: UIImageView!
    @IBOutlet weak var JKBar: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        JKBar.addSubview(JKPrograss)
        
        JKPrograss.topAnchor.constraint(equalTo: JKBar.topAnchor, constant: 0).isActive = true
        JKPrograss.bottomAnchor.constraint(equalTo: JKBar.bottomAnchor, constant: 0).isActive = true
        JKPrograss.leadingAnchor.constraint(equalTo: JKBar.leadingAnchor, constant: 0).isActive = true
        JKPrograss.trailingAnchor.constraint(equalTo: JKBar.trailingAnchor, constant: 0).isActive = true
        
    }
    
    let JKPrograss: SteppedProgressBar = {
        let JKView = SteppedProgressBar()
        JKView.translatesAutoresizingMaskIntoConstraints = false
        return JKView
    }()
    
    var inset: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 50, right: 30)
    }

    func initbar(_ Data: SignalSTData){
        JKPrograss.titles = Data.processType
   
        JKPrograss.insets = inset
        //完成的顏色
        JKPrograss.activeColor = UIColor(displayP3Red: 67/255, green: 110/255, blue: 238/255, alpha: 1)
        //JKPrograss.activeColor = Data.WorkerIdx == Data.ScheduleCount ? UIColor(displayP3Red: 34/255, green: 139/255, blue: 34/255, alpha: 0.8) : UIColor(displayP3Red: 67/255, green: 110/255, blue: 238/255, alpha: 1)
        //未完成顏色
        JKPrograss.inactiveColor = UIColor.lightGray
        
        
        //完成的步進
        JKPrograss.currentTab = Data.WorkerIdx
        //背景
        JKPrograss.backgroundColor = UIColor.white
        
        JKPrograss.circleRadius = 25
        
        JKPrograss.titleOffset = 10
        
        JKPrograss.lineWidth = 3
    }
    
    func initbarest(_ estTimeString: [String]){
        //下面那欄
        JKPrograss.esttime = estTimeString
    }
    
    func initmachine(_ machine: [String]){
        JKPrograss.machine = machine
    }
    
    func initrealTime(_ raaltime: [String]){
        JKPrograss.realtime = raaltime
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(url: String) {
        taskImg.load(urlString: url)
    }

}
