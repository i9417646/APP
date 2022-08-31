//
//  AllMachineViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2021/8/30.
//

import UIKit
import SocketIO

class AllMachineViewController: UIViewController {

    @IBOutlet weak var CNCA01Status: UILabel!
    
    @IBOutlet weak var INJStatus: UILabel!
    
    
    @IBOutlet weak var seeALLButton: UIButton!
    
    @IBOutlet weak var INJButton: UIButton!
    
    //Socket連線
    let manager = SocketManager(socketURL: URL(string: "http://140.135.97.69:8787")!, config: [.log(false), .forceWebsockets(true)])
    
    var socket:SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //關閉ＵＩ
        self.CNCA01Status.isHidden = true
        self.INJStatus.isHidden = true
        self.seeALLButton.isHidden = true
        self.INJButton.isHidden = true
        
//        let socket = manager.defaultSocket
//        
//        socket.on(clientEvent: .connect) { (data, ack) in
//            print(data)
//            print("socket connected")
////            self.CNCA01Status.text = "on"
////            self.CNCA01Status.backgroundColor = .red
////            self.INJStatus.text = "on"
////            self.INJStatus.backgroundColor = .red
//       
//        }
//        
//        socket.on(clientEvent: .error) { (data, eck) in
//            print(data)
//            print("socket error")
//            
//        }
//        
//        socket.on(clientEvent: .disconnect) { (data, eck) in
//            print(data)
//            print("socket disconnect")
//        }
//        
//        socket.on("injDDS"){ (data, _) in
//            self.INJStatus.text = "on"
//            self.INJStatus.backgroundColor = .red
//        }
//        socket.on("CNC_Vcenter_p76"){ (data, _) in
//            self.CNCA01Status.text = "on"
//            self.CNCA01Status.backgroundColor = .red
//        }
       // socket.connect()

        // Do any additional setup after loading the view.
    }
    
 //使用segue的方式跳頁
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_CNCA01"{
            let vc = segue.destination as! containViewController
            //將數據傳遞到下一頁
            vc.machineName = "CNCA_01"
        } else if  segue.identifier == "segue_CNCA02"{
            let vc = segue.destination as! containViewController
            vc.machineName = "CNCA_02"
        } else if  segue.identifier == "segue_CNC01"{
            let vc = segue.destination as! containViewController
            vc.machineName = "CNC_01"
        } else if  segue.identifier == "segue_EDMA03"{
            let vc = segue.destination as! containViewController
            vc.machineName = "EDMA_03"
        } else if  segue.identifier == "segue_Injection"{
            let vc = segue.destination as! containViewController
            vc.machineName = "Injection"
        } else if segue.identifier == "segue_EWA01"{
            let vc = segue.destination as! containViewController
            vc.machineName = "EWA_01"
        } else if segue.identifier == "segue_EWA02" {
            let vc = segue.destination as! containViewController
            vc.machineName = "EWA_02"
        } else if segue.identifier == "segue_EDMA01" {
            let vc = segue.destination as! containViewController
            vc.machineName = "EDMA_01"
        }  else if segue.identifier == "segue_Staubli" {
            let vc = segue.destination as! containViewController
            vc.machineName = "Staubli"
        } else if segue.identifier == "segue_EDMA02" {
            let vc = segue.destination as! containViewController
            vc.machineName = "EDMA_02"
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
