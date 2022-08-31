//
//  CNCOnTimeMachineDataViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2022/2/25.
//

import UIKit
import SocketIO
import Highcharts

class CNCOnTimeMachineDataViewController: UIViewController {
    
    //目前選到的機台名稱
    var NowMachine: String = ""
    
    //主軸轉速暫存陣列
    var spindleSpeedArray: [Float] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    //進幾速率暫存陣列
    var feedArray: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    //電壓暫存陣列
    var IsArray: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    //電流暫存陣列
    var IzArray: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    
    
    
    var timer = Timer()

    
    @IBOutlet weak var spindleSpeed: UILabel!
    
    @IBOutlet weak var feed: UILabel!
    
    @IBOutlet weak var Iz: UILabel!
    
    @IBOutlet weak var Is: UILabel!
    
    
  
    @IBOutlet weak var spindleSpeedView: UIView!
    @IBOutlet weak var feedView: UIView!
    @IBOutlet weak var IsView: UIView!
    @IBOutlet weak var IzView: UIView!
    

    
    
    let manager = SocketManager(socketURL: URL(string: "http://140.135.97.69:8787")!, config: [.log(false), .forceWebsockets(true)])
    var socket:SocketIOClient!
    
    

//    func chartview(Datas: [Float]) -> HIChartView{
//        let SSchartView = HIChartView()
//
//        let SSoptions = HIOptions()
//
//        let SStitle = HITitle()
//        SStitle.text = ""
//        SSoptions.title = SStitle
//
//        let SSxAxis = HIXAxis()
//        SSxAxis.visible = false
//        SSxAxis.tickInterval = 1
//        SSxAxis.accessibility = HIAccessibility()
//        SSxAxis.accessibility.rangeDescription = "Range: 1 to 10"
//        SSoptions.xAxis = [SSxAxis]
//
//        let SSyAxis = HIYAxis()
//        SSyAxis.visible = false
//        SSyAxis.minorTickInterval = 0.1
//        SSyAxis.accessibility = HIAccessibility()
//        SSyAxis.accessibility.rangeDescription = "Range: 0.1 to 1000"
//        SSoptions.yAxis = [SSyAxis]
//
//
//
//        let SSseries = HISeries()
//        SSseries.data = Datas
//        SSseries.marker  = HIMarker()
//        SSseries.marker.enabled = false
//        SSseries.lineWidth = 2.5
//        SSseries.color = HIColor(hexValue: "6b79e4")
//
//        //關掉標籤
//        let SStooltip = HITooltip()
//        SStooltip.enabled = false
//        SSoptions.tooltip = SStooltip
//
//
//        //關閉有右上功能鍵
//        let SSexporting = HIExporting()
//        SSexporting.enabled = false
//        SSoptions.exporting = SSexporting
//
//
//        //浮水印
//        let SScredict = HICredits()
//        SScredict.enabled = false
//        SSoptions.credits = SScredict
//
//        //關掉分類標籤
//        let SSlegend = HILegend()
//        SSlegend.enabled = false
//        SSoptions.legend = SSlegend
//
//        SSoptions.series = [SSseries]
//
//        SSchartView.options = SSoptions
//
//        SSchartView.translatesAutoresizingMaskIntoConstraints = false
//
//        return SSchartView
//    }
    
//    let SSHIView: HIChartView = {
//        let SSchartView = HIChartView()
//
//        let SSoptions = HIOptions()
//
//        let SStitle = HITitle()
//        SStitle.text = ""
//        SSoptions.title = SStitle
//
//        let SSxAxis = HIXAxis()
//        SSxAxis.visible = false
//        SSxAxis.tickInterval = 1
//        SSxAxis.accessibility = HIAccessibility()
//        SSxAxis.accessibility.rangeDescription = "Range: 1 to 10"
//        SSoptions.xAxis = [SSxAxis]
//
//        let SSyAxis = HIYAxis()
//        SSyAxis.visible = false
//        SSyAxis.minorTickInterval = 0.1
//        SSyAxis.accessibility = HIAccessibility()
//        SSyAxis.accessibility.rangeDescription = "Range: 0.1 to 1000"
//        SSoptions.yAxis = [SSyAxis]
//
//
//
//        let SSseries = HISeries()
//        SSseries.data = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
//        SSseries.marker  = HIMarker()
//        SSseries.marker.enabled = false
//        SSseries.lineWidth = 2.5
//        SSseries.color = HIColor(hexValue: "6b79e4")
//
//        //關掉標籤
//        let SStooltip = HITooltip()
//        SStooltip.enabled = false
//        SSoptions.tooltip = SStooltip
//
//
//        //關閉有右上功能鍵
//        let SSexporting = HIExporting()
//        SSexporting.enabled = false
//        SSoptions.exporting = SSexporting
//
//
//        //浮水印
//        let SScredict = HICredits()
//        SScredict.enabled = false
//        SSoptions.credits = SScredict
//
//        //關掉分類標籤
//        let SSlegend = HILegend()
//        SSlegend.enabled = false
//        SSoptions.legend = SSlegend
//
//        SSoptions.series = [SSseries]
//
//        SSchartView.options = SSoptions
//
//        SSchartView.translatesAutoresizingMaskIntoConstraints = false
//
//        return SSchartView
//    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NCCodeStr.isEditable = false
//
//        NCCodeStr.text = ""
        

    
        
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
        SSseries.marker.enabled = false
        SSseries.lineWidth = 2.5
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

