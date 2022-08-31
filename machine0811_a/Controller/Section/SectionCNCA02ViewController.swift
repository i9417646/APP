//
//  SectionCNCA02ViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2022/4/18.
//

import UIKit
import SocketIO
import Highcharts

class SectionCNCA02ViewController: UIViewController {
    
    var machineName: String = ""
    
//MARK: -台達電資料

    //主軸轉速暫存陣列
    var A02spindleSpeedArray: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    //進幾速率暫存陣列
    var A02feedArray: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    //加速規x,y,z暫存陣列
    var A02fftxArray: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var A02fftyArray: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var A02fftzArray: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    
    @IBOutlet weak var comSpindleSpeed: UILabel!
    @IBOutlet weak var comfeed: UILabel!

    @IBOutlet weak var A02NowSpindleSpeed: UILabel!
    @IBOutlet weak var A02NowFeed: UILabel!
    @IBOutlet weak var A02NOWfftx: UILabel!
    @IBOutlet weak var A02NOWffty: UILabel!
    @IBOutlet weak var A02NOWfftz: UILabel!
    
    @IBOutlet weak var A02MachineCoordinatesX: UILabel!
    @IBOutlet weak var A02MachineCoordinatesY: UILabel!
    @IBOutlet weak var A02MachineCoordinatesZ: UILabel!
    

    @IBOutlet weak var A02spindleSpeedPlotView: UIView!
    @IBOutlet weak var A02feedPlotView: UIView!
    @IBOutlet weak var A02fftxPlotView: UIView!
    @IBOutlet weak var A02fftyPlotView: UIView!
    @IBOutlet weak var A02fftzPlotView: UIView!
    @IBOutlet weak var A02MachineCoordinatesXView: UIView!
    @IBOutlet weak var A02MachineCoordinatesYView: UIView!
    @IBOutlet weak var A02MachineCoordinatesZXiew: UIView!
    
    
    let manager = SocketManager(socketURL: URL(string: "http://140.135.97.69:8787")!, config: [.log(false), .forceWebsockets(true)])


