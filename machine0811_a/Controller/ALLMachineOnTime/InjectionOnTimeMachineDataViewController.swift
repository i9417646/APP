//
//  InjectionOnTimeMachineDataViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2021/12/30.
//

import UIKit
import SocketIO

class InjectionOnTimeMachineDataViewController: UIViewController {
    
    @IBOutlet weak var IJ_Pre: UILabel!
    
    @IBOutlet weak var IJ_Vel: UILabel!
    
    @IBOutlet weak var IP: UILabel!
    
    @IBOutlet weak var Temp_set: UILabel!
    
    @IBOutlet weak var PACK_P: UILabel!
    
    @IBOutlet weak var PACK_T: UILabel!
    
    @IBOutlet weak var V2P_T: UILabel!
    
    @IBOutlet weak var Cooling_T: UILabel!
    
    @IBOutlet weak var Cooling_T_Start: UILabel!
    
    @IBOutlet weak var Cooling_T_End: UILabel!
    
    
    
    @IBOutlet weak var MaxPressure: UILabel!
    
    @IBOutlet weak var FillingTime: UILabel!
    
    @IBOutlet weak var VPSwitchPreasure: UILabel!
    
    @IBOutlet weak var Temp_set_Field: UILabel!
    
    @IBOutlet weak var MeteringEndPos: UILabel!
    
    @IBOutlet weak var MinResidue: UILabel!
    
    @IBOutlet weak var VPSwitchPos: UILabel!
    
    @IBOutlet weak var SuckBackPressure: UILabel!
    
    @IBOutlet weak var ScrewSpeed: UILabel!
    
    @IBOutlet weak var CycleTime: UILabel!
    
    @IBOutlet weak var MeteringTime: UILabel!
    
    @IBOutlet weak var PACK_P_Field: UILabel!
    
    @IBOutlet weak var PACK_T_Field: UILabel!
    
    //socket連線狀況(未使用)
    @IBOutlet weak var connectLabel: UILabel!
    
    
    //Socket
    let manager = SocketManager(socketURL: URL(string: "http://140.135.97.69:8787")!, config: [.log(false), .forceWebsockets(true)])
    
    
    var socket:SocketIOClient!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("123")
        
        let socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { (data, ack) in
            print(data)
            print("射出機即時機台數據 socket connected")
        
            
            
        }
        
        socket.on(clientEvent: .error) { (data, eck) in
            print(data)
            print("socket error")
        }
        
        socket.on(clientEvent: .disconnect) { (data, eck) in
            print(data)
            print("socket disconnect")
        }
        