        self.spindleSpeedView.addSubview(SSchartView)
        SSchartView.leadingAnchor.constraint(equalTo: spindleSpeedView.leadingAnchor, constant: 0).isActive = true
        SSchartView.topAnchor.constraint(equalTo: spindleSpeedView.topAnchor, constant: 0).isActive = true
        SSchartView.trailingAnchor.constraint(equalTo: spindleSpeedView.trailingAnchor, constant: 0).isActive = true
        SSchartView.bottomAnchor.constraint(equalTo: spindleSpeedView.bottomAnchor, constant: 0).isActive = true

//
//
        
        
//        self.spindleSpeedView.addSubview(SSHIView)
//
//        SSHIView.leadingAnchor.constraint(equalTo: spindleSpeedView.leadingAnchor, constant: 0).isActive = true
//        SSHIView.topAnchor.constraint(equalTo: spindleSpeedView.topAnchor, constant: 0).isActive = true
//        SSHIView.trailingAnchor.constraint(equalTo: spindleSpeedView.trailingAnchor, constant: 0).isActive = true
//        SSHIView.bottomAnchor.constraint(equalTo: spindleSpeedView.bottomAnchor, constant: 0).isActive = true
//

        
//        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
//
//            print("11111")
////            let SSOption: HIOptions = {
////
////                let SSoptions = HIOptions()
////
////                let SSseries = HISeries()
////                SSseries.data = self?.spindleSpeedArray
////                SSseries.marker  = HIMarker()
////                SSseries.marker.enabled = false
////                SSseries.lineWidth = 2.5
////                SSseries.color = HIColor(hexValue: "6b79e4")
////                SSoptions.series = [SSseries]
////
////                return SSoptions
////            }()
////
////            self?.spindleSpeedArray.append(1)
////            self?.spindleSpeedArray.remove(at: 0)
////            self?.SSHIView.update(SSOption)
////
////            print(self?.spindleSpeedArray ?? [])
//        })
        
        
        
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
        fseries.marker.enabled = false
        fseries.lineWidth = 2.5
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