    override func viewDidLoad() {
        super.viewDidLoad()
        
     

//MARK:-CNCA_02主軸轉速趨勢圖表
        let A02SSchartView = HIChartView(frame: view.bounds)

        let A02SSoptions = HIOptions()

        let A02SStitle = HITitle()
        A02SStitle.text = ""
        A02SSoptions.title = A02SStitle

        let A02SSxAxis = HIXAxis()
        A02SSxAxis.visible = false
        A02SSxAxis.tickInterval = 1
        A02SSxAxis.accessibility = HIAccessibility()
        A02SSxAxis.accessibility.rangeDescription = "Range: 1 to 10"
        A02SSoptions.xAxis = [A02SSxAxis]

        let A02SSyAxis = HIYAxis()
        A02SSyAxis.visible = false
        A02SSyAxis.minorTickInterval = 0.1
        A02SSyAxis.accessibility = HIAccessibility()
        A02SSyAxis.accessibility.rangeDescription = "Range: 0.1 to 1000"
        A02SSoptions.yAxis = [A02SSyAxis]

        

        let A02SSseries = HISeries()
        A02SSseries.data = self.A02spindleSpeedArray
        A02SSseries.marker  = HIMarker()
//          A02SSseries.marker.enabled = false
        A02SSseries.marker.radius = 2.6
        A02SSseries.lineWidth = 1
        A02SSseries.color = HIColor(hexValue: "6b79e4")

        //關掉標籤
        let A02SStooltip = HITooltip()
        A02SStooltip.enabled = false
        A02SSoptions.tooltip = A02SStooltip
        
   
        //關閉有右上功能鍵
        let A02SSexporting = HIExporting()
        A02SSexporting.enabled = false
        A02SSoptions.exporting = A02SSexporting
        
        
        //浮水印
        let A02SScredict = HICredits()
        A02SScredict.enabled = false
        A02SSoptions.credits = A02SScredict
        
        //關掉分類標籤
        let A02SSlegend = HILegend()
        A02SSlegend.enabled = false
        A02SSoptions.legend = A02SSlegend

        A02SSoptions.series = [A02SSseries]

        A02SSchartView.options = A02SSoptions
        
        A02SSchartView.translatesAutoresizingMaskIntoConstraints = false

        self.A02spindleSpeedPlotView.addSubview(A02SSchartView)
        A02SSchartView.leadingAnchor.constraint(equalTo: A02spindleSpeedPlotView.leadingAnchor, constant: 0).isActive = true
        A02SSchartView.topAnchor.constraint(equalTo: A02spindleSpeedPlotView.topAnchor, constant: 0).isActive = true
        A02SSchartView.trailingAnchor.constraint(equalTo: A02spindleSpeedPlotView.trailingAnchor, constant: 0).isActive = true
        A02SSchartView.bottomAnchor.constraint(equalTo: A02spindleSpeedPlotView.bottomAnchor, constant: 0).isActive = true

        
        
//MARK:-A02近幾速率趨勢圖表
        
        let A02fchartView = HIChartView(frame: view.bounds)

        let A02foptions = HIOptions()

        let A02ftitle = HITitle()
        A02ftitle.text = ""
        A02foptions.title = A02ftitle

        let A02fxAxis = HIXAxis()
        A02fxAxis.visible = false
        A02fxAxis.tickInterval = 1
        A02fxAxis.accessibility = HIAccessibility()
        A02fxAxis.accessibility.rangeDescription = "Range: 1 to 10"
        A02foptions.xAxis = [A02fxAxis]

        let A02fyAxis = HIYAxis()
        A02fyAxis.visible = false
        A02fyAxis.minorTickInterval = 0.1
        A02fyAxis.accessibility = HIAccessibility()
        A02fyAxis.accessibility.rangeDescription = "Range: 0.1 to 1000"
        A02foptions.yAxis = [A02fyAxis]

        

        let A02fseries = HISeries()
        A02fseries.data = self.A02feedArray
        A02fseries.marker  = HIMarker()
//            A02fseries.marker.enabled = false
        A02fseries.marker.radius = 2.6
        A02fseries.lineWidth = 1
        A02fseries.color = HIColor(hexValue: "6b79e4")

        //關掉標籤
        let A02ftooltip = HITooltip()
        A02ftooltip.enabled = false
        A02foptions.tooltip = A02ftooltip
        
   
        //關閉有右上功能鍵
        let A02fexporting = HIExporting()
        A02fexporting.enabled = false
        A02foptions.exporting = A02fexporting
        
        
        //浮水印
        let A02fcredict = HICredits()
        A02fcredict.enabled = false
        A02foptions.credits = A02fcredict
        
        //關掉分類標籤
        let A02flegend = HILegend()
        A02flegend.enabled = false
        A02foptions.legend = A02flegend

        A02foptions.series = [A02fseries]

        A02fchartView.options = A02foptions
        
        A02fchartView.translatesAutoresizingMaskIntoConstraints = false

        self.A02feedPlotView.addSubview(A02fchartView)
        A02fchartView.leadingAnchor.constraint(equalTo: A02feedPlotView.leadingAnchor, constant: 0).isActive = true
        A02fchartView.topAnchor.constraint(equalTo: A02feedPlotView.topAnchor, constant: 0).isActive = true
        A02fchartView.trailingAnchor.constraint(equalTo: A02feedPlotView.trailingAnchor, constant: 0).isActive = true
        A02fchartView.bottomAnchor.constraint(equalTo: A02feedPlotView.bottomAnchor, constant: 0).isActive = true
        
        
        
//MARK: - A02fftX趨勢圖表
       
       let A02fftXchartView = HIChartView(frame: view.bounds)

       let A02fftXoptions = HIOptions()

       let A02fftXtitle = HITitle()
        A02fftXtitle.text = ""
        A02fftXoptions.title = A02fftXtitle

       let A02fftXxAxis = HIXAxis()
        A02fftXxAxis.visible = false
        A02fftXxAxis.tickInterval = 1
        A02fftXxAxis.accessibility = HIAccessibility()
        A02fftXxAxis.accessibility.rangeDescription = "Range: 1 to 10"
        A02fftXoptions.xAxis = [A02fftXxAxis]

       let A02fftXyAxis = HIYAxis()
        A02fftXyAxis.visible = false
        A02fftXyAxis.minorTickInterval = 0.1
        A02fftXyAxis.accessibility = HIAccessibility()
        A02fftXyAxis.accessibility.rangeDescription = "Range: 0.1 to 1000"
        A02fftXoptions.yAxis = [A02fftXyAxis]

       

       let A02fftXseries = HISeries()
        A02fftXseries.data = self.A02fftxArray
        A02fftXseries.marker  = HIMarker()
    //   A02fftXseries.marker.enabled = false
        A02fftXseries.marker.radius = 2.6
        A02fftXseries.lineWidth = 1
        A02fftXseries.color = HIColor(hexValue: "6b79e4")

       //關掉標籤
       let A02fftXtooltip = HITooltip()
        A02fftXtooltip.enabled = false
        A02fftXoptions.tooltip = A02fftXtooltip
       
  
       //關閉有右上功能鍵
       let A02fftXexporting = HIExporting()
        A02fftXexporting.enabled = false
        A02fftXoptions.exporting = A02fftXexporting
       
       
       //浮水印
       let A02fftXcredict = HICredits()
        A02fftXcredict.enabled = false
        A02fftXoptions.credits = A02fftXcredict
       
       //關掉分類標籤
       let A02fftXlegend = HILegend()
        A02fftXlegend.enabled = false
        A02fftXoptions.legend = A02fftXlegend

        A02fftXoptions.series = [A02fftXseries]

        A02fftXchartView.options = A02fftXoptions
       
        A02fftXchartView.translatesAutoresizingMaskIntoConstraints = false

       self.A02fftxPlotView.addSubview(A02fftXchartView)
        A02fftXchartView.leadingAnchor.constraint(equalTo: A02fftxPlotView.leadingAnchor, constant: 0).isActive = true
        A02fftXchartView.topAnchor.constraint(equalTo: A02fftxPlotView.topAnchor, constant: 0).isActive = true
        A02fftXchartView.trailingAnchor.constraint(equalTo: A02fftxPlotView.trailingAnchor, constant: 0).isActive = true
        A02fftXchartView.bottomAnchor.constraint(equalTo: A02fftxPlotView.bottomAnchor, constant: 0).isActive = true

        
        
//MARK: - A02fftY趨勢圖表
               
        let A02fftYchartView = HIChartView(frame: view.bounds)

        let A02fftYoptions = HIOptions()

       let A02fftYtitle = HITitle()
        A02fftYtitle.text = ""
        A02fftYoptions.title = A02fftYtitle

       let A02fftYxAxis = HIXAxis()
        A02fftYxAxis.visible = false
        A02fftYxAxis.tickInterval = 1
        A02fftYxAxis.accessibility = HIAccessibility()
        A02fftYxAxis.accessibility.rangeDescription = "Range: 1 to 10"
        A02fftYoptions.xAxis = [A02fftYxAxis]

       let A02fftYyAxis = HIYAxis()
        A02fftYyAxis.visible = false
        A02fftYyAxis.minorTickInterval = 0.1
        A02fftYyAxis.accessibility = HIAccessibility()
        A02fftYyAxis.accessibility.rangeDescription = "Range: 0.1 to 1000"
        A02fftYoptions.yAxis = [A02fftYyAxis]

       

       let A02fftYseries = HISeries()
        A02fftYseries.data = self.A02fftyArray
        A02fftYseries.marker  = HIMarker()
        //   fftXseries.marker.enabled = false
        A02fftYseries.marker.radius = 2.6
        A02fftYseries.lineWidth = 1
        A02fftYseries.color = HIColor(hexValue: "6b79e4")

        //關掉標籤
        let A02fftYtooltip = HITooltip()
        A02fftYtooltip.enabled = false
        A02fftYoptions.tooltip = A02fftYtooltip
           
      
        //關閉有右上功能鍵
        let A02fftYexporting = HIExporting()
        A02fftYexporting.enabled = false
        A02fftYoptions.exporting = A02fftYexporting
           
           
        //浮水印
        let A02fftYcredict = HICredits()
        A02fftYcredict.enabled = false
        A02fftYoptions.credits = A02fftYcredict
           
        //關掉分類標籤
        let A02fftYlegend = HILegend()
        A02fftYlegend.enabled = false
        A02fftYoptions.legend = A02fftYlegend

        A02fftYoptions.series = [A02fftYseries]

        A02fftYchartView.options = A02fftYoptions
           
        A02fftYchartView.translatesAutoresizingMaskIntoConstraints = false

        self.A02fftyPlotView.addSubview(A02fftYchartView)
        A02fftYchartView.leadingAnchor.constraint(equalTo: A02fftyPlotView.leadingAnchor, constant: 0).isActive = true
        A02fftYchartView.topAnchor.constraint(equalTo: A02fftyPlotView.topAnchor, constant: 0).isActive = true
        A02fftYchartView.trailingAnchor.constraint(equalTo: A02fftyPlotView.trailingAnchor, constant: 0).isActive = true
        A02fftYchartView.bottomAnchor.constraint(equalTo: A02fftyPlotView.bottomAnchor, constant: 0).isActive = true

        
        
//MARK: - A02fftZ趨勢圖表
           
       let A02fftZchartView = HIChartView(frame: view.bounds)

       let A02fftZoptions = HIOptions()

       let A02fftZtitle = HITitle()
        A02fftZtitle.text = ""
        A02fftZoptions.title = A02fftZtitle

       let A02fftZxAxis = HIXAxis()
        A02fftZxAxis.visible = false
        A02fftZxAxis.tickInterval = 1
        A02fftZxAxis.accessibility = HIAccessibility()
        A02fftZxAxis.accessibility.rangeDescription = "Range: 1 to 10"
        A02fftZoptions.xAxis = [A02fftZxAxis]

       let A02fftZyAxis = HIYAxis()
        A02fftZyAxis.visible = false
        A02fftZyAxis.minorTickInterval = 0.1
        A02fftZyAxis.accessibility = HIAccessibility()
        A02fftZyAxis.accessibility.rangeDescription = "Range: 0.1 to 1000"
        A02fftZoptions.yAxis = [A02fftZyAxis]

       

       let A02fftZseries = HISeries()
        A02fftZseries.data = self.A02fftzArray
        A02fftZseries.marker  = HIMarker()
    //   A02fftXseries.marker.enabled = false
        A02fftZseries.marker.radius = 2.6
        A02fftZseries.lineWidth = 1
        A02fftZseries.color = HIColor(hexValue: "6b79e4")

       //關掉標籤
       let A02fftZtooltip = HITooltip()
        A02fftZtooltip.enabled = false
        A02fftZoptions.tooltip = A02fftZtooltip
       
  
       //關閉有右上功能鍵
       let A02fftZexporting = HIExporting()
        A02fftZexporting.enabled = false
        A02fftZoptions.exporting = A02fftZexporting
       
       
       //浮水印
       let A02fftZcredict = HICredits()
        A02fftZcredict.enabled = false
        A02fftZoptions.credits = A02fftZcredict
       
       //關掉分類標籤
       let A02fftZlegend = HILegend()
        A02fftZlegend.enabled = false
        A02fftZoptions.legend = A02fftZlegend

        A02fftZoptions.series = [A02fftZseries]

        A02fftZchartView.options = A02fftZoptions
       
        A02fftZchartView.translatesAutoresizingMaskIntoConstraints = false

       self.A02fftzPlotView.addSubview(A02fftZchartView)
        A02fftZchartView.leadingAnchor.constraint(equalTo: A02fftzPlotView.leadingAnchor, constant: 0).isActive = true
        A02fftZchartView.topAnchor.constraint(equalTo: A02fftzPlotView.topAnchor, constant: 0).isActive = true
        A02fftZchartView.trailingAnchor.constraint(equalTo: A02fftzPlotView.trailingAnchor, constant: 0).isActive = true
        A02fftZchartView.bottomAnchor.constraint(equalTo: A02fftzPlotView.bottomAnchor, constant: 0).isActive = true
        
        
        
    //機械座標Ｘ
        let MechXOptions = viewOptions()

        let MechXseries = HISeries()
        MechXseries.data = self.A02feedArray
        MechXseries.marker  = HIMarker()
    //    MechXseries.marker.enabled = false
        MechXseries.marker.radius = 2.6
        MechXseries.lineWidth = 1
        MechXseries.color = HIColor(hexValue: "6b79e4")

        MechXOptions.series = [MechXseries]
        
        let MechXchartView = HIChartView(frame: view.bounds)
        
        MechXchartView.options = MechXOptions
       
        MechXchartView.translatesAutoresizingMaskIntoConstraints = false
        
        self.A02MachineCoordinatesXView.addSubview(MechXchartView)
        MechXchartView.leadingAnchor.constraint(equalTo: A02MachineCoordinatesXView.leadingAnchor, constant: 0).isActive = true
        MechXchartView.topAnchor.constraint(equalTo: A02MachineCoordinatesXView.topAnchor, constant: 0).isActive = true
        MechXchartView.trailingAnchor.constraint(equalTo: A02MachineCoordinatesXView.trailingAnchor, constant: 0).isActive = true
        MechXchartView.bottomAnchor.constraint(equalTo: A02MachineCoordinatesXView.bottomAnchor, constant: 0).isActive = true
        
        
    //機械座標Y
        let MechYOptions = viewOptions()

        let MechYseries = HISeries()
        MechYseries.data = self.A02feedArray
        MechYseries.marker  = HIMarker()
    //    MechYseries.marker.enabled = false
        MechYseries.marker.radius = 2.6
        MechYseries.lineWidth = 1
        MechYseries.color = HIColor(hexValue: "6b79e4")

        MechYOptions.series = [MechYseries]
        
        let MechYchartView = HIChartView(frame: view.bounds)
        
        MechYchartView.options = MechYOptions
       
        MechYchartView.translatesAutoresizingMaskIntoConstraints = false
        
        self.A02MachineCoordinatesYView.addSubview(MechYchartView)
        MechYchartView.leadingAnchor.constraint(equalTo: A02MachineCoordinatesYView.leadingAnchor, constant: 0).isActive = true
        MechYchartView.topAnchor.constraint(equalTo: A02MachineCoordinatesYView.topAnchor, constant: 0).isActive = true
        MechYchartView.trailingAnchor.constraint(equalTo: A02MachineCoordinatesYView.trailingAnchor, constant: 0).isActive = true
        MechYchartView.bottomAnchor.constraint(equalTo: A02MachineCoordinatesYView.bottomAnchor, constant: 0).isActive = true

        
        
    //機械座標Z
        let MechZOptions = viewOptions()

        let MechZseries = HISeries()
        MechZseries.data = self.A02feedArray
        MechZseries.marker  = HIMarker()
    //    MechZseries.marker.enabled = false
        MechZseries.marker.radius = 2.6
        MechZseries.lineWidth = 1
        MechZseries.color = HIColor(hexValue: "6b79e4")

        MechZOptions.series = [MechZseries]
        
        let MechZchartView = HIChartView(frame: view.bounds)
        
        MechZchartView.options = MechZOptions
       
        MechZchartView.translatesAutoresizingMaskIntoConstraints = false
        
        self.A02MachineCoordinatesZXiew.addSubview(MechZchartView)
        MechZchartView.leadingAnchor.constraint(equalTo: A02MachineCoordinatesZXiew.leadingAnchor, constant: 0).isActive = true
        MechZchartView.topAnchor.constraint(equalTo: A02MachineCoordinatesZXiew.topAnchor, constant: 0).isActive = true
        MechZchartView.trailingAnchor.constraint(equalTo: A02MachineCoordinatesZXiew.trailingAnchor, constant: 0).isActive = true
        MechZchartView.bottomAnchor.constraint(equalTo: A02MachineCoordinatesZXiew.bottomAnchor, constant: 0).isActive = true
        
        
        
//MARK: -Socket
        let socket = manager.defaultSocket
        socket.on(clientEvent: .connect) { (data, _) in
            print("台達電socket connected")
           // print("\(data.debugDescription)")
  
        }

        
        socket.on("DDS"){ (data, _) in
         //   print("台達電\(data)")
            
            guard let dataInfo = data.first else { return }
            
            if let response: A02SocketData = try? SocketParser.convert(data: dataInfo) {
                
           //     print("台達電： \(response)")
                self.comSpindleSpeed.text = "\(response.CommandspindleSpeed)"
                self.comfeed.text = "\(response.Commandfeed)"
                
                self.A02NowSpindleSpeed.text = "\(response.spindleSpeed) rpm"
                self.A02NowFeed.text = "\(response.feed) mm/s"
                self.A02NOWfftx.text = "\(response.fftx)"
                self.A02NOWffty.text = "\(response.ffty)"
                self.A02NOWfftz.text = "\(response.fftz)"
                self.A02MachineCoordinatesX.text = "\(response.MachineCoordinatesX)"
                self.A02MachineCoordinatesY.text = "\(response.MachineCoordinatesY)"
                self.A02MachineCoordinatesZ.text = "\(response.MachineCoordinatesZ)"
                
                //更新主軸轉速資料
                let A02SSNewData = HIData()
                A02SSNewData.y = NSNumber(value: Float(response.spindleSpeed) ?? 0)
                A02SSseries.addPoint(A02SSNewData)
                A02SSseries.removePoint(0)
                
                //更新進給速率資料
                let A02fNewData = HIData()
                A02fNewData.y = NSNumber(value: Float(response.feed) ?? 0)
                A02fseries.addPoint(A02fNewData)
                A02fseries.removePoint(0)
                
                //更新fftX資料
                let A02fftXNewData = HIData()
                A02fftXNewData.y = NSNumber(value: Float(response.fftx) ?? 0)
                A02fftXseries.addPoint(A02fftXNewData)
                A02fftXseries.removePoint(0)
                
                //更新fftY資料
                let A02fftYNewData = HIData()
                A02fftYNewData.y = NSNumber(value: Float(response.ffty) ?? 0)
                A02fftYseries.addPoint(A02fftYNewData)
                A02fftYseries.removePoint(0)
                
                //更新fftZ資料
                let A02fftZNewData = HIData()
                A02fftZNewData.y = NSNumber(value: Float(response.fftz) ?? 0)
                A02fftZseries.addPoint(A02fftZNewData)
                A02fftZseries.removePoint(0)
                
                //更新機械座標Ｘ資料
                let MechXNewData = HIData()
                MechXNewData.y = NSNumber(value: Float(response.MachineCoordinatesX) ?? 0)
                MechXseries.addPoint(MechXNewData)
                MechXseries.removePoint(0)

                //更新機械座標Y資料
                let MechYNewData = HIData()
                MechYNewData.y = NSNumber(value: Float(response.MachineCoordinatesY) ?? 0)
                MechYseries.addPoint(MechYNewData)
                MechYseries.removePoint(0)

                //更新機械座標Z資料
                let MechZNewData = HIData()
                MechZNewData.y = NSNumber(value: Float(response.MachineCoordinatesZ) ?? 0)
                MechZseries.addPoint(MechZNewData)
                MechZseries.removePoint(0)
                
                
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



struct A02SocketData: Codable {
    var CommandspindleSpeed: String
    var Commandfeed: String
    var spindleSpeed: String
    var feed: String
    var fftx: String
    var ffty: String
    var fftz: String
    var MachineCoordinatesX: String
    var MachineCoordinatesY: String
    var MachineCoordinatesZ: String
    var receivedAt: String
    

}
