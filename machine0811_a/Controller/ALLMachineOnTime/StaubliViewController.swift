//
//  StaubliViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2022/4/19.
//

import UIKit
import SocketIO

class StaubliViewController: UIViewController {

    
    var NowMachine: String = ""
    
    @IBOutlet weak var tbxInsStr: UILabel!
    @IBOutlet weak var tbxAbsStr: UILabel!
    @IBOutlet weak var receivedAtStr: UILabel!
    @IBOutlet weak var tbxKValueStr: UILabel!
    @IBOutlet weak var tbxSetSV: UILabel!
    @IBOutlet weak var tbxSetDVStr: UILabel!
    @IBOutlet weak var tbxSetMDVStr: UILabel!
    @IBOutlet weak var tbxSetACStr: UILabel!
    @IBOutlet weak var tbxSetAKStr: UILabel!
    
    @IBOutlet weak var bufAC_TimeStr: UILabel!
    @IBOutlet weak var strRevMsgStr: UILabel!
    @IBOutlet weak var IXAxisReadCountStr: UILabel!
    @IBOutlet weak var DataStr: UILabel!
    @IBOutlet weak var DCountStr: UILabel!
    @IBOutlet weak var RCountStr: UILabel!
    @IBOutlet weak var ExecutedCodeStr: UILabel!
    @IBOutlet weak var ReadStringStr: UILabel!
    @IBOutlet weak var LastCodeStr: UILabel!
    
    
    //Socket
    let manager = SocketManager(socketURL: URL(string: "http://140.135.97.69:8787")!, config: [.log(false), .forceWebsockets(true)])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let socket = manager.defaultSocket

        socket.on(clientEvent: .connect) { (data, _) in
            print("no socket connected")
            print("\(data.debugDescription)")

        }

        socket.on("7axis"){ (data, _) in
           // print(data)
            
            guard let dataInfo = data.first else { return }
            
            //對Socket所收到的資料進行解碼
            if let response: RobotSocketData = try? SocketParser.convert(data: dataInfo) {
                //print(response)
                
                //將資料放到頁面上
                self.tbxInsStr.text = "\(response.tbxIns)"
                self.tbxAbsStr.text = "\(response.tbxAbs)"
                self.receivedAtStr.text = "\(response.receivedAt)"
                self.tbxKValueStr.text = "\(response.tbxKValue)"
                self.tbxSetSV.text = "\(response.tbxSetSV)"
                self.tbxSetDVStr.text = "\(response.tbxSetDV)"
                self.tbxSetMDVStr.text = "\(response.tbxSetMDV)"
                self.tbxSetACStr.text = "\(response.tbxSetAC)"
                self.tbxSetAKStr.text = "\(response.tbxSetAK)"
                
                self.bufAC_TimeStr.text = "\(response.bufAC_Time)"
                self.strRevMsgStr.text = "\(response.strRevMsg)"
                self.IXAxisReadCountStr.text = "\(response.lXAxisReadCount)"
                self.DataStr.text = "\(response.Data)"
                self.DCountStr.text = "\(response.DCount)"
                self.RCountStr.text = "\(response.RCount)"
                self.ExecutedCodeStr.text = "\(response.ExecutedCase)"
                self.ReadStringStr.text = "\(response.ReadString)"
                self.LastCodeStr.text = "\(response.LastCode)"
                
                
                
            }
        }

        socket.connect()
    }
    



}

//資料解析格式
struct RobotSocketData: Codable {
    var tbxIns: String
    var tbxAbs: String
    var receivedAt: String
    var tbxKValue: String
    var tbxSetSV: String
    var tbxSetDV: String
    var tbxSetMDV: String
    var tbxSetAC: String
    var tbxSetAK: String

    var bufAC_Time: String
    var strRevMsg: String
    var lXAxisReadCount: String
    var Data: String
    var DCount: String
    var RCount: String
    var ExecutedCase: String
    var ReadString: String
    var LastCode: String
}