        self.feedView.addSubview(fchartView)
        fchartView.leadingAnchor.constraint(equalTo: feedView.leadingAnchor, constant: 0).isActive = true
        fchartView.topAnchor.constraint(equalTo: feedView.topAnchor, constant: 0).isActive = true
        fchartView.trailingAnchor.constraint(equalTo: feedView.trailingAnchor, constant: 0).isActive = true
        fchartView.bottomAnchor.constraint(equalTo: feedView.bottomAnchor, constant: 0).isActive = true



    //MARK:-IS趨勢圖表

        let ISchartView = HIChartView(frame: view.bounds)

        let ISoptions = HIOptions()

        let IStitle = HITitle()
        IStitle.text = ""
        ISoptions.title = IStitle

        let ISxAxis = HIXAxis()
        ISxAxis.visible = false
        ISxAxis.tickInterval = 1
        ISxAxis.accessibility = HIAccessibility()
        ISxAxis.accessibility.rangeDescription = "Range: 1 to 10"
        ISoptions.xAxis = [ISxAxis]

        let ISyAxis = HIYAxis()
        ISyAxis.visible = false
        ISyAxis.minorTickInterval = 0.1
        ISyAxis.accessibility = HIAccessibility()
        ISyAxis.accessibility.rangeDescription = "Range: 0.1 to 1000"
        ISoptions.yAxis = [ISyAxis]



        let ISseries = HISeries()
        ISseries.data = self.IsArray
        ISseries.marker  = HIMarker()
        ISseries.marker.enabled = false
        ISseries.lineWidth = 2.5
        ISseries.color = HIColor(hexValue: "6b79e4")

        //關掉標籤
        let IStooltip = HITooltip()
        IStooltip.enabled = false
        ISoptions.tooltip = IStooltip


        //關閉有右上功能鍵
        let ISexporting = HIExporting()
        ISexporting.enabled = false
        ISoptions.exporting = ISexporting


        //浮水印
        let IScredict = HICredits()
        IScredict.enabled = false
        ISoptions.credits = IScredict

        //關掉分類標籤
        let ISlegend = HILegend()
        ISlegend.enabled = false
        ISoptions.legend = ISlegend

        ISoptions.series = [ISseries]

        ISchartView.options = ISoptions

        ISchartView.translatesAutoresizingMaskIntoConstraints = false

        self.IsView.addSubview(ISchartView)
        ISchartView.leadingAnchor.constraint(equalTo: IsView.leadingAnchor, constant: 0).isActive = true
        ISchartView.topAnchor.constraint(equalTo: IsView.topAnchor, constant: 0).isActive = true
        ISchartView.trailingAnchor.constraint(equalTo: IsView.trailingAnchor, constant: 0).isActive = true
        ISchartView.bottomAnchor.constraint(equalTo: IsView.bottomAnchor, constant: 0).isActive = true


   //MARK:-Iz趨勢圖表

        let IZchartView = HIChartView(frame: view.bounds)

        let IZoptions = HIOptions()

        let IZtitle = HITitle()
        IZtitle.text = ""
        IZoptions.title = IZtitle

        let IZxAxis = HIXAxis()
        IZxAxis.visible = false
        IZxAxis.tickInterval = 1
        IZxAxis.accessibility = HIAccessibility()
        IZxAxis.accessibility.rangeDescription = "Range: 1 to 10"
        IZoptions.xAxis = [IZxAxis]

        let IZyAxis = HIYAxis()
        IZyAxis.visible = false
        IZyAxis.minorTickInterval = 0.1
        IZyAxis.accessibility = HIAccessibility()
        IZyAxis.accessibility.rangeDescription = "Range: 0.1 to 1000"
        IZoptions.yAxis = [IZyAxis]



        let IZseries = HISeries()
        IZseries.data = self.IzArray
        IZseries.marker  = HIMarker()
        IZseries.marker.enabled = false
        IZseries.lineWidth = 2.5
        IZseries.color = HIColor(hexValue: "6b79e4")

        //關掉標籤
        let IZtooltip = HITooltip()
        IZtooltip.enabled = false
        IZoptions.tooltip = IZtooltip


