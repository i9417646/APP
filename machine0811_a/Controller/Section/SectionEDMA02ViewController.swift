//
//  SectionEDMA02ViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2022/4/20.
//

import UIKit
import SocketIO
import Highcharts

class SectionEDMA02ViewController: UIViewController {

    @IBOutlet weak var Working_coordinatesXStr: UILabel!
    
    let manager = SocketManager(socketURL: URL(string: "http://140.135.97.69:8787")!, config: [.log(false), .forceWebsockets(true)])
    
    override func viewDidLoad() {
        super.viewDidLoad()

       print("356778")
        
        
//MARK: -Socket
        let socket = manager.defaultSocket
        socket.on(clientEvent: .connect) { (data, _) in
            print("台達電socket connected")
           // print("\(data.debugDescription)")
  
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
