//
//  Section_EDMA02ViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2022/4/20.
//

import UIKit
import SocketIO

class Section_EDMA02ViewController: UIViewController {
    
    
    let manager = SocketManager(socketURL: URL(string: "http://140.135.97.69:8787")!, config: [.log(false), .forceWebsockets(true)])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let socket = manager.defaultSocket
        socket.on(clientEvent: .connect) { (data, _) in
            print("先捷時間Sectonsocket connected")
           // print("\(data.debugDescription)")
  
        }
        
        socket.on("EDM_OSCARMAX"){ (data, _) in
            print(data)
            
        }

        // Do any additional setup after loading the view.
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
