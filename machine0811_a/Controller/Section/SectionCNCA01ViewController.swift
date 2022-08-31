//
//  SectionCNCA01ViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2022/4/18.
//

import UIKit
import SocketIO
import Highcharts

class SectionCNCA01ViewController: UIViewController {
    
    
//MARK: -台中精機資料
    //主軸轉速暫存陣列
    var spindleSpeedArray: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    //進幾速率暫存陣列
    var feedArray: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    //加速規x,y,z暫存陣列
    var fftxArray: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var fftyArray: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var fftzArray: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    
    @IBOutlet weak var comSpindleSpeed: UILabel!
    @IBOutlet weak var comfeed: UILabel!
    
    
    @IBOutlet weak var NOWSpindleSpeed: UILabel!
    @IBOutlet weak var NOWFeed: UILabel!
    @IBOutlet weak var NOWfftx: UILabel!
    @IBOutlet weak var NOWffty: UILabel!
    @IBOutlet weak var NOWfftz: UILabel!
    @IBOutlet weak var NOWMachineCoordinatesX: UILabel!
    @IBOutlet weak var NOWMachineCoordinatesY: UILabel!
    @IBOutlet weak var NOWMachineCoordinatesZ: UILabel!
    
    @IBOutlet weak var spindleSpeedPlotView: UIView!
    @IBOutlet weak var feedPlotView: UIView!
    @IBOutlet weak var fftxPlotView: UIView!
    @IBOutlet weak var fftyPlotView: UIView!
    @IBOutlet weak var fftzPlotView: UIView!
    @IBOutlet weak var MachineCoordinatesXView: UIView!
    @IBOutlet weak var MachineCoordinatesYView: UIView!
    @IBOutlet weak var MachineCoordinatesZView: UIView!
    
    
    let manager = SocketManager(socketURL: URL(string: "http://140.135.97.69:8787")!, config: [.log(false), .forceWebsockets(true)])