        socket.on("injDDS"){ (data, _) in
        
          //  print(data)
            
            guard let dataInfo = data.first else { return }
            
            //Socket資料解碼
            if let response: InjSocketData = try? SocketParser.convert(data: dataInfo) {
             //   print(response)
              //  print("567")
                
                //作為時間解碼格式
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                //時間格式
                let fomatter = DateFormatter()
                fomatter.dateFormat = "HH:mm:ss"
                
                //參數設定欄位
                self.IJ_Pre.text = "\(response.IJ_Pre) "
                self.IJ_Vel.text = "\(response.IJ_Vel_1st)/\(response.IJ_Vel_2nd)/\(response.IJ_Vel_3rd)/\(response.IJ_Vel_4th)/\(response.IJ_Vel_5th)"
                self.IP.text = "\(response.IP_1)/\(response.IP_2)/\(response.IP_3)/\(response.IP_4)/\(response.IP_5)"
                self.Temp_set.text = "\(response.Temp_set_Z0)/\(response.Temp_set_Z1)/\(response.Temp_set_Z2)/\(response.Temp_set_Z3)"
                
                self.PACK_P.text = "\(response.PACK_P_1st)/\(response.PACK_P_2nd)/\(response.PACK_P_3rd)"
                self.PACK_T.text = "\(response.PACK_T_1st)/\(response.PACK_T_2nd)/\(response.PACK_T_3rd)"
                self.V2P_T.text = response.V2P_T
                self.Cooling_T.text = response.Cooling_T
                
                //冷卻結束時間＝數據傳出當下時間點
                ///將UTC時間轉為Date格式,再以HH:mm:ss顯示
                let EndData = dateFormatter.date(from: response.receivedAt)
                self.Cooling_T_End.text = "\(fomatter.string(from: EndData!))"
                
                //冷卻開始時間＝冷卻結束時間-冷卻時間
                let StartData = EndData?.addingS(seconds: -Int(response.Cooling_T)!)
                self.Cooling_T_Start.text = "\(fomatter.string(from: StartData!))"

                
                //現場數值
                self.MaxPressure.text = response.SPC_maxPressure
                self.FillingTime.text = response.SPC_fillingTime
                self.VPSwitchPreasure.text = "\(response.SPC_vpSwitchPressure) kgf/cm^2"
                self.Temp_set_Field.text = "\(response.Temp_set_Z0)/\(response.Temp_set_Z1)/\(response.Temp_set_Z2)/\(response.Temp_set_Z3)"
                self.MeteringEndPos.text = "\(response.SPC_meteringEndPos) mm"
                self.MinResidue.text = "\(response.SPC_minResidue) mm"
                self.VPSwitchPos.text = "\(response.SPC_vpSwitchPos) mm"
                self.SuckBackPressure.text = response.SPC_suckBackPressure
                self.ScrewSpeed.text = response.SPC_screwSpeed
                self.CycleTime.text = response.SPC_cycleTime
                self.MeteringTime.text = response.SPC_meteringTime
                
                self.PACK_T_Field.text = "\(response.PACK_T_1st)/\(response.PACK_T_2nd)/\(response.PACK_T_3rd)"
     
                self.PACK_P_Field.text = self.MaxFn(PCurve: response.Pressure_Curve, P_T1: Float(response.PACK_T_1st)!, P_T2: Float(response.PACK_T_2nd)!, P_T3: Float(response.PACK_T_3rd)!, fillTime: Float(response.SPC_fillingTime)!)
                
            }
            
        }
        
        

        
        socket.connect()