        //關閉有右上功能鍵
        let IZexporting = HIExporting()
        IZexporting.enabled = false
        IZoptions.exporting = IZexporting


        //浮水印
        let IZcredict = HICredits()
        IZcredict.enabled = false
        IZoptions.credits = IZcredict

        //關掉分類標籤
        let IZlegend = HILegend()
        IZlegend.enabled = false
        IZoptions.legend = IZlegend

        IZoptions.series = [IZseries]

        IZchartView.options = IZoptions

        IZchartView.translatesAutoresizingMaskIntoConstraints = false

        self.IzView.addSubview(IZchartView)
        IZchartView.leadingAnchor.constraint(equalTo: IzView.leadingAnchor, constant: 0).isActive = true
        IZchartView.topAnchor.constraint(equalTo: IzView.topAnchor, constant: 0).isActive = true
        IZchartView.trailingAnchor.constraint(equalTo: IzView.trailingAnchor, constant: 0).isActive = true
        IZchartView.bottomAnchor.constraint(equalTo: IzView.bottomAnchor, constant: 0).isActive = true



   //MARK: -Socket
        let socket = manager.defaultSocket

        socket.on(clientEvent: .connect) {(data, _) in
            print("CNC機台數據 socket connected")
            print("\(data.debugDescription)")

        }
        
        socket.on(clientEvent: .disconnect) { (data, _) in
            print("CNC機台數據 socket disconnect +++++++++++++++")
        }

        var socketStr: String = ""
        if self.NowMachine == "CNCA_01" {
            socketStr = "CNC_Vcenter_p76"
        } else if self.NowMachine == "CNCA_02" {
            socketStr = "DDS"
        } else if self.NowMachine == "CNC_01" {
            socketStr = "CNC_VMC_860"
        }


        socket.on(socketStr){ (data, _) in

           // print(data)
           // print(socketStr)

            guard let dataInfo = data.first else { return }
            
            
                
            print(data)

            if let response: TDDSocket = try? SocketParser.convert(data: dataInfo) {

                print(response)

                self.spindleSpeed.text = "\(response.spindleSpeed) rpm"

                self.feed.text = "\(response.feed) mm/s"

                self.Is.text = "\(response.Is) V"

                self.Iz.text = "\(response.Iz) A"
                
                
            


                self.spindleSpeedArray.append(Float(response.spindleSpeed) ?? 0)
                self.spindleSpeedArray.removeFirst()

                //更新主軸轉速資料
                let SSNewData = HIData()
                SSNewData.y = NSNumber(value: Float(response.spindleSpeed) ?? 0)
                SSseries.addPoint(SSNewData)
                SSseries.removePoint(0)


                //更新進給速率資料
                let fNewData = HIData()
                fNewData.y = NSNumber(value: Float(response.feed) ?? 0)
                fseries.addPoint(fNewData)
                fseries.removePoint(0)
//
                //更新電壓IS資料
                let ISNewData = HIData()
                ISNewData.y = NSNumber(value: Float(response.Is) ?? 0)
                ISseries.addPoint(ISNewData)
                ISseries.removePoint(0)



                //更新電流IZ資料
                let IZNewData = HIData()
                IZNewData.y = NSNumber(value: Float(response.Iz) ?? 0)
                IZseries.addPoint(IZNewData)
               IZseries.removePoint(0)



            }
        }

        socket.connect()
        
        
        

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Manager.shared.delegate = self
        
    }

    
    override func viewDidDisappear(_ animated: Bool) {
      
    }
    
    deinit {
        print("OS reclaiming memory ")
        timer.invalidate()
        socket.disconnect()
        print("CNC OS==================")
    }
    
    

    
}



//解析socket的資料格式
struct TDDSocket: Codable {
    var spindleSpeed: String
    var feed: String
    var Iz: String
    var Is: String
    
}
