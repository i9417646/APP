//
//  OnTimeViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2021/11/18.
//

import UIKit
import SocketIO

class OnTimeViewController: UIViewController {
    
    //目前選到的機台名稱
    var NowMachine: String = ""
    
    //判斷toollist當前選到的視窗的參數
    var chooseID: String = "CNCOnTimeData"
    

    
    @IBOutlet weak var ProcessInfoView: UIView!
    

    @IBOutlet weak var projectNo: UILabel!
    
    @IBOutlet weak var partNo: UILabel!
    
    @IBOutlet weak var processType: UILabel!
    
    @IBOutlet weak var NOWTime: UILabel!
    
    
    @IBOutlet weak var bottomView: UIView!
    
    //socket
    let manager = SocketManager(socketURL: URL(string: "http://140.135.97.69:8787")!, config: [.log(false), .forceWebsockets(true)])
    var socket:SocketIOClient!
    
    deinit {
        print("OS reclaiming memory ")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("00000000000000000")
        CNCLoadBottomView()
   
//        ProcessInfoView.layer.borderColor = CGColor(red: 200/234, green: 200/234, blue: 200/234, alpha: 1)
//        NCCodeView.layer.borderColor = CGColor(red: 200/234, green: 200/234, blue: 200/234, alpha: 1)
//        controlView.layer.borderColor = CGColor(red: 200/234, green: 200/234, blue: 200/234, alpha: 1)
//        NCTextView.isEditable = false
//        // Do any additional setup after loading the view.
//
//        controlLabel.layer.zPosition = 1
        
//        print(NowMachine)

        let socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { (data, _) in
            print("CNC主頁no socket connected")
            print("\(data.debugDescription)")
            
     
           
        }
        
        var socketStr: String = ""
        if self.NowMachine == "CNCA_01" {
            socketStr = "CNC_Vcenter_p76"
        } else if self.NowMachine == "CNCA_02" {
            socketStr = "DDS"
        } else if self.NowMachine == "CNC_01" {
            socketStr = "CNC_VMC_860"
        }
        
        socket.on(socketStr){ (data, _) in
           
          
          //  print(data)
         //   print(socketStr)
                      
            guard let dataInfo = data.first else { return }
            
            
            if let response: CNCUperData = try? SocketParser.convert(data: dataInfo) {
           //     print(response.receivedAt)
                
                self.projectNo.text = response.projectNo
                self.partNo.text = response.partNo
                self.NOWTime.text = response.receivedAt
                
         //       print(response)
         //       print(response.ncCode)
//                self.projectNo.text = response.projectNo
//                self.partNo.text = response.partNo
//                self.processType.text = response.processType
//                self.NOWTime.text = response.NOWTime
//
//
//                //將;換成\n來達到換行結果
//                let string = "\(response.NCProgram.replacingOccurrences(of: ";", with: "\n"))"
//                //正在執行的NCCode改變字體顏色
//                let attributedString = NSMutableAttributedString.init(string: string)
//                let range = (string as NSString).range(of: "\(response.ncCode)")
//                attributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.init(displayP3Red: 255 / 255, green: 186 / 255, blue: 82 / 255, alpha: 0.5), range: range)
//                self.NCTextView.attributedText = attributedString
//                self.NCTextView.isUserInteractionEnabled = true
//
//
//
//                self.spindleSpeed.text = response.spindleSpeed
//                self.feed.text = response.feed
//                self.Iz.text = "\(response.Iz)"
//                self.Is.text = "\(response.Is)"
//                self.tempS.text = "\(response.tempS)"
//                self.tempX.text = "\(response.tempX)"
//                self.tempY.text = "\(response.tempY)"
//                self.tempZ.text = "\(response.tempZ)"
//
//               //將,換成空字串來達到去,功能
//                self.fftx.text = "\(response.fftx.replacingOccurrences(of: ",", with: ""))"
//                self.ffty.text = "\(response.ffty.replacingOccurrences(of: ",", with: ""))"
//                self.fftz.text = "\(response.fftz.replacingOccurrences(of: ",", with: ""))"
//
//                self.fftavgxx.text = "\(response.fftavgxx.replacingOccurrences(of: ",", with: ""))"
//                self.fftavgyy.text = "\(response.fftavgyy.replacingOccurrences(of: ",", with: ""))"
//                self.fftavgzz.text = "\(response.fftavgzz.replacingOccurrences(of: ",", with: ""))"
//
//                self.positionX.text = "\(response.MachineCoordinatesX)"
//                self.positionY.text = "\(response.MachineCoordinatesY)"
//                self.positionZ.text = "\(response.MachineCoordinatesZ)"
            }

  
        }
        
        
     

        socket.emit("SWIFT", "got your response")


        socket.connect()
    }
    
    

    
    //動作：點選toollist後，更改參數
    @IBAction func MachineDataClick(_ sender: Any) {
        self.chooseID = "CNCOnTimeData"
        print(self.chooseID)
        CNCLoadBottomView()
        
    }
    
    //動作：點選toollist後，更改參數
    @IBAction func AnalysisClick(_ sender: Any) {
        self.chooseID = "CNCOnTimeAnalysis"
        print(self.chooseID)
        
        CNCLoadBottomView()
    }
    
//藉由切換頁籤，將相對應的畫面放入下方視窗中
    func CNCLoadBottomView() {
        if self.chooseID == "CNCOnTimeData" {
            
            //刪除BottomView的所有子視圖
            for view in self.bottomView.subviews {
                view.removeFromSuperview()
            }
            let controller = storyboard!.instantiateViewController(identifier: "CNCOnTimeData") as! CNCOnTimeMachineDataViewController
            addChild(controller)
            controller.NowMachine = self.NowMachine
            bottomView.addSubview(controller.view)

            
        } else if self.chooseID == "CNCOnTimeAnalysis" {
            
            //刪除BottomView的所有子視圖
            for view in self.bottomView.subviews {
                view.removeFromSuperview()
            }
            let controller = storyboard!.instantiateViewController(identifier: "CNCOnTimeAnalysis") as! CNCOnTimeAnalysisViewControllerViewController
            addChild(controller)
            controller.NowMachine = self.NowMachine
            bottomView.addSubview(controller.view)
            
            
        }
        
    }
    
    

}




struct SocketData: Codable {
    var projectNo: String
    var partNo: String
    var processType: String
    var NOWTime: String
    var NCProgram: String
    var ncCode: String
    var spindleSpeed: String
    var feed: String
    var Iz: String
    var Is: String
    var tempS: Double
    var tempX: Double
    var tempY: Double
    var tempZ: Double
    var fftx: String
    var ffty: String
    var fftz: String
    var fftavgxx: String
    var fftavgyy: String
    var fftavgzz: String
    var MachineCoordinatesX: String
    var MachineCoordinatesY: String
    var MachineCoordinatesZ: String
    var receivedAt: String
    var FFTValue: [ Double ]
    var VibrValue: [Double]
}

struct CNCUperData: Codable {
    var projectNo: String
    var partNo: String
    var receivedAt: String
}
