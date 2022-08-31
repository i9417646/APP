//
//  SectionCNC01ViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2022/4/21.
//

import UIKit
import SocketIO
import Highcharts

class SectionCNC01ViewController: UIViewController {
    
    var firstData: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    
    
    let manager = SocketManager(socketURL: URL(string: "http://140.135.97.69:8787")!, config: [.log(false), .forceWebsockets(true)])

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
        
        
        
        
        
//MARK: -Focasell_Socket
        
       let socket = manager.defaultSocket
       socket.on(clientEvent: .connect) { (data, _) in
           print("華瑞socket connected")
           print("\(data.debugDescription)")
 
       }
        
        
        socket.on("CNC_VMC_860"){ (data, _) in
            print("華瑞：\(data)")
             
            guard let dataInfo = data.first else { return }
            
            //注意轉速設定值
            if let response: TCCCSocketData = try? SocketParser.convert(data: dataInfo) {
                print(response)
            }
        }
        socket.connect()
    }
    

    func viewOptions() ->  HIOptions {

        let options = HIOptions()

        let title = HITitle()
         title.text = ""
         options.title = title

        let xAxis = HIXAxis()
         xAxis.visible = false
         xAxis.tickInterval = 1
         xAxis.accessibility = HIAccessibility()
         xAxis.accessibility.rangeDescription = "Range: 1 to 10"
         options.xAxis = [xAxis]

        let yAxis = HIYAxis()
         yAxis.visible = false
         yAxis.minorTickInterval = 0.1
         yAxis.accessibility = HIAccessibility()
         yAxis.accessibility.rangeDescription = "Range: 0.1 to 1000"
         options.yAxis = [yAxis]


        //關掉標籤
        let tooltip = HITooltip()
         tooltip.enabled = false
         options.tooltip = tooltip
        
   
        //關閉有右上功能鍵
        let exporting = HIExporting()
         exporting.enabled = false
         options.exporting = exporting
        
        
        //浮水印
        let credict = HICredits()
         credict.enabled = false
         options.credits = credict
        
        //關掉分類標籤
        let legend = HILegend()
         legend.enabled = false
         options.legend = legend

        
        return  options
    }

}
