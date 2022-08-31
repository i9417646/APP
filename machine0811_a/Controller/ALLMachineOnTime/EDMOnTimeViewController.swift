//
//  EDMOnTimeViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2021/12/10.
//

import UIKit
import SocketIO

class EDMOnTimeViewController: UIViewController {
    
    //目前選到的機台名稱
    var NowMachine: String = ""
    
 
    @IBOutlet weak var parameterView: UIView!
    @IBOutlet weak var NowDataView: UIView!
    
    @IBOutlet weak var taskImg: UIImageView!
    
    @IBOutlet weak var Machine_Category: UILabel!
    
    @IBOutlet weak var receivedAt: UILabel!
    
    @IBOutlet weak var IA: UILabel!
    
    @IBOutlet weak var HV: UILabel!
    
    @IBOutlet weak var TON: UILabel!
    
    @IBOutlet weak var TOF: UILabel!
    
    @IBOutlet weak var SVO: UILabel!
    
    @IBOutlet weak var WK: UILabel!
    
    @IBOutlet weak var JP: UILabel!
    
    @IBOutlet weak var GAP: UILabel!
    
    @IBOutlet weak var Mechanical_coordinatesX: UILabel!
    
    @IBOutlet weak var Mechanical_coordinatesY: UILabel!
    
    @IBOutlet weak var Mechanical_coordinatesZ: UILabel!
    
    @IBOutlet weak var Working_coordinatesX: UILabel!
    
    @IBOutlet weak var Working_coordinatesY: UILabel!
    
    @IBOutlet weak var Working_coordinatesZ: UILabel!
    
    @IBOutlet weak var PositioningerrorX: UILabel!
    
    @IBOutlet weak var PositioningerrorY: UILabel!
    
    @IBOutlet weak var PositioningerrorZ: UILabel!
    
    @IBOutlet weak var GYR_LIGHT: UILabel!
    
    @IBOutlet weak var Processingdepth: UILabel!
    
    @IBOutlet weak var ARC: UILabel!
    
    @IBOutlet weak var effect_rt: UILabel!
    
    @IBOutlet weak var TCUT_TM: UILabel!
    
    @IBOutlet weak var CUT_TM: UILabel!
    
    @IBOutlet weak var ALARM_CODE: UILabel!
    
    
    @IBOutlet weak var JP_STE: UILabel!
    
    @IBOutlet weak var SPK_STE: UILabel!
    
    @IBOutlet weak var PCT_FIRE: UILabel!
    
    @IBOutlet weak var PCT_FLUD: UILabel!
    
    @IBOutlet weak var PCT_ARC: UILabel!
    
    @IBOutlet weak var MAIN_PWR: UILabel!
    
    @IBOutlet weak var PUMP_ST: UILabel!
    
    @IBOutlet weak var COOLtesting: UILabel!
    
    //Socket連線
    let manager = SocketManager(socketURL: URL(string: "http://140.135.97.69:8787")!, config: [.log(false), .forceWebsockets(true)])
    
    var socket:SocketIOClient!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(NowMachine)
        
        
        //UI樣式
        UIStyle()

        
        print("EDMViewController")
        
