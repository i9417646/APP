//
//  containViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2021/8/30.
//

import UIKit


//切換頁籤功能https://apppeterpan.medium.com/%E5%88%A9%E7%94%A8-scroll-view-container-view-%E6%B0%B4%E5%B9%B3%E6%BB%91%E5%8B%95%E5%88%87%E6%8F%9B%E9%A0%81%E9%9D%A2-18cec0f910dc

class containViewController: UIViewController {
    var machineName: String? = "轉換中"
    let mySegmentedControl = UISegmentedControl()
    


    @IBOutlet weak var segmentedControl: SegmentedControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var OnTimeView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationItem＝機台名稱
        navigationItem.title = machineName
       
        
        //UISegmentedControl(分段控制)
        //字體顏色
        mySegmentedControl.tintColor = UIColor.yellow
        //背景顏色
        mySegmentedControl.backgroundColor = UIColor.yellow
        mySegmentedControl.selectedSegmentTintColor = UIColor.yellow
        
      
     
    
     //   print("contaner的machoine\(machineName)")
        
        if let machineName = machineName {
            print("正在第二試圖\(machineName)")
        }
    }
    
    //segue跳頁(跳到orderTableViewController)中(零件列表)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedSegue"{
            let vc = segue.destination as! orderTableViewController
            //傳值到控制器(orderTableViewController)中(零件列表)
            vc.machine = machineName
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //即時資訊ViewCintroller
         NowChooseControler()
    }
    
    //頁面切換控制
    @IBAction func changePage(_ sender: UISegmentedControl) {
        
        let x = CGFloat(sender.selectedSegmentIndex) * scrollView.bounds.width
        let offset = CGPoint(x:x, y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }
    
    
    
    func NowChooseControler(){
        //判斷此機器是哪個種類機台,並帶到正確的即時數據頁面
        if self.machineName == "CNCA_02" || self.machineName == "CNCA_01" || self.machineName == "CNC_01"{
            //在containView中的ScrollView的Container放入點選該機台類別的頁面
            let controller = storyboard!.instantiateViewController(withIdentifier: "CNCOnTime") as! OnTimeViewController
            addChild(controller)
            //傳值
            controller.NowMachine = self.machineName!
            
            OnTimeView.addSubview(controller.view)
            
        } else if self.machineName == "EDMA_03"{
            let controller = storyboard!.instantiateViewController(withIdentifier: "EDMOnTime") as! EDMOnTimeViewController
            addChild(controller)
            
            
            controller.NowMachine = self.machineName!
            
            OnTimeView.addSubview(controller.view)
        } else if self.machineName == "Injection" {
            let controller = storyboard!.instantiateViewController(withIdentifier: "InjectionOnTime") as! InjectionOnTimeViewController
            addChild(controller)
            controller.NowMachine = self.machineName!
            OnTimeView.addSubview(controller.view)
            
        } else if self.machineName == "EWA_01" || self.machineName == "EWA_02" {
            let controller = storyboard!.instantiateViewController(identifier: "EWOnTime") as! EWOnTimeViewController
            addChild(controller)
            controller.NowMachine = self.machineName!
            OnTimeView.addSubview(controller.view)
        } else if self.machineName == "EDMA_01" {
            let controller = storyboard!.instantiateViewController(identifier: "EDMOnTime_EXCETEX") as! EXCETEX_EDMOnTimeViewController
            addChild(controller)
            controller.NowMachine = self.machineName!
            OnTimeView.addSubview(controller.view)
            
        } else if self.machineName == "Staubli" {
            let controller = storyboard!.instantiateViewController(identifier: "StaubliOnTime") as! StaubliViewController
            addChild(controller)
            controller.NowMachine = self.machineName!
            OnTimeView.addSubview(controller.view)
            
        } else if self.machineName == "EDMA_02" {
            let controller = storyboard!.instantiateViewController(identifier: "EDMOnTime_OSCAR") as! OSCAR_EDMOnTimeViewController
            addChild(controller)
            controller.NowMachine = self.machineName!
            OnTimeView.addSubview(controller.view)
            
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//擴充功能
extension containViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        segmentedControl.selectedSegmentIndex = index
    }
}