        // Do any additional setup after loading the view.
    }
    
    //PCurve:射出曲線, P_T1：保壓時間1階段, P_T2：保壓時間2階段, P_T3：保壓時間3階段, P_T4：保壓時間4階段, fillTime: 充填時間
    func MaxFn(PCurve: String, P_T1: Float, P_T2: Float, P_T3: Float, fillTime: Float) -> String{
        
        var Pressure1: Float = 0
        var Pressure2: Float = 0
        var Pressure3: Float = 0
        
        //將射出曲線資料變成Array
        let PressureCurve = PressureData(arryStr: PCurve)
        
        //取得最接近保壓時間的項目
        var nearItem1: Int = 0
   
        //保壓時間第一階段壓力
        if P_T1 == 0 {
            
            Pressure1 = 0
            
        } else {
             
             let unit = (fillTime + P_T1 + P_T2 + P_T3) / Float(PressureCurve.count - 1)
             var unitArray = [Float]()
      
             for i in 0..<PressureCurve.count {
                 let a = Float(i) * unit
                 unitArray.append(a)
             }

            
             for i in 0..<PressureCurve.count {
                 
                 if unitArray[i] == (fillTime + P_T1){
                     nearItem1 = i
               
                 } else if unitArray[i] < (fillTime + P_T1) && (fillTime + P_T1) < unitArray[i+1] {
                     nearItem1 = i
                 }

             }
            
            Pressure1 = PressureCurve[nearItem1]

            
        }
        
        //取得最接近保壓時間的項目
        var nearItem2: Int = 0
   
        //保壓時間第二階段壓力
        if P_T2 == 0 {
            
            Pressure2 = 0
            
        } else {
             
             let unit = (fillTime + P_T1 + P_T2 + P_T3) / Float(PressureCurve.count - 1)
             var unitArray = [Float]()
      
             for i in 0..<PressureCurve.count {
                 let a = Float(i) * unit
                 unitArray.append(a)
             }

             for i in 0..<PressureCurve.count {
                 
                 if unitArray[i] == (fillTime + P_T1 + P_T2){
                     nearItem2 = i
               
                 } else if unitArray[i] < (fillTime + P_T1 + P_T2) && (fillTime + P_T1 + P_T2) < unitArray[i+1] {
                     nearItem2 = i
                 }

             }
            Pressure2 = PressureCurve[nearItem2]
        }
        
        //取得最接近保壓時間的項目
        var nearItem3: Int = 0
   
        //保壓時間第二階段壓力
        if P_T3 == 0 {
            
            Pressure3 = 0
            
        } else {
             
             let unit = (fillTime + P_T1 + P_T2 + P_T3) / Float(PressureCurve.count - 1)
             var unitArray = [Float]()
      
             for i in 0..<PressureCurve.count {
                 let a = Float(i) * unit
                 unitArray.append(a)
             }

            
             for i in 0..<PressureCurve.count {
                 
                 if unitArray[i] == (fillTime + P_T1 + P_T2 + P_T3){
                     nearItem3 = i
               
                 } else if unitArray[i] < (fillTime + P_T1 + P_T2 + P_T3) && (fillTime + P_T1 + P_T2 + P_T3) < unitArray[i+1] {
                     nearItem3 = i
                 }

             }
            
            Pressure3 = PressureCurve[nearItem3]
        }
        return "\(Pressure1)/\(Pressure2)/\(Pressure3)"
    }
    
    //將壓力數據由字串轉為Array
    func PressureData(arryStr: String) -> Array<Float> {
        let str = NSString(string: arryStr)
        //以,來切分資料
        let div = str.components(separatedBy: ",")
        var PressureArray:[Float] = []
        //將切分完的資料放入array中
        for i in div {
            PressureArray.append(Float(i) ?? 0)
        }
        let arr = Array(PressureArray[499...749])
        //過濾掉不是0的數字
        let arrFillter = arr.filter{ $0 != 0 }
      

        return arrFillter
    }
        
       
   
}

//Socket資料格式
struct InjSocketData: Codable {
    var SPC_cycleTime: String
    var SPC_fillingTime: String
    var SPC_meteringTime: String
    var SPC_screwSpeed: String
    var SPC_maxPressure: String
    var SPC_suckBackPressure: String
    var SPC_meteringEndPos: String
    var SPC_minResidue: String
    var SPC_vpSwitchPressure: String
    var SPC_vpSwitchPos: String
    var SPC_finalResidue: String
    var Pressure_Curve: String
    var IJ_Pre: String
    var IJ_Vel_1st: String
    var IJ_Vel_2nd: String
    var IJ_Vel_3rd: String
    var IJ_Vel_4th: String
    var IJ_Vel_5th: String
    var IP_1: String
    var IP_2: String
    var IP_3: String
    var IP_4: String
    var IP_5: String
    var FB_P: String
    var FB_S: String
    var MEP: String
    var MEP_S: String
    var BP_1st: String
    var BP_2nd: String
    var SRS_1: String
    var SRS_2: String
    var SRP_1: String
    var SRP_2: String
    var V2P_T: String
    var Cooling_T: String
    var M_delay_T: String
    var PACK_P_1st: String
    var PACK_P_2nd: String
    var PACK_P_3rd: String
    var PACK_T_1st: String
    var PACK_T_2nd: String
    var PACK_T_3rd: String
    var Temp_set_Z0: String
    var Temp_set_Z1: String
    var Temp_set_Z2: String
    var Temp_set_Z3: String
    var receivedAt: String
//    var receiveTime: String
}
