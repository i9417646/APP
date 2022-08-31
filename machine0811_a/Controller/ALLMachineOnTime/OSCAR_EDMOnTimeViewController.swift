//
//  OSCAR_EDMOnTimeViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2022/4/19.
//

import UIKit
import SocketIO

class OSCAR_EDMOnTimeViewController: UIViewController {
    
    //現在選到的機台
    var NowMachine: String = ""
    
    @IBOutlet weak var Mechanical_coordinatesX: UILabel!
    @IBOutlet weak var Mechanical_coordinatesY: UILabel!
    @IBOutlet weak var Mechanical_coordinatesZ: UILabel!
    
    @IBOutlet weak var Working_coordinatesX: UILabel!
    @IBOutlet weak var Working_coordinatesY: UILabel!
    @IBOutlet weak var Working_coordinatesZ: UILabel!
    
    @IBOutlet weak var E_Code: UILabel!
    @IBOutlet weak var LV: UILabel!
    @IBOutlet weak var T_ON: UILabel!
    @IBOutlet weak var HV: UILabel!
    @IBOutlet weak var Gap: UILabel!
    @IBOutlet weak var JT: UILabel!
    @IBOutlet weak var Servo: UILabel!
    @IBOutlet weak var OB: UILabel!
    @IBOutlet weak var B_SPD: UILabel!
    @IBOutlet weak var B_DIS: UILabel!
    @IBOutlet weak var Drill_Mag: UILabel!
    
    @IBOutlet weak var Res_4: UILabel!
    @IBOutlet weak var Pol: UILabel!
    @IBOutlet weak var T_OFF: UILabel!
    @IBOutlet weak var Capic: UILabel!
    @IBOutlet weak var JD: UILabel!
    @IBOutlet weak var Speed: UILabel!
    @IBOutlet weak var Pulse: UILabel!
    @IBOutlet weak var NW: UILabel!
    @IBOutlet weak var E_SPD: UILabel!
    @IBOutlet weak var Drill_Slag: UILabel!
    @IBOutlet weak var Slope: UILabel!
    @IBOutlet weak var receivedAt: UILabel!
    
    @IBOutlet weak var State: UILabel!
    
    //Socket
    let manager = SocketManager(socketURL: URL(string: "http://140.135.97.69:8787")!, config: [.log(false), .forceWebsockets(true)])

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print("123456")
        
        let socket = manager.defaultSocket
        socket.on(clientEvent: .connect) { (data, _) in
            print("先捷時間ＡＬＬsocket connected")
           // print("\(data.debugDescription)")
  
        }
        
        socket.on("EDM_OSCARMAX"){ (data, _) in
            
            //print(data)
            
            guard let dataInfo = data.first else { return }
            
            //資料解碼
            if let response: OSCAR_EDMSocketData = try? SocketParser.convert(data: dataInfo) {
               // print(response)
                
                self.Mechanical_coordinatesX.text = "\(response.Working_coordinatesX)"
                self.Mechanical_coordinatesY.text = "\(response.Working_coordinatesY)"
                self.Mechanical_coordinatesZ.text = "\(response.Working_coordinatesZ)"
                
                self.Working_coordinatesX.text = "\(response.Mechanical_coordinatesX)"
                self.Working_coordinatesY.text = "\(response.Mechanical_coordinatesY)"
                self.Working_coordinatesZ.text = "\(response.Mechanical_coordinatesZ)"
                
                self.E_Code.text = "\(response.E_Code)"
                self.LV.text = "\(response.LV)"
                self.T_ON.text = "\(response.T_ON)"
                self.HV.text = "\(response.HV)"
                self.Gap.text = "\(response.Gap)"
                self.JT.text = "\(response.JT)"
                self.Servo.text = "\(response.Servo)"
                self.OB.text = "\(response.OB)"
                self.B_SPD.text = "\(response.B_SPD)"
                self.B_DIS.text = "\(response.B_DIS)"
                self.Drill_Mag.text = "\(response.Drill_Mag)"
                self.Res_4.text = "\(response.Res_4)"
                self.Pol.text = "\(response.Pol)"
                self.T_OFF.text = "\(response.T_OFF)"
                self.Capic.text = "\(response.Capic)"
                self.JD.text = "\(response.JD)"
                self.Speed.text = "\(response.Speed)"
                self.Pulse.text = "\(response.Pulse)"
                self.NW.text = "\(response.NW)"
                self.E_SPD.text = "\(response.E_SPD)"
                self.Drill_Slag.text = "\(response.Drill_Slag)"
                self.Slope.text = "\(response.Slope)"
                self.receivedAt.text = "\(response.receivedAt)"
                self.State.text = "\(response.State)"
            }
        }
        //Socket連線
        socket.connect()
        
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

//由Socket所收到的資料長像
struct OSCAR_EDMSocketData: Codable {
    var Working_coordinatesX: String
    var Working_coordinatesY: String
    var Working_coordinatesZ: String
    var Mechanical_coordinatesX: String
    var Mechanical_coordinatesY: String
    var Mechanical_coordinatesZ: String
    var E_Code: String
    var LV: String
    var T_ON: String
    var HV: String
    var Gap: String
    var JT: String
    var Servo: String
    var OB: String
    var B_SPD: String
    var B_DIS: String
    var Drill_Mag: String
    var Res_4: String
    var Pol: String
    var T_OFF: String
    var Capic: String
    var JD: String
    var Speed: String
    var Pulse: String
    var NW: String
    var E_SPD: String
    var Drill_Slag: String
    var Slope: String
    var receivedAt: String
    var State: String
}