        let socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { (data, ack) in
            print(data)
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
        
        socket.on("EDM"){ (data, _) in
            
          //  print(data)
            
            guard let dataInfo = data.first else { return }
            
            if let response: EDMSocketData = try? SocketParser.convert(data: dataInfo) {
            //    print(response)
                
                self.Machine_Category.text = response.Machine_Category
                
                self.IA.text = response.IA
                
                self.HV.text = response.HV
                
                self.TON.text = response.TON
                
                self.TOF.text = response.TOF
                
                self.SVO.text = response.SVO
                
                self.WK.text = response.WK
                
                self.JP.text = response.JP
                
                self.GAP.text = response.GAP
                
                self.Mechanical_coordinatesX.text = response.Mechanical_coordinatesX
                
                self.Mechanical_coordinatesY.text = response.Mechanical_coordinatesY
                
                self.Mechanical_coordinatesZ.text = response.Mechanical_coordinatesZ
                
                self.Working_coordinatesX.text = response.Working_coordinatesX
                
                self.Working_coordinatesY.text = response.Working_coordinatesY
                
                self.Working_coordinatesZ.text = response.Working_coordinatesZ
                
                self.PositioningerrorX.text = response.PositioningerrorX
                
                self.PositioningerrorY.text = response.PositioningerrorY
                
                self.PositioningerrorZ.text = response.PositioningerrorZ
                
                self.GYR_LIGHT.text = response.GYR_LIGHT
                
                self.Processingdepth.text = response.Processingdepth
                
                self.ARC.text = response.ARC
                
                self.effect_rt.text = response.effect_rt
                
                self.TCUT_TM.text = response.TCUT_TM
                
                self.CUT_TM.text = response.CUT_TM
                
                self.ALARM_CODE.text = response.ALARM_CODE
                
                self.receivedAt.text = "\(response.receivedAt)"
                
                
                //如果資料是ON背景顏色改變
                self.JP_STE.backgroundColor = response.JP_STE == "ON" ? UIColor(displayP3Red: 154/255, green: 219/255, blue: 123/255, alpha: 1) : UIColor(displayP3Red: 200/234, green: 200/234, blue: 200/234, alpha: 1)
                
                self.SPK_STE.backgroundColor = response.SPK_STE == "ON" ? UIColor(displayP3Red: 154/255, green: 219/255, blue: 123/255, alpha: 1) :UIColor(displayP3Red: 200/234, green: 200/234, blue: 200/234, alpha: 1)
                
                self.PCT_FIRE.backgroundColor = response.PCT_FIRE == "ON" ? UIColor(displayP3Red: 154/255, green: 219/255, blue: 123/255, alpha: 1) : UIColor(displayP3Red: 200/234, green: 200/234, blue: 200/234, alpha: 1)
                
                self.PCT_FLUD.backgroundColor = response.PCT_FLUD == "ON" ? UIColor(displayP3Red: 154/255, green: 219/255, blue: 123/255, alpha: 1) : UIColor(displayP3Red: 200/234, green: 200/234, blue: 200/234, alpha: 1)
                
                self.PCT_ARC.backgroundColor = response.PCT_ARC == "ON" ? UIColor(displayP3Red: 154/255, green: 219/255, blue: 123/255, alpha: 1) : UIColor(displayP3Red: 200/234, green: 200/234, blue: 200/234, alpha: 1)
                
                self.MAIN_PWR.backgroundColor = response.MAIN_PWR == "ON" ? UIColor(displayP3Red: 154/255, green: 219/255, blue: 123/255, alpha: 1) : UIColor(displayP3Red: 200/234, green: 200/234, blue: 200/234, alpha: 1)
                
                self.PUMP_ST.backgroundColor = response.PUMP_ST == "ON" ? UIColor(displayP3Red: 154/255, green: 219/255, blue: 123/255, alpha: 1) : UIColor(displayP3Red: 200/234, green: 200/234, blue: 200/234, alpha: 1)
                
                self.COOLtesting.backgroundColor = response.COOLtesting == "ON" ? UIColor(displayP3Red: 154/255, green: 219/255, blue: 123/255, alpha: 1) : UIColor(displayP3Red: 200/234, green: 200/234, blue: 200/234, alpha: 1)
                
                //如果資料是ON字體顏色改變
                self.JP_STE.textColor = response.JP_STE == "ON" ? .white : .black
                self.SPK_STE.textColor = response.SPK_STE == "ON" ? .white : .black
                self.PCT_FIRE.textColor = response.PCT_FIRE == "ON" ? .white : .black
                self.PCT_FLUD.textColor = response.PCT_FLUD == "ON" ? .white : .black
                self.PCT_ARC.textColor = response.PCT_ARC == "ON" ? .white : .black
                self.MAIN_PWR.textColor = response.MAIN_PWR == "ON" ? .white : .black
                self.PUMP_ST.textColor = response.PUMP_ST == "ON" ? .white : .black
                self.COOLtesting.textColor = response.COOLtesting == "ON" ? .white : .black
                
            }
            

        }
        
        socket.connect()
    }
    
    //UI樣式設定
    func UIStyle() {
        
        parameterView.layer.borderColor = CGColor(red: 200/234, green: 200/234, blue: 200/234, alpha: 1)
        NowDataView.layer.borderColor = CGColor(red: 200/234, green: 200/234, blue: 200/234, alpha: 1)
        taskImg.layer.borderColor = CGColor(red: 200/234, green: 200/234, blue: 200/234, alpha: 1)
        taskImg.layer.borderWidth = 1
    }

    
    

    
    
    deinit{
        print("EDM OS++++++++++++++++")
    }


}

//Scket所受到的資料解碼
struct EDMSocketData: Codable {
    var Machine_Category: String
    var IA: String
    var HV: String
    var TON: String
    var TOF: String
    var SVO: String
    var WK: String
    var JP: String
    var GAP: String
    var JP_STE: String
    var SPK_STE: String
    var PCT_FIRE: String
    var PCT_FLUD: String
    var PCT_ARC: String
    var MAIN_PWR: String
    var PUMP_ST: String
    var COOLtesting: String
    var Mechanical_coordinatesX: String
    var Mechanical_coordinatesY: String
    var Mechanical_coordinatesZ: String
    var Working_coordinatesX: String
    var Working_coordinatesY: String
    var Working_coordinatesZ: String
    var PositioningerrorX: String
    var PositioningerrorY: String
    var PositioningerrorZ: String
    var GYR_LIGHT: String
    var Processingdepth: String
    var ARC: String
    var effect_rt: String
    var TCUT_TM: String
    var CUT_TM: String
    var ALARM_CODE: String
    var receivedAt: String
    var File_Name: String
    var Machine_Number: String
    var Material: String
    var Tool_Material: String
    
}

