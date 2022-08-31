//
//  SegmentedControl.swift
//  machine0811_a
//
//  Created by CAX521 on 2021/8/30.
//

import UIKit

class SegmentedControl: UISegmentedControl {
    
    
    
    
    open override func layoutSubviews() {
            super.layoutSubviews()
            layer.cornerRadius = 0
        }



    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//
//        mySegmentedControl.tintColor = UIColor.yellow
//        mySegmentedControl.backgroundColor = UIColor.yellow
//        mySegmentedControl.selectedSegmentTintColor = UIColor.yellow
//        // Drawing code
//    }
  

}
