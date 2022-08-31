//
//  robotViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2021/12/20.
//

import UIKit
import SocketIO

class robotViewController: UIViewController {

    //UI
    @IBOutlet weak var robot: UIImageView!
    
    @IBOutlet weak var XXXX: NSLayoutConstraint!
    
    //紀錄x軸距離尺寸
    var XXCM: Float = 0
    
    //socket
    let manager = SocketManager(socketURL: URL(string: "http://140.135.97.69:8787")!, config: [.log(false), .forceWebsockets(true)])
  

    
    @IBOutlet var robotView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        //sockeet
        let socket = manager.defaultSocket

        socket.on(clientEvent: .connect) { (data, _) in
            print("no socket connected")
            print("\(data.debugDescription)")

        }
        

        socket.on("7axis"){ [self] (data, _) in
           // print(data)
            
            guard let dataInfo = data.first else { return }
            
            if let response: RobotCoorSocketData = try? SocketParser.convert(data: dataInfo) {
                print(response)
                
                
       //         robot.layer.zPosition = 1
   
                
                
                let XAxis: Float = Float(response.lXAxisReadCount) ?? 0.0
                
                //大概換算一下大約尺寸
                let robotXX: Float = XAxis * Float(self.view.frame.width) * 14 / 30 / 5999499
                
                
                print(robotXX)
                
                self.XXCM = robotXX
                //更改手臂的x軸大小
                self.XXXX.constant = CGFloat(XXCM)
    //            robot.centerYAnchor.x =
                
//                self.robot.leadingAnchor.constraint(equalTo: self.robotView.leadingAnchor, constant: CGFloat(robotXX)).isActive = true
//                UIView.animate(withDuration: 0.5, animations: {
//                    self.XXXX.constant = CGFloat(robotXX)
//                    self.robot.leadingAnchor.constraint(equalTo: self.robotView.leadingAnchor, constant: CGFloat(robotXX)).isActive = true
//                })
//
//                self.robot.translatesAutoresizingMaskIntoConstraints = false
//
//                self.robot.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: CGFloat(robotX)).isActive = true
                //self.robotX(XAxisStr: response.lXAxisReadCount)


                
            }
        }

        socket.connect()


        
        
    }
    
    //沒使用了
    func robotX(XAxisStr: String) {
        robot.layer.zPosition = 1
        print(self.view.frame.width)
        
        let XAxis: Float = Float(XAxisStr) ?? 0.0
        
        let robotXX: Float = XAxis * Float(self.view.frame.width) * 14 / 30 / 5999499
        
        self.robot.translatesAutoresizingMaskIntoConstraints = false
        self.robot.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: CGFloat(robotXX)).isActive = true
    }
   
    
    
}
//資料格式架構
struct RobotCoorSocketData: Codable {
    var lXAxisReadCount: String
}
