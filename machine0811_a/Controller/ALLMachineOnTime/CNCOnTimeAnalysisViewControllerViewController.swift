//
//  CNCOnTimeAnalysisViewControllerViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2022/2/27.
//

import UIKit
import Highcharts
import SocketIO

class CNCOnTimeAnalysisViewControllerViewController: UIViewController {
    
    @IBOutlet weak var VibrationView: UIView!

    @IBOutlet weak var FFTView: UIView!
    
    //目前選到的機台名稱
    var NowMachine: String = ""
    
    //socket
    let manager = SocketManager(socketURL: URL(string: "http://140.135.97.69:8787")!, config: [.log(false), .forceWebsockets(true)])
    var socket:SocketIOClient!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
   //MARK: -振動值圖
        let VVchartView = HIChartView(frame: view.bounds)
        VVchartView.plugins = ["boost"]

        let VVoptions = HIOptions()

        let VVchart = HIChart()
        VVchart.zoomType = "x"
        VVoptions.chart = VVchart

        let VVtitle = HITitle()
        VVtitle.text = "Vibration Value"
        VVoptions.title = VVtitle



        let VVtooltip = HITooltip()
        VVtooltip.enabled = false
        VVtooltip.valueDecimals = 2
        VVoptions.tooltip = VVtooltip

        let VVxAxis = HIXAxis()
        VVxAxis.title = HITitle()
        VVxAxis.title.text = "數量"
        VVoptions.xAxis = [VVxAxis]

        let VVDataPoints = HISeries()
        VVDataPoints.name = "Vibration Value"
        VVDataPoints.lineWidth = 0.5
        VVDataPoints.data = []
        //增加點的個數上限
        VVDataPoints.turboThreshold = 50000
        VVDataPoints.marker = HIMarker()
        VVDataPoints.marker.enabled = false
        VVoptions.series = [VVDataPoints]
        
        //提高boost上限
        let VVplotOptions = HIPlotOptions()
        VVplotOptions.series = HISeries()
        VVplotOptions.series.boostThreshold = 50000
        VVoptions.plotOptions = VVplotOptions
        
        
        //關閉有右上功能鍵
        let VVexporting = HIExporting()
        VVexporting.enabled = false
        VVoptions.exporting = VVexporting
        
        
        //浮水印
        let VVcredict = HICredits()
        VVcredict.enabled = false
        VVoptions.credits = VVcredict
        
        //關掉分類標籤
        let VVlegend = HILegend()
        VVlegend.enabled = false
        VVoptions.legend = VVlegend

        VVoptions.series = [VVDataPoints]
        

        VVchartView.options = VVoptions
        
        VVchartView.translatesAutoresizingMaskIntoConstraints = false
        
        self.VibrationView.addSubview(VVchartView)
        
        VVchartView.leadingAnchor.constraint(equalTo: VibrationView.leadingAnchor, constant: 0).isActive = true
        VVchartView.topAnchor.constraint(equalTo: VibrationView.topAnchor, constant: 0).isActive = true
        VVchartView.trailingAnchor.constraint(equalTo: VibrationView.trailingAnchor, constant: 0).isActive = true
        VVchartView.bottomAnchor.constraint(equalTo: VibrationView.bottomAnchor, constant: 0).isActive = true
        
        
        
//MARK: -振動值傅立葉圖
        
        let FFTchartView = HIChartView(frame: view.bounds)
        FFTchartView.plugins = ["boost"]

        let FFToptions = HIOptions()

        let FFTchart = HIChart()
        FFTchart.zoomType = "x"
        FFToptions.chart = FFTchart

        let FFTtitle = HITitle()
        FFTtitle.text = "Fast Fourier Transform"
        FFToptions.title = FFTtitle



        let FFTtooltip = HITooltip()
        FFTtooltip.enabled = false
        FFTtooltip.valueDecimals = 2
        FFToptions.tooltip = FFTtooltip

        let FFTxAxis = HIXAxis()
        FFTxAxis.title = HITitle()
        FFTxAxis.title.text = "數量"
        FFToptions.xAxis = [FFTxAxis]
        
        let FFTyAxis = HIYAxis()
        FFTyAxis.minTickInterval = 0.0025
        FFToptions.yAxis = [FFTyAxis]

        let FFTDataPoints = HISeries()
        FFTDataPoints.name = "FFT"
        FFTDataPoints.lineWidth = 0.5
        FFTDataPoints.data = []
        //增加點的個數上限
        FFTDataPoints.turboThreshold = 50000
        FFTDataPoints.marker = HIMarker()
        FFTDataPoints.marker.enabled = false
        FFToptions.series = [FFTDataPoints]
        
        //提高boost上限
        let FFTplotOptions = HIPlotOptions()
        FFTplotOptions.series = HISeries()
        FFTplotOptions.series.boostThreshold = 50000
        FFToptions.plotOptions = FFTplotOptions
        
        
        //關閉有右上功能鍵
        let FFTexporting = HIExporting()
        FFTexporting.enabled = false
        FFToptions.exporting = FFTexporting
        
        
        //浮水印
        let FFTcredict = HICredits()
        FFTcredict.enabled = false
        FFToptions.credits = FFTcredict
        
        //關掉分類標籤
        let FFTlegend = HILegend()
        FFTlegend.enabled = false
        FFToptions.legend = FFTlegend

        FFToptions.series = [FFTDataPoints]
        

        FFTchartView.options = FFToptions
        
        FFTchartView.translatesAutoresizingMaskIntoConstraints = false
        
        self.FFTView.addSubview(FFTchartView)
        
        FFTchartView.leadingAnchor.constraint(equalTo: FFTView.leadingAnchor, constant: 0).isActive = true
        FFTchartView.topAnchor.constraint(equalTo: FFTView.topAnchor, constant: 0).isActive = true
        FFTchartView.trailingAnchor.constraint(equalTo: FFTView.trailingAnchor, constant: 0).isActive = true
        FFTchartView.bottomAnchor.constraint(equalTo: FFTView.bottomAnchor, constant: 0).isActive = true
        
        
        
  //MARK: -Socket
        
        let socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { (data, _) in
            print("CNC數據分析 socket connected")
            print("\(data.debugDescription)")
           
           
        }
        
        //判斷點選的機台是哪台，要用什麼來當socket的值
        var socketStr: String = ""
        if self.NowMachine == "CNCA_01" {
            socketStr = "CNC_Vcenter_p76"
        } else if self.NowMachine == "CNCA_02" {
            socketStr = "DDS"
        } else if self.NowMachine == "CNC_01" {
            socketStr = "CNC_VMC_860"
        }
        
        socket.on(socketStr){ (data, _) in
            
            guard let dataInfo = data.first else { return }
            //  print(data)
            
            if let response: CNCDownData = try? SocketParser.convert(data: dataInfo) {
              // print(response)
                
                VVDataPoints.data = response.VibrValue
 
                FFTDataPoints.data = response.FFTValue
                

                
            }
            
        }

        socket.connect()
    }
    

   

}

//資料解析架構
struct CNCDownData: Codable {
    var FFTValue: [ Double ]
    var VibrValue: [Double]
}