    override func viewDidLoad() {
        super.viewDidLoad()

//MARK:-主軸轉速趨勢圖表
        let SSchartView = HIChartView(frame: view.bounds)

        let SSoptions = HIOptions()

        let SStitle = HITitle()
        SStitle.text = ""
        SSoptions.title = SStitle

        let SSxAxis = HIXAxis()
        SSxAxis.visible = false
        SSxAxis.tickInterval = 1
        SSxAxis.accessibility = HIAccessibility()
        SSxAxis.accessibility.rangeDescription = "Range: 1 to 10"
        SSoptions.xAxis = [SSxAxis]

        let SSyAxis = HIYAxis()
        SSyAxis.visible = false
        SSyAxis.minorTickInterval = 0.1
        SSyAxis.accessibility = HIAccessibility()
        SSyAxis.accessibility.rangeDescription = "Range: 0.1 to 1000"
        SSoptions.yAxis = [SSyAxis]

        

        let SSseries = HISeries()
        SSseries.data = self.spindleSpeedArray
        SSseries.marker  = HIMarker()
//          SSseries.marker.enabled = false
        SSseries.marker.radius = 2.6
        SSseries.lineWidth = 1
        SSseries.color = HIColor(hexValue: "6b79e4")

        //關掉標籤
        let SStooltip = HITooltip()
        SStooltip.enabled = false
        SSoptions.tooltip = SStooltip
        
   
        //關閉有右上功能鍵
        let SSexporting = HIExporting()
        SSexporting.enabled = false
        SSoptions.exporting = SSexporting
        
        
        //浮水印
        let SScredict = HICredits()
        SScredict.enabled = false
        SSoptions.credits = SScredict
        
        //關掉分類標籤
        let SSlegend = HILegend()
        SSlegend.enabled = false
        SSoptions.legend = SSlegend

        SSoptions.series = [SSseries]

        SSchartView.options = SSoptions
        
        SSchartView.translatesAutoresizingMaskIntoConstraints = false

        self.spindleSpeedPlotView.addSubview(SSchartView)
        SSchartView.leadingAnchor.constraint(equalTo: spindleSpeedPlotView.leadingAnchor, constant: 0).isActive = true
        SSchartView.topAnchor.constraint(equalTo: spindleSpeedPlotView.topAnchor, constant: 0).isActive = true
        SSchartView.trailingAnchor.constraint(equalTo: spindleSpeedPlotView.trailingAnchor, constant: 0).isActive = true
        SSchartView.bottomAnchor.constraint(equalTo: spindleSpeedPlotView.bottomAnchor, constant: 0).isActive = true
    

        
        
        
//MARK:-近幾速率趨勢圖表
        
        let fchartView = HIChartView(frame: view.bounds)

        let foptions = HIOptions()

        let ftitle = HITitle()
        ftitle.text = ""
        foptions.title = ftitle

        let fxAxis = HIXAxis()
        fxAxis.visible = false
        fxAxis.tickInterval = 1
        fxAxis.accessibility = HIAccessibility()
        fxAxis.accessibility.rangeDescription = "Range: 1 to 10"
        foptions.xAxis = [fxAxis]

        let fyAxis = HIYAxis()
        fyAxis.visible = false
        fyAxis.minorTickInterval = 0.1
        fyAxis.accessibility = HIAccessibility()
        fyAxis.accessibility.rangeDescription = "Range: 0.1 to 1000"
        foptions.yAxis = [fyAxis]

        

        let fseries = HISeries()
        fseries.data = self.feedArray
        fseries.marker  = HIMarker()
//            fseries.marker.enabled = false
        fseries.marker.radius = 2.6
        fseries.lineWidth = 1
        fseries.color = HIColor(hexValue: "6b79e4")

        //關掉標籤
        let ftooltip = HITooltip()
        ftooltip.enabled = false
        foptions.tooltip = ftooltip
        
   
        //關閉有右上功能鍵
        let fexporting = HIExporting()
        fexporting.enabled = false
        foptions.exporting = fexporting
        
        
        //浮水印
        let fcredict = HICredits()
        fcredict.enabled = false
        foptions.credits = fcredict
        
        //關掉分類標籤
        let flegend = HILegend()
        flegend.enabled = false
        foptions.legend = flegend

        foptions.series = [fseries]

        fchartView.options = foptions
        
        fchartView.translatesAutoresizingMaskIntoConstraints = false

        self.feedPlotView.addSubview(fchartView)
        fchartView.leadingAnchor.constraint(equalTo: feedPlotView.leadingAnchor, constant: 0).isActive = true
        fchartView.topAnchor.constraint(equalTo: feedPlotView.topAnchor, constant: 0).isActive = true
        fchartView.trailingAnchor.constraint(equalTo: feedPlotView.trailingAnchor, constant: 0).isActive = true
        fchartView.bottomAnchor.constraint(equalTo: feedPlotView.bottomAnchor, constant: 0).isActive = true
        
        
 //MARK: - fftX趨勢圖表
        
        let fftXchartView = HIChartView(frame: view.bounds)

        let fftXoptions = HIOptions()

        let fftXtitle = HITitle()
        fftXtitle.text = ""
        fftXoptions.title = fftXtitle

        let fftXxAxis = HIXAxis()
        fftXxAxis.visible = false
        fftXxAxis.tickInterval = 1
        fftXxAxis.accessibility = HIAccessibility()
        fftXxAxis.accessibility.rangeDescription = "Range: 1 to 10"
        fftXoptions.xAxis = [fftXxAxis]

        let fftXyAxis = HIYAxis()
        fftXyAxis.visible = false
        fftXyAxis.minorTickInterval = 0.1
        fftXyAxis.accessibility = HIAccessibility()
        fftXyAxis.accessibility.rangeDescription = "Range: 0.1 to 1000"
        fftXoptions.yAxis = [fftXyAxis]

        

        let fftXseries = HISeries()
        fftXseries.data = self.fftxArray
        fftXseries.marker  = HIMarker()
     //   fftXseries.marker.enabled = false
        fftXseries.marker.radius = 2.6
        fftXseries.lineWidth = 1
        fftXseries.color = HIColor(hexValue: "6b79e4")

        //關掉標籤
        let fftXtooltip = HITooltip()
        fftXtooltip.enabled = false
        fftXoptions.tooltip = fftXtooltip
        
   
        //關閉有右上功能鍵
        let fftXexporting = HIExporting()
        fftXexporting.enabled = false
        fftXoptions.exporting = fftXexporting
        
        
        //浮水印
        let fftXcredict = HICredits()
        fftXcredict.enabled = false
        fftXoptions.credits = fftXcredict
        
        //關掉分類標籤
        let fftXlegend = HILegend()
        fftXlegend.enabled = false
        fftXoptions.legend = fftXlegend

        fftXoptions.series = [fftXseries]

        fftXchartView.options = fftXoptions
        
        fftXchartView.translatesAutoresizingMaskIntoConstraints = false

        self.fftxPlotView.addSubview(fftXchartView)
        fftXchartView.leadingAnchor.constraint(equalTo: fftxPlotView.leadingAnchor, constant: 0).isActive = true
        fftXchartView.topAnchor.constraint(equalTo: fftxPlotView.topAnchor, constant: 0).isActive = true
        fftXchartView.trailingAnchor.constraint(equalTo: fftxPlotView.trailingAnchor, constant: 0).isActive = true
        fftXchartView.bottomAnchor.constraint(equalTo: fftxPlotView.bottomAnchor, constant: 0).isActive = true
    
        
//MARK: - fftY趨勢圖表
               
        let fftYchartView = HIChartView(frame: view.bounds)

        let fftYoptions = HIOptions()

       let fftYtitle = HITitle()
       fftYtitle.text = ""
       fftYoptions.title = fftYtitle

       let fftYxAxis = HIXAxis()
       fftYxAxis.visible = false
       fftYxAxis.tickInterval = 1
       fftYxAxis.accessibility = HIAccessibility()
       fftYxAxis.accessibility.rangeDescription = "Range: 1 to 10"
       fftYoptions.xAxis = [fftYxAxis]

       let fftYyAxis = HIYAxis()
       fftYyAxis.visible = false
       fftYyAxis.minorTickInterval = 0.1
       fftYyAxis.accessibility = HIAccessibility()
       fftYyAxis.accessibility.rangeDescription = "Range: 0.1 to 1000"
       fftYoptions.yAxis = [fftYyAxis]

       

       let fftYseries = HISeries()
       fftYseries.data = self.fftyArray
       fftYseries.marker  = HIMarker()
        //   fftXseries.marker.enabled = false
        fftYseries.marker.radius = 2.6
        fftYseries.lineWidth = 1
        fftYseries.color = HIColor(hexValue: "6b79e4")

        //關掉標籤
        let fftYtooltip = HITooltip()
        fftYtooltip.enabled = false
        fftYoptions.tooltip = fftYtooltip
           
      
        //關閉有右上功能鍵
        let fftYexporting = HIExporting()
        fftYexporting.enabled = false
        fftYoptions.exporting = fftYexporting
           
           
        //浮水印
        let fftYcredict = HICredits()
        fftYcredict.enabled = false
        fftYoptions.credits = fftYcredict
           
        //關掉分類標籤
        let fftYlegend = HILegend()
        fftYlegend.enabled = false
        fftYoptions.legend = fftYlegend

        fftYoptions.series = [fftYseries]

        fftYchartView.options = fftYoptions
           
        fftYchartView.translatesAutoresizingMaskIntoConstraints = false

        self.fftyPlotView.addSubview(fftYchartView)
        fftYchartView.leadingAnchor.constraint(equalTo: fftyPlotView.leadingAnchor, constant: 0).isActive = true
        fftYchartView.topAnchor.constraint(equalTo: fftyPlotView.topAnchor, constant: 0).isActive = true
        fftYchartView.trailingAnchor.constraint(equalTo: fftyPlotView.trailingAnchor, constant: 0).isActive = true
        fftYchartView.bottomAnchor.constraint(equalTo: fftyPlotView.bottomAnchor, constant: 0).isActive = true
        
        
        
        
//MARK: - fftZ趨勢圖表
           
       let fftZchartView = HIChartView(frame: view.bounds)

       let fftZoptions = HIOptions()

       let fftZtitle = HITitle()
       fftZtitle.text = ""
       fftZoptions.title = fftZtitle

       let fftZxAxis = HIXAxis()
       fftZxAxis.visible = false
       fftZxAxis.tickInterval = 1
       fftZxAxis.accessibility = HIAccessibility()
       fftZxAxis.accessibility.rangeDescription = "Range: 1 to 10"
       fftZoptions.xAxis = [fftZxAxis]

       let fftZyAxis = HIYAxis()
       fftZyAxis.visible = false
       fftZyAxis.minorTickInterval = 0.1
       fftZyAxis.accessibility = HIAccessibility()
       fftZyAxis.accessibility.rangeDescription = "Range: 0.1 to 1000"
       fftZoptions.yAxis = [fftZyAxis]

       

       let fftZseries = HISeries()
       fftZseries.data = self.fftzArray
       fftZseries.marker  = HIMarker()
    //   fftXseries.marker.enabled = false
       fftZseries.marker.radius = 2.6
       fftZseries.lineWidth = 1
       fftZseries.color = HIColor(hexValue: "6b79e4")

       //關掉標籤
       let fftZtooltip = HITooltip()
       fftZtooltip.enabled = false
       fftZoptions.tooltip = fftZtooltip
       
  
       //關閉有右上功能鍵
       let fftZexporting = HIExporting()
       fftZexporting.enabled = false
       fftZoptions.exporting = fftZexporting
       
       
       //浮水印
       let fftZcredict = HICredits()
       fftZcredict.enabled = false
       fftZoptions.credits = fftZcredict
       
       //關掉分類標籤
       let fftZlegend = HILegend()
       fftZlegend.enabled = false
       fftZoptions.legend = fftZlegend

       fftZoptions.series = [fftZseries]

       fftZchartView.options = fftZoptions
       
       fftZchartView.translatesAutoresizingMaskIntoConstraints = false

       self.fftzPlotView.addSubview(fftZchartView)
       fftZchartView.leadingAnchor.constraint(equalTo: fftzPlotView.leadingAnchor, constant: 0).isActive = true
       fftZchartView.topAnchor.constraint(equalTo: fftzPlotView.topAnchor, constant: 0).isActive = true
       fftZchartView.trailingAnchor.constraint(equalTo: fftyPlotView.trailingAnchor, constant: 0).isActive = true
       fftZchartView.bottomAnchor.constraint(equalTo: fftzPlotView.bottomAnchor, constant: 0).isActive = true
        
        

        
        
        
//MARK: - X軸趨勢圖表
           
       let coorXchartView = HIChartView(frame: view.bounds)

       let coorXoptions = HIOptions()

       let coorXtitle = HITitle()
        coorXtitle.text = ""
        coorXoptions.title = coorXtitle

       let coorXxAxis = HIXAxis()
        coorXxAxis.visible = false
        coorXxAxis.tickInterval = 1
        coorXxAxis.accessibility = HIAccessibility()
        coorXxAxis.accessibility.rangeDescription = "Range: 1 to 10"
        coorXoptions.xAxis = [coorXxAxis]

       let coorXyAxis = HIYAxis()
        coorXyAxis.visible = false
        coorXyAxis.minorTickInterval = 0.1
        coorXyAxis.accessibility = HIAccessibility()
        coorXyAxis.accessibility.rangeDescription = "Range: 0.1 to 1000"
        coorXoptions.yAxis = [coorXyAxis]

       

       let coorXseries = HISeries()
        coorXseries.data = self.fftzArray
        coorXseries.marker  = HIMarker()
    //   coorXseries.marker.enabled = false
        coorXseries.marker.radius = 2.6
        coorXseries.lineWidth = 1
        coorXseries.color = HIColor(hexValue: "6b79e4")

       //關掉標籤
       let coorXtooltip = HITooltip()
        coorXtooltip.enabled = false
        coorXoptions.tooltip = coorXtooltip
       
  
       //關閉有右上功能鍵
       let coorXexporting = HIExporting()
        coorXexporting.enabled = false
        coorXoptions.exporting = coorXexporting
       
       
       //浮水印
       let coorXcredict = HICredits()
        coorXcredict.enabled = false
        coorXoptions.credits = coorXcredict
       
       //關掉分類標籤
       let coorXlegend = HILegend()
        coorXlegend.enabled = false
        coorXoptions.legend = coorXlegend

        coorXoptions.series = [coorXseries]

        coorXchartView.options = coorXoptions
       
        coorXchartView.translatesAutoresizingMaskIntoConstraints = false

       self.MachineCoordinatesXView.addSubview(coorXchartView)
        coorXchartView.leadingAnchor.constraint(equalTo: MachineCoordinatesXView.leadingAnchor, constant: 0).isActive = true
        coorXchartView.topAnchor.constraint(equalTo: MachineCoordinatesXView.topAnchor, constant: 0).isActive = true
        coorXchartView.trailingAnchor.constraint(equalTo: MachineCoordinatesXView.trailingAnchor, constant: 0).isActive = true
        coorXchartView.bottomAnchor.constraint(equalTo: MachineCoordinatesXView.bottomAnchor, constant: 0).isActive = true
        
        
        
        
//MARK: - Y軸趨勢圖表
           
       let coorYchartView = HIChartView(frame: view.bounds)

       let coorYoptions = HIOptions()

       let coorYtitle = HITitle()
        coorYtitle.text = ""
        coorYoptions.title = coorYtitle

       let coorYxAxis = HIXAxis()
        coorYxAxis.visible = false
        coorYxAxis.tickInterval = 1
        coorYxAxis.accessibility = HIAccessibility()
        coorYxAxis.accessibility.rangeDescription = "Range: 1 to 10"
        coorYoptions.xAxis = [coorYxAxis]

       let coorYyAxis = HIYAxis()
        coorYyAxis.visible = false
        coorYyAxis.minorTickInterval = 0.1
        coorYyAxis.accessibility = HIAccessibility()
        coorYyAxis.accessibility.rangeDescription = "Range: 0.1 to 1000"
        coorYoptions.yAxis = [coorYyAxis]

       

       let coorYseries = HISeries()
        coorYseries.data = self.fftzArray
        coorYseries.marker  = HIMarker()
    //   coorYseries.marker.enabled = false
        coorYseries.marker.radius = 2.6
        coorYseries.lineWidth = 1
        coorYseries.color = HIColor(hexValue: "6b79e4")

       //關掉標籤
       let coorYtooltip = HITooltip()
        coorYtooltip.enabled = false
        coorYoptions.tooltip = coorYtooltip
       
  
       //關閉有右上功能鍵
       let coorYexporting = HIExporting()
        coorYexporting.enabled = false
        coorYoptions.exporting = coorYexporting
       
       
       //浮水印
       let coorYcredict = HICredits()
        coorYcredict.enabled = false
        coorYoptions.credits = coorYcredict
       
       //關掉分類標籤
       let coorYlegend = HILegend()
        coorYlegend.enabled = false
        coorYoptions.legend = coorYlegend

        coorYoptions.series = [coorYseries]

        coorYchartView.options = coorYoptions
       
        coorYchartView.translatesAutoresizingMaskIntoConstraints = false

       self.MachineCoordinatesYView.addSubview(coorYchartView)
        coorYchartView.leadingAnchor.constraint(equalTo: MachineCoordinatesYView.leadingAnchor, constant: 0).isActive = true
        coorYchartView.topAnchor.constraint(equalTo: MachineCoordinatesYView.topAnchor, constant: 0).isActive = true
        coorYchartView.trailingAnchor.constraint(equalTo: MachineCoordinatesYView.trailingAnchor, constant: 0).isActive = true
        coorYchartView.bottomAnchor.constraint(equalTo: MachineCoordinatesYView.bottomAnchor, constant: 0).isActive = true

 
        
//MARK: - Z軸趨勢圖表
           
       let coorZchartView = HIChartView(frame: view.bounds)

       let coorZoptions = HIOptions()

       let coorZtitle = HITitle()
        coorZtitle.text = ""
        coorZoptions.title = coorZtitle

       let coorZxAxis = HIXAxis()
        coorZxAxis.visible = false
        coorZxAxis.tickInterval = 1
        coorZxAxis.accessibility = HIAccessibility()
        coorZxAxis.accessibility.rangeDescription = "Range: 1 to 10"
        coorZoptions.xAxis = [coorZxAxis]

       let coorZyAxis = HIYAxis()
        coorZyAxis.visible = false
        coorZyAxis.minorTickInterval = 0.1
        coorZyAxis.accessibility = HIAccessibility()
        coorZyAxis.accessibility.rangeDescription = "Range: 0.1 to 1000"
        coorZoptions.yAxis = [coorZyAxis]

       

       let coorZseries = HISeries()
        coorZseries.data = self.fftzArray
        coorZseries.marker  = HIMarker()
    //   coorZseries.marker.enabled = false
        coorZseries.marker.radius = 2.6
        coorZseries.lineWidth = 1
        coorZseries.color = HIColor(hexValue: "6b79e4")

       //關掉標籤
       let coorZtooltip = HITooltip()
        coorZtooltip.enabled = false
        coorZoptions.tooltip = coorZtooltip
       
  
       //關閉有右上功能鍵
       let coorZexporting = HIExporting()
        coorZexporting.enabled = false
        coorZoptions.exporting = coorZexporting
       
       
       //浮水印
       let coorZcredict = HICredits()
        coorZcredict.enabled = false
        coorZoptions.credits = coorZcredict
       
       //關掉分類標籤
       let coorZlegend = HILegend()
        coorZlegend.enabled = false
        coorZoptions.legend = coorZlegend

        coorZoptions.series = [coorZseries]

        coorZchartView.options = coorZoptions
       
        coorZchartView.translatesAutoresizingMaskIntoConstraints = false

       self.MachineCoordinatesZView.addSubview(coorZchartView)
        coorZchartView.leadingAnchor.constraint(equalTo: MachineCoordinatesZView.leadingAnchor, constant: 0).isActive = true
        coorZchartView.topAnchor.constraint(equalTo: MachineCoordinatesZView.topAnchor, constant: 0).isActive = true
        coorZchartView.trailingAnchor.constraint(equalTo: MachineCoordinatesZView.trailingAnchor, constant: 0).isActive = true
        coorZchartView.bottomAnchor.constraint(equalTo: MachineCoordinatesZView.bottomAnchor, constant: 0).isActive = true

        
        
        
//MARK: -Socket
        
        let socket = manager.defaultSocket
        socket.on(clientEvent: .connect) { (data, _) in
            print("台中精機：socket connected")
            print("\(data.debugDescription)")
  
        }
        socket.on("CNC_Vcenter_p76"){ (data, _) in
   //         print("台中精機：\(data)")
            
            guard let dataInfo = data.first else { return }
            
            if let response: TCCCSocketData = try? SocketParser.convert(data: dataInfo) {
                
   //             print("台中精機：\(response)")
                
                self.comSpindleSpeed.text = "\(response.CommandspindleSpeed)"
                self.comfeed.text = "\(response.Commandfeed)"
                
                self.NOWSpindleSpeed.text = "\(response.spindleSpeed) rpm"
                self.NOWFeed.text = "\(response.feed) mm/s"
                self.NOWfftx.text = "\(response.fftx)"
                self.NOWffty.text = "\(response.ffty)"
                self.NOWfftz.text = "\(response.fftz)"
                self.NOWMachineCoordinatesX.text = "\(response.MachineCoordinatesX) mm"
                self.NOWMachineCoordinatesY.text = "\(response.MachineCoordinatesY) mm"
                self.NOWMachineCoordinatesZ.text = "\(response.MachineCoordinatesZ) mm"
                
                
                
                //更新主軸轉速資料
                let SSNewData = HIData()
                SSNewData.y = NSNumber(value: Int(response.spindleSpeed)!)
                SSseries.addPoint(SSNewData)
                SSseries.removePoint(0)
                
                
                //更新進給速率資料
                let fNewData = HIData()
                fNewData.y = NSNumber(value: Int(response.feed)!)
                fseries.addPoint(fNewData)
                fseries.removePoint(0)
                
                //更新fftX資料
                let fftXNewData = HIData()
                fftXNewData.y = NSNumber(value: Float(response.fftx) ?? 0)
                fftXseries.addPoint(fftXNewData)
                fftXseries.removePoint(0)
                
                //更新fftY資料
                let fftYNewData = HIData()
                fftYNewData.y = NSNumber(value: Float(response.ffty) ?? 0)
                fftYseries.addPoint(fftYNewData)
                fftYseries.removePoint(0)
                
                //更新fftZ資料
                let fftZNewData = HIData()
                fftZNewData.y = NSNumber(value: Float(response.fftz) ?? 0)
                fftZseries.addPoint(fftZNewData)
                fftZseries.removePoint(0)
                
                //更新coorX資料
                let coorXNewData = HIData()
                coorXNewData.y = NSNumber(value: Float(response.MachineCoordinatesX) ?? 0)
                coorXseries.addPoint(coorXNewData)
                coorXseries.removePoint(0)
                
                //更新coorY資料
                let coorYNewData = HIData()
                coorYNewData.y = NSNumber(value: Float(response.MachineCoordinatesY) ?? 0)
                coorYseries.addPoint(coorYNewData)
                coorYseries.removePoint(0)
                
                //更新coorZ資料
                let coorZNewData = HIData()
                coorZNewData.y = NSNumber(value: Float(response.MachineCoordinatesZ) ?? 0)
                coorZseries.addPoint(coorZNewData)
                coorZseries.removePoint(0)
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


struct TCCCSocketData: Codable {
    var spindleSpeed: String
    var feed: String
    var fftx: String
    var ffty: String
    var fftz: String
    var MachineCoordinatesX: String
    var MachineCoordinatesY: String
    var MachineCoordinatesZ: String
    var receivedAt: String
    var CommandspindleSpeed: String
    var Commandfeed: String

}
