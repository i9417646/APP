//
//  SectionEDMA02ViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2022/4/20.
//

import UIKit
import SocketIO

class SectionEDMA02ViewController: UIViewController {
    
    let manager = SocketManager(socketURL: URL(string: "http://140.135.97.69:8787")!, config: [.log(false), .forceWebsockets(true)])

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print("166666")
        
        let socket = manager.defaultSocket
        socket.on(clientEvent: .connect) { (data, _) in
            print("先捷時間ＡＬＬsocket connected")
           // print("\(data.debugDescription)")
  
        }
        
        socket.on("EDM_OSCARMAX"){ (data, _) in
            
            print(data)
            
            guard let dataInfo = data.first else { return }
            
            if let response: OSCAR_EDMSocketData = try? SocketParser.convert(data: dataInfo) {
                print(response)
            }
              
        }
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
