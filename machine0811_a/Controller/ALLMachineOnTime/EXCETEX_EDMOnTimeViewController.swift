//
//  EXCETEX_EDMOnTimeViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2022/4/11.
//

import UIKit
import SocketIO

class EXCETEX_EDMOnTimeViewController: UIViewController {
    
    var NowMachine: String = ""
    
    @IBOutlet weak var WorkingCoordinatesView: UIView!
    @IBOutlet weak var machanicalCoordinatesView: UIView!
    @IBOutlet weak var ProcessingInformationView: UIView!
    
    @IBOutlet weak var receivedAtStr: UILabel!
    
    @IBOutlet weak var Working_coordinatesXStr: UILabel!
    @IBOutlet weak var Working_coordinatesYStr: UILabel!
    @IBOutlet weak var Working_coordinatesZStr: UILabel!
    
    @IBOutlet weak var Mechanical_coordinatesXStr: UILabel!
    @IBOutlet weak var Mechanical_coordinatesYStr: UILabel!
    @IBOutlet weak var Mechanical_coordinatesZStr: UILabel!
    
    @IBOutlet weak var VoltageStr: UILabel!
    @IBOutlet weak var NOStr: UILabel!
    @IBOutlet weak var IPStr: UILabel!
    @IBOutlet weak var ONStr: UILabel!
    @IBOutlet weak var OFFStr: UILabel!
    @IBOutlet weak var HVStr: UILabel!
    @IBOutlet weak var ADJStr: UILabel!
    @IBOutlet weak var WTStr: UILabel!
    @IBOutlet weak var FEEDStr: UILabel!
    @IBOutlet weak var SERStr: UILabel!
    
    @IBOutlet weak var GAPStr: UILabel!
    @IBOutlet weak var EDM_AXISStr: UILabel!
    @IBOutlet weak var DepthStr: UILabel!
    @IBOutlet weak var ProgressStr: UILabel!
    @IBOutlet weak var File_NameStr: UILabel!
    @IBOutlet weak var ALARM_CODEStr: UILabel!
    @IBOutlet weak var CUT_TMStr: UILabel!
    @IBOutlet weak var LeftStr: UILabel!
    @IBOutlet weak var TCUT_TM: UILabel!
    

    let manager = SocketManager(socketURL: URL(string: "http://140.135.97.69:8787")!, config: [.log(false), .forceWebsockets(true)])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI樣式
        UIStyle()

        let socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { (data, _) in
            
            print("socket connected")
        }
        
        socket.on(clientEvent: .error) { (data, eck) in
            print(data)
            print("socket error")
            
        }
        
        socket.on(clientEvent: .disconnect) { (data, eck) in
            print(data)
            print("socket disconnect")
        }
        
        socket.on("EDM_Excetek") { (data, _) in
            guard let dataInfo = data.first else { return }
            
            if let response: EXCETEX_EDMSocketData = try? SocketParser.convert(data: dataInfo) {
                print(response)
                
                self.Working_coordinatesXStr.text = "\(response.Working_coordinatesX)"
                self.Working_coordinatesYStr.text = "\(response.Working_coordinatesY)"
                self.Working_coordinatesZStr.text = "\(response.Working_coordinatesZ)"
                self.Mechanical_coordinatesXStr.text = "\(response.Mechanical_coordinatesX)"
                self.Mechanical_coordinatesYStr.text = "\(response.Mechanical_coordinatesY)"
                self.Mechanical_coordinatesZStr.text = "\(response.Mechanical_coordinatesZ)"
                
                //去電壓單位
                let VStr = response.Voltage
                let characterSet = CharacterSet(charactersIn: "V")
                let VoltageR = VStr.trimmingCharacters(in: characterSet)
                self.VoltageStr.text = "\(VoltageR)"
                self.NOStr.text = "\(response.NO)"
                self.IPStr.text = "\(response.IP)"
                self.ONStr.text = "\(response.ON)"
                self.OFFStr.text = "\(response.OFF)"
                self.HVStr.text = "\(response.HV)"
                self.ADJStr.text = "\(response.ADJ)"
                self.WTStr.text = "\(response.WT)"
                self.FEEDStr.text = "\(response.FEED)"
                self.SERStr.text = "\(response.SER)"
                self.GAPStr.text = "\(response.GAP)"
                self.EDM_AXISStr.text = "\(response.EDM_AXIS)"
                self.DepthStr.text = "\(response.Depth)"
                self.ProgressStr.text = "\(response.Progress)"
                self.File_NameStr.text = "\(response.File_Name)"
                self.ALARM_CODEStr.text = "\(response.ALARM_CODE)"
                self.CUT_TMStr.text = "\(response.CUT_TM)"
                self.LeftStr.text = "\(response.Left)"
                self.TCUT_TM.text = "\(response.TCUT_TM)"
                self.receivedAtStr.text = "\(response.receivedAt)"
                
            }
        }
        
        socket.connect()
        
        
    }
    

    func UIStyle() {
        WorkingCoordinatesView.layer.borderWidth = 1
        WorkingCoordinatesView.layer.borderColor = CGColor(red: 200/234, green: 200/234, blue: 200/234, alpha: 1)
        machanicalCoordinatesView.layer.borderWidth = 1
        machanicalCoordinatesView.layer.borderColor = CGColor(red: 200/234, green: 200/234, blue: 200/234, alpha: 1)
        ProcessingInformationView.layer.borderWidth = 1
        ProcessingInformationView.layer.borderColor = CGColor(red: 200/234, green: 200/234, blue: 200/234, alpha: 1)
    }

}


struct EXCETEX_EDMSocketData: Codable {
    var Working_coordinatesX: String
    var Working_coordinatesY: String
    var Working_coordinatesZ: String
    var Mechanical_coordinatesX: String
    var Mechanical_coordinatesY: String
    var Mechanical_coordinatesZ: String
    var Voltage: String
    var NO: String
    var IP: String
    var ON: String
    var OFF: String
    var HV: String
    var ADJ: String
    var WT: String
    var FEED: String
    var SER: String
    var GAP: String
    var EDM_AXIS: String
    var Depth: String
    var Progress: String
    var File_Name: String
    var ALARM_CODE: String
    var CUT_TM: String
    var Left: String
    var TCUT_TM: String
    var receivedAt: String

}
