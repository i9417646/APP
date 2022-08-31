//
//  SectionCNCViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2022/4/12.
//

import UIKit
import SocketIO


class SectionCNCViewController: UIViewController {
    
    
    @IBOutlet weak var TCCCDataView: UIScrollView!
  
    @IBOutlet weak var TDDDataView: UIScrollView!
    
    @IBOutlet weak var WLDataView: UIScrollView!
    
 
    @IBOutlet weak var WLTitle: UILabel!
    
    @IBOutlet weak var WLView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //把華瑞那台先隱藏
        self.WLTitle.isHidden = true
        self.WLView.isHidden = true
        
        
        //將台中精機的畫面放進來
        let TCCC_controller = storyboard!.instantiateViewController(withIdentifier: "TCCC_OnTime")
        //把台中精機畫面放入scrollView,這樣才能滑動
        TCCCDataView.contentSize = TCCC_controller.view.bounds.size
        TCCCDataView.contentSize.width = CGFloat(820)
        TCCCDataView.contentSize.height = CGFloat(350)
        print(TCCCDataView.contentSize.width)
        TCCCDataView.addSubview(TCCC_controller.view)
        
        //將台達電的畫面放進來
        let TDD_controller = storyboard!.instantiateViewController(withIdentifier: "TDD_OnTime") as! SectionCNCA02ViewController
        //把台達電畫面放入scrollView,這樣才能滑動
        TDDDataView.contentSize = TDD_controller.view.bounds.size
        TDDDataView.contentSize.width = CGFloat(820)
        TDDDataView.contentSize.height = CGFloat(350)
        print(TCCCDataView.contentSize.width)
        TDDDataView.addSubview(TDD_controller.view)
        
        //把華瑞的畫面放進來
        let WL_controller = storyboard!.instantiateViewController(withIdentifier: "WLSB") as! SectionCNC01ViewController
        //把華瑞面放入scrollView,這樣才能滑動
        WLDataView.contentSize = WL_controller.view.bounds.size
        WLDataView.contentSize.width = CGFloat(820)
        WLDataView.contentSize.height = CGFloat(350)
        WLDataView.addSubview(WL_controller.view)

    }
    

    
}

