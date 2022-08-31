//
//  InjectionOnTimeAnalysisViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2022/1/21.
//

import UIKit
import Highcharts
import SocketIO


class InjectionOnTimeAnalysisViewController: UIViewController {
    
    @IBOutlet weak var MaxPressureView: UIView!
    @IBOutlet weak var PressureView: UIView!
    @IBOutlet weak var velocityView: UIView!
    
    
    var SPC_maxpressure: Float = 0

    //單筆最大壓力資料
    var maxPressuredata =  [Float]()
    //箱型圖資料
    var boxdata: [[Float]] = []
    //離群值的暫存序號(每收到資料就＋1所以預設必須要-1)(也預設當前徒刑的序號)
    var outerlierIndex: Int = -1
    //離群值
    var outliers: [[Any]] = []
    //總時間
    var AllTime: Float = 0
    //相形圖區間資料
    var boxArrageData: [[Float]] = []
    
    //壓力曲線先前數值
    var oldPressureCurve: [[[Float]]] = []
    //壓力曲線先前數值
    var oldSpeedCurve: [[[Float]]] = []
    

    var oldBoxPlot = UIView()
    
    
    @IBOutlet weak var choose50B: UIButton!
    

    
    //選擇50筆開關
    var choose: Bool = false
    
    
    //socket連線
    let manager = SocketManager(socketURL: URL(string: "http://140.135.97.69:8787")!, config: [.log(false), .forceWebsockets(true)])
    var socket:SocketIOClient!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //讀取過去歷史資料
        self.getData()
        
       //將程式延遲幾秒等待資料進來
        sleep(UInt32(1.5))
        
        //切換頁籤樣式
        self.choose50B.setTitle("當前100筆", for: .normal)
        self.choose50B.setTitleColor(UIColor.white, for: .normal)
        self.choose50B.backgroundColor = .systemBlue
        
        self.choose50B.setTitle("當前50筆", for: .selected)
        self.choose50B.setTitleColor(.white, for: .selected)

        
        //如果目前資料小於50筆就不能使用頁籤
        if self.maxPressuredata.count < 51 {
            self.choose50B.isEnabled = false
        } else {
            self.choose50B.isEnabled = true
        }

   //MARK: -箱型圖繪製
        
        //箱形圖繪製
        let chartView = HIChartView(frame: view.bounds)
        let options = HIOptions()

        let title = HITitle()
        title.text = "Multplas MaxPressure Box Plot"
        options.title = title

        let legend = HILegend()
        legend.enabled = false
        options.legend = legend

        let xAxis = HIXAxis()
        xAxis.title = HITitle()
        xAxis.title.text = "模次"
   
        options.xAxis = [xAxis]

        let yAxis = HIYAxis()
        yAxis.title = HITitle()
        yAxis.title.text = "SPC_maxPressure"
        let plotLine = HIPlotLines()

        yAxis.plotLines = [plotLine]
        options.yAxis = [yAxis]

        //相形圖資料更新
        let observations = HIBoxplot()
        observations.name = "SPC_maxPressure"
        observations.color = HIColor(hexValue: "41505b")
        observations.data = self.boxdata
        observations.tooltip = HITooltip()
        observations.tooltip.headerFormat = "<em>No {point.key}</em><br/>"
        observations.tooltip.valueDecimals = 2

        
        //最大壓力本模次數值
        let nowData = HISpline()
        nowData.name = "Now"
        nowData.data = self.maxPressuredata
        nowData.color = HIColor(hexValue: "f59a44")
        nowData.marker = HIMarker()
        nowData.marker.symbol = "diamond"
        nowData.marker.fillColor = HIColor(name: "white")
        nowData.marker.lineColor = "#facf4c"
        nowData.tooltip = HITooltip()
        nowData.tooltip.pointFormat = "本模次數值: {point.y}"
        nowData.tooltip.valueDecimals = 2
        
        
        
        //離群值資料更新
        let outliers = HIScatter()
        outliers.name = "Outliers"
        outliers.color = HIColor(name: "white")
        outliers.data = self.outliers
        outliers.marker = HIMarker()
        outliers.marker.fillColor = HIColor(name: "white")
        outliers.marker.lineWidth = 1.5
        outliers.marker.lineColor = "#add666"
        outliers.marker.symbol = "circle"
        outliers.tooltip = HITooltip()
        outliers.tooltip.pointFormat = "離群值: {point.y}"
        outliers.tooltip.valueDecimals = 2
        

        
        //匡線款式
        let plotOptions = HIPlotOptions()
        plotOptions.series = HISeries()
        let animation = HIAnimationOptionsObject()
        animation.defer = 1
        plotOptions.series.animation = animation
        plotOptions.spline = HISpline()
        plotOptions.spline.marker = HIMarker()
        plotOptions.spline.marker.radius = 4
        plotOptions.spline.marker.lineColor = "#666666"
        plotOptions.spline.marker.lineWidth = 1
        options.plotOptions = plotOptions
        
        
        
        //離散值區間
        let boxArange = HIArearange()
        boxArange.name = "Range"
        boxArange.data = self.boxArrageData
        boxArange.color = HIColor(hexValue: "2f7ed8")
        boxArange.tooltip = HITooltip()
        boxArange.tooltip.valueDecimals = 2
        boxArange.marker = HIMarker()
        boxArange.marker.enabled = false
        boxArange.fillOpacity = 0.1
        boxArange.lineWidth = 0
        
        
        
        //圖表縮放
        let chart = HIChart()
        chart.zoomType = "x"
        chart.scrollablePlotArea = HIScrollablePlotArea()
        chart.scrollablePlotArea.minWidth = 300
        chart.scrollablePlotArea.scrollPositionX = 1
        options.chart = chart

        
        options.series = [boxArange, observations, outliers, nowData]

    
        //關閉有右上功能鍵
        let exporting = HIExporting()
        exporting.enabled = false
        options.exporting = exporting
        
        
        //浮水印
        let credict = HICredits()
        credict.enabled = false
        options.credits = credict

        chartView.options = options
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        self.MaxPressureView.addSubview(chartView)
        

        
        chartView.leadingAnchor.constraint(equalTo: MaxPressureView.leadingAnchor, constant: 0).isActive = true
        chartView.topAnchor.constraint(equalTo: MaxPressureView.topAnchor, constant: 5).isActive = true
        chartView.trailingAnchor.constraint(equalTo: MaxPressureView.trailingAnchor, constant: 0).isActive = true
        chartView.bottomAnchor.constraint(equalTo: MaxPressureView.bottomAnchor, constant: 0).isActive = true
          
        
        self.oldBoxPlot = chartView
        
        
 //MARK: -壓力曲線圖繪製
        let PchartView = HIChartView(frame: view.bounds)
     
        PchartView.plugins = ["boost"]

        let Poptions = HIOptions()

        let Pchart = HIChart()
        Pchart.zoomType = "x"
        Poptions.chart = Pchart

        let Ptitle = HITitle()
        Ptitle.text = "Pressure Curve"
        Poptions.title = Ptitle



        let Ptooltip = HITooltip()
        Ptooltip.valueDecimals = 2
        Poptions.tooltip = Ptooltip
        

        let PxAxis = HIXAxis()
        
        PxAxis.type = "linear"
        PxAxis.tickInterval = 0.2
        let PplotLine = HIPlotLines()
        PplotLine.value = 1.63
        PplotLine.color = HIColor(name: "purple")
        PplotLine.width = 1
        PplotLine.label = HILabel()
        PplotLine.label.text = "保壓"
        PplotLine.label.style = HICSSObject()
        PplotLine.label.style.color = "gray"
        PxAxis.plotLines = [PplotLine]
        Poptions.xAxis = [PxAxis]
        
        let PyAxis = HIYAxis()
        PyAxis.title = HITitle()
        PyAxis.title.text = ""
        PyAxis.tickInterval = 100
        Poptions.yAxis = [PyAxis]
        
        
        var DD: [HISeries] = []
        for item in self.oldPressureCurve {
            let PDataPoints = HISeries()
            PDataPoints.name = "當秒壓力"
            PDataPoints.data = item
            PDataPoints.marker = HIMarker()
            PDataPoints.marker.enabled = false
            PDataPoints.lineWidth = 2
            if item == self.oldPressureCurve.last {
                PDataPoints.color = HIColor(hexValue: "6b79e4")
            } else {
                PDataPoints.color = HIColor(hexValue: "cccccc")
            }
           
            DD.append(PDataPoints)
        }
        

        Poptions.series = DD
        
        //關閉有右上功能鍵
        let Pexporting = HIExporting()
        Pexporting.enabled = false
        Poptions.exporting = Pexporting
        
        
        //浮水印
        let Pcredict = HICredits()
        Pcredict.enabled = false
        Poptions.credits = Pcredict
        
        //關掉分類標籤
        let Plegend = HILegend()
        Plegend.enabled = false
        Poptions.legend = Plegend

        PchartView.options = Poptions
        
       
        
        PchartView.translatesAutoresizingMaskIntoConstraints = false

        self.PressureView.addSubview(PchartView)
        
        PchartView.leadingAnchor.constraint(equalTo: PressureView.leadingAnchor, constant: 0).isActive = true
        PchartView.topAnchor.constraint(equalTo: PressureView.topAnchor, constant: 5).isActive = true
        PchartView.trailingAnchor.constraint(equalTo: PressureView.trailingAnchor, constant: 0).isActive = true
        PchartView.bottomAnchor.constraint(equalTo: PressureView.bottomAnchor, constant: 0).isActive = true
        
  
        //MARK: -速度曲線圖繪製
               let SchartView = HIChartView(frame: view.bounds)
            
               SchartView.plugins = ["boost"]

               let Soptions = HIOptions()

               let Schart = HIChart()
               Schart.zoomType = "x"
               Soptions.chart = Schart

               let Stitle = HITitle()
               Stitle.text = "Speed Curve"
               Soptions.title = Stitle



               let Stooltip = HITooltip()
               Stooltip.valueDecimals = 2
               Soptions.tooltip = Stooltip
               

               let SxAxis = HIXAxis()
               SxAxis.type = "linear"
               SxAxis.tickInterval = 0.2

               Soptions.xAxis = [SxAxis]
               
               let SyAxis = HIYAxis()
               SyAxis.title = HITitle()
               SyAxis.title.text = ""
               SyAxis.tickInterval = 20
               Soptions.yAxis = [SyAxis]
        
        
            var CC: [HISeries] = []
            for item in self.oldSpeedCurve {
                let SDataPoints = HISeries()
                SDataPoints.name = "當秒速度"
                SDataPoints.data = item
                SDataPoints.marker = HIMarker()
                SDataPoints.marker.enabled = false
                SDataPoints.lineWidth = 2
                if item == self.oldSpeedCurve.last {
                    SDataPoints.color = HIColor(hexValue: "6b79e4")
                } else {
                    SDataPoints.color = HIColor(hexValue: "cccccc")
                }
                
                CC.append(SDataPoints)
            }


               Soptions.series = CC
               
               //關閉有右上功能鍵
               let Sexporting = HIExporting()
               Sexporting.enabled = false
               Soptions.exporting = Sexporting
               
               
               //浮水印
               let Scredict = HICredits()
               Scredict.enabled = false
               Soptions.credits = Scredict
               
               //關掉分類標籤
               let Slegend = HILegend()
               Slegend.enabled = false
               Soptions.legend = Slegend

               SchartView.options = Soptions
               
               SchartView.translatesAutoresizingMaskIntoConstraints = false

               self.velocityView.addSubview(SchartView)
               
               SchartView.leadingAnchor.constraint(equalTo: velocityView.leadingAnchor, constant: 0).isActive = true
               SchartView.topAnchor.constraint(equalTo: velocityView.topAnchor, constant: 5).isActive = true
               SchartView.trailingAnchor.constraint(equalTo: velocityView.trailingAnchor, constant: 0).isActive = true
               SchartView.bottomAnchor.constraint(equalTo: velocityView.bottomAnchor, constant: 0).isActive = true
        
        
 //MARK: -socket
        let socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { (data, ack) in
            print(data)
            print("射出機即時數據分析 socket connected")
            
            
        }
        
        socket.on(clientEvent: .error) { (data, eck) in
            print(data)
            print("socket error")
        }
        
        socket.on(clientEvent: .disconnect) { (data, eck) in
            print(data)
            print("socket disconnect")
        }
        
        
        socket.on("injDDS"){ [self] (data, _) in
            
            guard let dataInfo = data.first else { return }
            
            if let response: InjSocketData = try? SocketParser.convert(data: dataInfo) {
                
         //   print(response)
                
                //如果資料量到達101筆(0...100)
                if self.maxPressuredata.count == 101 {
                    if self.maxPressuredata.count < 51 {
                        self.choose50B.isEnabled = false
                    } else {
                        self.choose50B.isEnabled = true
                    }
                    
                    //將最大壓力字串去掉","號
                    let maxPStr: String = response.SPC_maxPressure.replacingOccurrences(of: ",", with: "")
                    
                    //最大壓力傳到外部儲存
                    self.maxPressuredata.append(Float(maxPStr)!)
                    self.maxPressuredata.remove(at: 0)
                    self.SPC_maxpressure = Float(maxPStr)!
                    
                    //箱型圖資料
                    self.boxdata.append(self.medial(listArr: self.maxPressuredata, indexAll: self.outerlierIndex).boxDatas)
                    self.boxdata.remove(at: 0)
                    
                    
                //離散值資料更新
                    /////去除所以第一筆的離散值
                    for arrayindex in 0...self.outliers.count-1 {
                        //去除所以第一筆的離散值
                        if self.outliers[arrayindex][0] as! Int == 0{
                            self.outliers.remove(at: arrayindex)
                        } else {
                        }
                    }
                    ///所有離散值的第一位數減一
                    var newoutliner: [[Any]] = []
                    for arrayindex in 0...self.outliers.count-1 {
                        newoutliner.append([self.outliers[arrayindex][0] as! Int  - 1 , self.outliers[arrayindex][1]])
                    }
                    self.outliers = newoutliner
                    ///再加入最新一筆的離散值
                    for item in self.medial(listArr: self.maxPressuredata, indexAll: 100).outDatas {
                        self.outliers.append(item)
                    }
                    
                    //箱型圖資料區間
                    self.boxArrageData.append(self.medial(listArr: self.maxPressuredata, indexAll: self.outerlierIndex).boxrange)
                    self.boxArrageData.remove(at: 0)
                    
                    
                    //充填時間＋保壓時間=總時間
                    self.AllTime = Float(response.SPC_fillingTime)! + Float(response.PACK_T_1st)! + Float(response.PACK_T_2nd)! + Float(response.PACK_T_3rd)!
                    
                    self.oldPressureCurve.append(self.tidyData(arryStr: response.Pressure_Curve, FullT: self.AllTime).pressureData)
                    self.oldPressureCurve.remove(at: 0)
                    self.oldSpeedCurve.append(self.tidyData(arryStr: response.Pressure_Curve, FullT: self.AllTime).speedData)
                    self.oldSpeedCurve.remove(at: 0)
                    
                } else {
                //如果資料小於50比
                    
                    if self.maxPressuredata.count < 51 {
                        self.choose50B.isEnabled = false
                    } else {
                        self.choose50B.isEnabled = true
                    }
                    
                    //將最大壓力字串去掉","號
                    let maxPStr: String = response.SPC_maxPressure.replacingOccurrences(of: ",", with: "")
                    //最大壓力傳到外部儲存
                    self.maxPressuredata.append(Float(maxPStr)!)
                    self.SPC_maxpressure = Float(maxPStr)!
                    
                    self.boxdata.append(self.medial(listArr: self.maxPressuredata, indexAll: self.outerlierIndex).boxDatas)
                    

                    //計算
                    self.outerlierIndex += 1


                    for item in self.medial(listArr: self.maxPressuredata, indexAll: self.outerlierIndex).outDatas {
                        self.outliers.append(item)
                    }
                    
                    //箱型圖資料區間
                    self.boxArrageData.append(self.medial(listArr: self.maxPressuredata, indexAll: self.outerlierIndex).boxrange)
                    
                    //充填時間＋保壓時間=總時間
                    self.AllTime = Float(response.SPC_fillingTime)! + Float(response.PACK_T_1st)! + Float(response.PACK_T_2nd)! + Float(response.PACK_T_3rd)!
                    
                    self.oldPressureCurve.append(self.tidyData(arryStr: response.Pressure_Curve, FullT: self.AllTime).pressureData)
                    self.oldSpeedCurve.append(self.tidyData(arryStr: response.Pressure_Curve, FullT: self.AllTime).speedData)
                }

        

            }





//MARK: -Socket圖表更新
            
            if self.choose == true {
                
                //箱形圖繪製
                let chartView = HIChartView(frame: view.bounds)
                let options = HIOptions()

                let title = HITitle()
                title.text = "Multplas MaxPressure Box Plot"
                options.title = title

                let legend = HILegend()
                legend.enabled = false
                options.legend = legend

                let xAxis = HIXAxis()
                xAxis.title = HITitle()
                xAxis.title.text = "模次"
           
                options.xAxis = [xAxis]

                let yAxis = HIYAxis()
                yAxis.title = HITitle()
                yAxis.title.text = "SPC_maxPressure"
                let plotLine = HIPlotLines()

                yAxis.plotLines = [plotLine]
                options.yAxis = [yAxis]

                //相形圖資料更新
                let observations = HIBoxplot()
                observations.name = "SPC_maxPressure"
                observations.color = HIColor(hexValue: "41505b")
                observations.data = Array(self.boxdata[49...self.boxdata.count-1])
                observations.tooltip = HITooltip()
                observations.tooltip.headerFormat = "<em>No {point.key}</em><br/>"
                observations.tooltip.valueDecimals = 2

                
                //最大壓力本模次數值
                let nowData = HISpline()
                nowData.name = "Now"
                nowData.data = Array(self.maxPressuredata[49...self.maxPressuredata.count-1])
                nowData.color = HIColor(hexValue: "f59a44")
                nowData.marker = HIMarker()
                nowData.marker.symbol = "diamond"
                nowData.marker.fillColor = HIColor(name: "white")
                nowData.marker.lineColor = "#facf4c"
                nowData.tooltip = HITooltip()
                nowData.tooltip.pointFormat = "本模次數值: {point.y}"
                nowData.tooltip.valueDecimals = 2
                
                var newOutLiner: [[Any]] = []
                for arrayI in 0...self.outliers.count-1 {
                    if self.outliers[arrayI][0] as! Int > 48 {
                        newOutLiner.append([self.outliers[arrayI][0] as! Int-49, self.outliers[arrayI][1]])
                    }
                }
                
                //離群值資料更新
                let outliers = HIScatter()
                outliers.name = "Outliers"
                outliers.color = HIColor(name: "white")
                outliers.data = newOutLiner
                outliers.marker = HIMarker()
                outliers.marker.fillColor = HIColor(name: "white")
                outliers.marker.lineWidth = 1.5
                outliers.marker.lineColor = "#add666"
                outliers.marker.symbol = "circle"
                outliers.tooltip = HITooltip()
                outliers.tooltip.pointFormat = "離群值: {point.y}"
                outliers.tooltip.valueDecimals = 2
                
                //匡線款式
                let plotOptions = HIPlotOptions()
                plotOptions.series = HISeries()
                let animation = HIAnimationOptionsObject()
                animation.defer = 1
                plotOptions.series.animation = animation
                plotOptions.spline = HISpline()
                plotOptions.spline.marker = HIMarker()
                plotOptions.spline.marker.radius = 4
                plotOptions.spline.marker.lineColor = "#666666"
                plotOptions.spline.marker.lineWidth = 1
                options.plotOptions = plotOptions
                
                
                
                //離散值區間
                let boxArange = HIArearange()
                boxArange.name = "Range"
                boxArange.data = Array(self.boxArrageData[49...self.boxArrageData.count-1])
                boxArange.color = HIColor(hexValue: "2f7ed8")
                boxArange.tooltip = HITooltip()
                boxArange.tooltip.valueDecimals = 2
                boxArange.marker = HIMarker()
                boxArange.marker.enabled = false
                boxArange.fillOpacity = 0.1
                boxArange.lineWidth = 0
                
                
                
                //圖表縮放
                let chart = HIChart()
                chart.zoomType = "x"
                chart.scrollablePlotArea = HIScrollablePlotArea()
                chart.scrollablePlotArea.minWidth = 300
                chart.scrollablePlotArea.scrollPositionX = 1
                options.chart = chart

                
                options.series = [boxArange, observations, outliers, nowData]

            
                //關閉有右上功能鍵
                let exporting = HIExporting()
                exporting.enabled = false
                options.exporting = exporting
                
                
                //浮水印
                let credict = HICredits()
                credict.enabled = false
                options.credits = credict

                chartView.options = options
                
                chartView.translatesAutoresizingMaskIntoConstraints = false
                
                self.MaxPressureView.addSubview(chartView)
                

                
                chartView.leadingAnchor.constraint(equalTo: MaxPressureView.leadingAnchor, constant: 0).isActive = true
                chartView.topAnchor.constraint(equalTo: MaxPressureView.topAnchor, constant: 5).isActive = true
                chartView.trailingAnchor.constraint(equalTo: MaxPressureView.trailingAnchor, constant: 0).isActive = true
                chartView.bottomAnchor.constraint(equalTo: MaxPressureView.bottomAnchor, constant: 0).isActive = true
                

                
                let PchartView = HIChartView(frame: view.bounds)

                PchartView.plugins = ["boost"]

                let Poptions = HIOptions()

                let Pchart = HIChart()
                Pchart.zoomType = "x"
                Poptions.chart = Pchart

                let Ptitle = HITitle()
                Ptitle.text = "Pressure Curve"
                Poptions.title = Ptitle



                let Ptooltip = HITooltip()
                Ptooltip.valueDecimals = 2
                Poptions.tooltip = Ptooltip


                let PxAxis = HIXAxis()

                PxAxis.type = "linear"
                PxAxis.tickInterval = 0.2
                let PplotLine = HIPlotLines()
                PplotLine.value = 1.63
                PplotLine.color = HIColor(name: "purple")
                PplotLine.width = 1
                PplotLine.label = HILabel()

                PplotLine.label.text = "保壓"
                PplotLine.label.style = HICSSObject()
                PplotLine.label.style.color = "gray"
                PxAxis.plotLines = [PplotLine]
                Poptions.xAxis = [PxAxis]

                let PyAxis = HIYAxis()
                PyAxis.title = HITitle()
                PyAxis.title.text = ""
                PyAxis.tickInterval = 100
                Poptions.yAxis = [PyAxis]


                var DD: [HISeries] = []
                for item in 49...self.oldPressureCurve.count-1 {
                    let PDataPoints = HISeries()
                    PDataPoints.name = "當秒壓力"
                    PDataPoints.data = self.oldPressureCurve[item]
                    PDataPoints.marker = HIMarker()
                    PDataPoints.marker.enabled = false
                    PDataPoints.lineWidth = 2
                    if item == self.oldPressureCurve.count-1 {

                        PDataPoints.color = HIColor(hexValue: "6b79e4")

                    } else {

                        PDataPoints.color = HIColor(hexValue: "cccccc")
                    }

                    DD.append(PDataPoints)
                }



                Poptions.series = DD

                //關閉有右上功能鍵
                let Pexporting = HIExporting()
                Pexporting.enabled = false
                Poptions.exporting = Pexporting


                //浮水印
                let Pcredict = HICredits()
                Pcredict.enabled = false
                Poptions.credits = Pcredict

                //關掉分類標籤
                let Plegend = HILegend()
                Plegend.enabled = false
                Poptions.legend = Plegend

                PchartView.options = Poptions



                PchartView.translatesAutoresizingMaskIntoConstraints = false

                self.PressureView.addSubview(PchartView)

                PchartView.leadingAnchor.constraint(equalTo: PressureView.leadingAnchor, constant: 0).isActive = true
                PchartView.topAnchor.constraint(equalTo: PressureView.topAnchor, constant: 5).isActive = true
                PchartView.trailingAnchor.constraint(equalTo: PressureView.trailingAnchor, constant: 0).isActive = true
                PchartView.bottomAnchor.constraint(equalTo: PressureView.bottomAnchor, constant: 0).isActive = true




                let SchartView = HIChartView(frame: view.bounds)

                SchartView.plugins = ["boost"]

                let Soptions = HIOptions()

                let Schart = HIChart()
                Schart.zoomType = "x"
                Soptions.chart = Schart

                let Stitle = HITitle()
                Stitle.text = "Speed Curve"
                Soptions.title = Stitle



                let Stooltip = HITooltip()
                Stooltip.valueDecimals = 2
                Soptions.tooltip = Stooltip


                let SxAxis = HIXAxis()
                SxAxis.type = "linear"
                SxAxis.tickInterval = 0.2

                Soptions.xAxis = [SxAxis]

                let SyAxis = HIYAxis()
                SyAxis.title = HITitle()
                SyAxis.title.text = ""
                SyAxis.tickInterval = 20
                Soptions.yAxis = [SyAxis]


             var CC: [HISeries] = []
                for item in 49...self.oldSpeedCurve.count-1 {
                 let SDataPoints = HISeries()
                 SDataPoints.name = "當秒速度"
                    SDataPoints.data = self.oldSpeedCurve[item]
                 SDataPoints.marker = HIMarker()
                 SDataPoints.marker.enabled = false
                 SDataPoints.lineWidth = 2
                    if item == self.oldSpeedCurve.count-1 {
                        SDataPoints.color = HIColor(hexValue: "6b79e4")
                    } else {
                        SDataPoints.color = HIColor(hexValue: "cccccc")
                    }

                 CC.append(SDataPoints)
             }


                Soptions.series = CC

                //關閉有右上功能鍵
                let Sexporting = HIExporting()
                Sexporting.enabled = false
                Soptions.exporting = Sexporting


                //浮水印
                let Scredict = HICredits()
                Scredict.enabled = false
                Soptions.credits = Scredict

                //關掉分類標籤
                let Slegend = HILegend()
                Slegend.enabled = false
                Soptions.legend = Slegend

                SchartView.options = Soptions

                SchartView.translatesAutoresizingMaskIntoConstraints = false

                self.velocityView.addSubview(SchartView)

                SchartView.leadingAnchor.constraint(equalTo: velocityView.leadingAnchor, constant: 0).isActive = true
                SchartView.topAnchor.constraint(equalTo: velocityView.topAnchor, constant: 5).isActive = true
                SchartView.trailingAnchor.constraint(equalTo: velocityView.trailingAnchor, constant: 0).isActive = true
                SchartView.bottomAnchor.constraint(equalTo: velocityView.bottomAnchor, constant: 0).isActive = true
                
            } else {
                //箱形圖繪製
                let chartView = HIChartView(frame: view.bounds)
                let options = HIOptions()

                let title = HITitle()
                title.text = "Multplas MaxPressure Box Plot"
                options.title = title

                let legend = HILegend()
                legend.enabled = false
                options.legend = legend

                let xAxis = HIXAxis()
                xAxis.title = HITitle()
                xAxis.title.text = "模次"
           
                options.xAxis = [xAxis]

                let yAxis = HIYAxis()
                yAxis.title = HITitle()
                yAxis.title.text = "SPC_maxPressure"
                let plotLine = HIPlotLines()

                yAxis.plotLines = [plotLine]
                options.yAxis = [yAxis]

                //相形圖資料更新
                let observations = HIBoxplot()
                observations.name = "SPC_maxPressure"
                observations.color = HIColor(hexValue: "41505b")
                observations.data = self.boxdata
                observations.tooltip = HITooltip()
                observations.tooltip.headerFormat = "<em>No {point.key}</em><br/>"
                observations.tooltip.valueDecimals = 2

                
                //最大壓力本模次數值
                let nowData = HISpline()
                nowData.name = "Now"
                nowData.data = self.maxPressuredata
                nowData.color = HIColor(hexValue: "f59a44")
                nowData.marker = HIMarker()
                nowData.marker.symbol = "diamond"
                nowData.marker.fillColor = HIColor(name: "white")
                nowData.marker.lineColor = "#facf4c"
                nowData.tooltip = HITooltip()
                nowData.tooltip.pointFormat = "本模次數值: {point.y}"
                nowData.tooltip.valueDecimals = 2
                
                
                
                //離群值資料更新
                let outliers = HIScatter()
                outliers.name = "Outliers"
                outliers.color = HIColor(name: "white")
                outliers.data = self.outliers
                outliers.marker = HIMarker()
                outliers.marker.fillColor = HIColor(name: "white")
                outliers.marker.lineWidth = 1.5
                outliers.marker.lineColor = "#add666"
                outliers.marker.symbol = "circle"
                outliers.tooltip = HITooltip()
                outliers.tooltip.pointFormat = "離群值: {point.y}"
                outliers.tooltip.valueDecimals = 2
                

                
                //匡線款式
                let plotOptions = HIPlotOptions()
                plotOptions.series = HISeries()
                let animation = HIAnimationOptionsObject()
                animation.defer = 1
                plotOptions.series.animation = animation
                plotOptions.spline = HISpline()
                plotOptions.spline.marker = HIMarker()
                plotOptions.spline.marker.radius = 4
                plotOptions.spline.marker.lineColor = "#666666"
                plotOptions.spline.marker.lineWidth = 1
                options.plotOptions = plotOptions
                
                
                
                //離散值區間
                let boxArange = HIArearange()
                boxArange.name = "Range"
                boxArange.data = self.boxArrageData
                boxArange.color = HIColor(hexValue: "2f7ed8")
                boxArange.tooltip = HITooltip()
                boxArange.tooltip.valueDecimals = 2
                boxArange.marker = HIMarker()
                boxArange.marker.enabled = false
                boxArange.fillOpacity = 0.1
                boxArange.lineWidth = 0
                
                
                
                //圖表縮放
                let chart = HIChart()
                chart.zoomType = "x"
                chart.scrollablePlotArea = HIScrollablePlotArea()
                chart.scrollablePlotArea.minWidth = 300
                chart.scrollablePlotArea.scrollPositionX = 1
                options.chart = chart

                
                options.series = [boxArange, observations, outliers, nowData]

            
                //關閉有右上功能鍵
                let exporting = HIExporting()
                exporting.enabled = false
                options.exporting = exporting
                
                
                //浮水印
                let credict = HICredits()
                credict.enabled = false
                options.credits = credict

                chartView.options = options
                
                chartView.translatesAutoresizingMaskIntoConstraints = false
                
                self.MaxPressureView.addSubview(chartView)
                

                
                chartView.leadingAnchor.constraint(equalTo: MaxPressureView.leadingAnchor, constant: 0).isActive = true
                chartView.topAnchor.constraint(equalTo: MaxPressureView.topAnchor, constant: 5).isActive = true
                chartView.trailingAnchor.constraint(equalTo: MaxPressureView.trailingAnchor, constant: 0).isActive = true
                chartView.bottomAnchor.constraint(equalTo: MaxPressureView.bottomAnchor, constant: 0).isActive = true
                  
                
         //MARK: -壓力曲線圖繪製
                let PchartView = HIChartView(frame: view.bounds)
             
                PchartView.plugins = ["boost"]

                let Poptions = HIOptions()

                let Pchart = HIChart()
                Pchart.zoomType = "x"
                Poptions.chart = Pchart

                let Ptitle = HITitle()
                Ptitle.text = "Pressure Curve"
                Poptions.title = Ptitle



                let Ptooltip = HITooltip()
                Ptooltip.valueDecimals = 2
                Poptions.tooltip = Ptooltip
                

                let PxAxis = HIXAxis()
                
                PxAxis.type = "linear"
                PxAxis.tickInterval = 0.2
                let PplotLine = HIPlotLines()
                PplotLine.value = 1.63
                PplotLine.color = HIColor(name: "purple")
                PplotLine.width = 1
                PplotLine.label = HILabel()
                PplotLine.label.text = "保壓"
                PplotLine.label.style = HICSSObject()
                PplotLine.label.style.color = "gray"
                PxAxis.plotLines = [PplotLine]
                Poptions.xAxis = [PxAxis]
                
                let PyAxis = HIYAxis()
                PyAxis.title = HITitle()
                PyAxis.title.text = ""
                PyAxis.tickInterval = 100
                Poptions.yAxis = [PyAxis]
                
                
                var DD: [HISeries] = []
                for item in self.oldPressureCurve {
                    let PDataPoints = HISeries()
                    PDataPoints.name = "當秒壓力"
                    PDataPoints.data = item
                    PDataPoints.marker = HIMarker()
                    PDataPoints.marker.enabled = false
                    PDataPoints.lineWidth = 2
                    if item == self.oldPressureCurve.last {
                        PDataPoints.color = HIColor(hexValue: "6b79e4")
                    } else {
                        PDataPoints.color = HIColor(hexValue: "cccccc")
                    }
                   
                    DD.append(PDataPoints)
                }
                

                Poptions.series = DD
                
                //關閉有右上功能鍵
                let Pexporting = HIExporting()
                Pexporting.enabled = false
                Poptions.exporting = Pexporting
                
                
                //浮水印
                let Pcredict = HICredits()
                Pcredict.enabled = false
                Poptions.credits = Pcredict
                
                //關掉分類標籤
                let Plegend = HILegend()
                Plegend.enabled = false
                Poptions.legend = Plegend

                PchartView.options = Poptions
                
               
                
                PchartView.translatesAutoresizingMaskIntoConstraints = false

                self.PressureView.addSubview(PchartView)
                
                PchartView.leadingAnchor.constraint(equalTo: PressureView.leadingAnchor, constant: 0).isActive = true
                PchartView.topAnchor.constraint(equalTo: PressureView.topAnchor, constant: 5).isActive = true
                PchartView.trailingAnchor.constraint(equalTo: PressureView.trailingAnchor, constant: 0).isActive = true
                PchartView.bottomAnchor.constraint(equalTo: PressureView.bottomAnchor, constant: 0).isActive = true
                
          
                //MARK: -速度曲線圖繪製
                       let SchartView = HIChartView(frame: view.bounds)
                    
                       SchartView.plugins = ["boost"]

                       let Soptions = HIOptions()

                       let Schart = HIChart()
                       Schart.zoomType = "x"
                       Soptions.chart = Schart

                       let Stitle = HITitle()
                       Stitle.text = "Speed Curve"
                       Soptions.title = Stitle



                       let Stooltip = HITooltip()
                       Stooltip.valueDecimals = 2
                       Soptions.tooltip = Stooltip
                       

                       let SxAxis = HIXAxis()
                       SxAxis.type = "linear"
                       SxAxis.tickInterval = 0.2

                       Soptions.xAxis = [SxAxis]
                       
                       let SyAxis = HIYAxis()
                       SyAxis.title = HITitle()
                       SyAxis.title.text = ""
                       SyAxis.tickInterval = 20
                       Soptions.yAxis = [SyAxis]
                
                
                    var CC: [HISeries] = []
                    for item in self.oldSpeedCurve {
                        let SDataPoints = HISeries()
                        SDataPoints.name = "當秒速度"
                        SDataPoints.data = item
                        SDataPoints.marker = HIMarker()
                        SDataPoints.marker.enabled = false
                        SDataPoints.lineWidth = 2
                        if item == self.oldSpeedCurve.last {
                            SDataPoints.color = HIColor(hexValue: "6b79e4")
                        } else {
                            SDataPoints.color = HIColor(hexValue: "cccccc")
                        }
                        
                        CC.append(SDataPoints)
                    }


                       Soptions.series = CC
                       
                       //關閉有右上功能鍵
                       let Sexporting = HIExporting()
                       Sexporting.enabled = false
                       Soptions.exporting = Sexporting
                       
                       
                       //浮水印
                       let Scredict = HICredits()
                       Scredict.enabled = false
                       Soptions.credits = Scredict
                       
                       //關掉分類標籤
                       let Slegend = HILegend()
                       Slegend.enabled = false
                       Soptions.legend = Slegend

                       SchartView.options = Soptions
                       
                       SchartView.translatesAutoresizingMaskIntoConstraints = false

                       self.velocityView.addSubview(SchartView)
                       
                       SchartView.leadingAnchor.constraint(equalTo: velocityView.leadingAnchor, constant: 0).isActive = true
                       SchartView.topAnchor.constraint(equalTo: velocityView.topAnchor, constant: 5).isActive = true
                       SchartView.trailingAnchor.constraint(equalTo: velocityView.trailingAnchor, constant: 0).isActive = true
                       SchartView.bottomAnchor.constraint(equalTo: velocityView.bottomAnchor, constant: 0).isActive = true
            }
            
            
            
        }
        
        socket.connect()

       
       
    }
    
    
    
    
 //MARK: -取前50筆
    
    @IBAction func Choose50(_ sender: Any) {
        
        
        if self.choose == false {
            
            self.choose50B.isSelected = true
            
            
            
            
            //箱形圖繪製
            let chartView = HIChartView(frame: view.bounds)
            let options = HIOptions()

            let title = HITitle()
            title.text = "Multplas MaxPressure Box Plot"
            options.title = title

            let legend = HILegend()
            legend.enabled = false
            options.legend = legend

            let xAxis = HIXAxis()
            xAxis.title = HITitle()
            xAxis.title.text = "模次"
       
            options.xAxis = [xAxis]

            let yAxis = HIYAxis()
            yAxis.title = HITitle()
            yAxis.title.text = "SPC_maxPressure"
            let plotLine = HIPlotLines()

            yAxis.plotLines = [plotLine]
            options.yAxis = [yAxis]

            //相形圖資料更新
            let observations = HIBoxplot()
            observations.name = "SPC_maxPressure"
            observations.color = HIColor(hexValue: "41505b")
            observations.data = Array(self.boxdata[49...self.boxdata.count-1])
            observations.tooltip = HITooltip()
            observations.tooltip.headerFormat = "<em>No {point.key}</em><br/>"
            observations.tooltip.valueDecimals = 2

            
            //最大壓力本模次數值
            let nowData = HISpline()
            nowData.name = "Now"
            nowData.data = Array(self.maxPressuredata[49...self.maxPressuredata.count-1])
            nowData.color = HIColor(hexValue: "f59a44")
            nowData.marker = HIMarker()
            nowData.marker.symbol = "diamond"
            nowData.marker.fillColor = HIColor(name: "white")
            nowData.marker.lineColor = "#facf4c"
            nowData.tooltip = HITooltip()
            nowData.tooltip.pointFormat = "本模次數值: {point.y}"
            nowData.tooltip.valueDecimals = 2
            
            var newOutLiner: [[Any]] = []
            for arrayI in 0...self.outliers.count-1 {
                if self.outliers[arrayI][0] as! Int > 48 {
                    newOutLiner.append([self.outliers[arrayI][0] as! Int-49, self.outliers[arrayI][1]])
                }
            }
            
            //離群值資料更新
            let outliers = HIScatter()
            outliers.name = "Outliers"
            outliers.color = HIColor(name: "white")
            outliers.data = newOutLiner
            outliers.marker = HIMarker()
            outliers.marker.fillColor = HIColor(name: "white")
            outliers.marker.lineWidth = 1.5
            outliers.marker.lineColor = "#add666"
            outliers.marker.symbol = "circle"
            outliers.tooltip = HITooltip()
            outliers.tooltip.pointFormat = "離群值: {point.y}"
            outliers.tooltip.valueDecimals = 2
            
            //匡線款式
            let plotOptions = HIPlotOptions()
            plotOptions.series = HISeries()
            let animation = HIAnimationOptionsObject()
            animation.defer = 1
            plotOptions.series.animation = animation
            plotOptions.spline = HISpline()
            plotOptions.spline.marker = HIMarker()
            plotOptions.spline.marker.radius = 4
            plotOptions.spline.marker.lineColor = "#666666"
            plotOptions.spline.marker.lineWidth = 1
            options.plotOptions = plotOptions
            
            
            
            //離散值區間
            let boxArange = HIArearange()
            boxArange.name = "Range"
            boxArange.data = Array(self.boxArrageData[49...self.boxArrageData.count-1])
            boxArange.color = HIColor(hexValue: "2f7ed8")
            boxArange.tooltip = HITooltip()
            boxArange.tooltip.valueDecimals = 2
            boxArange.marker = HIMarker()
            boxArange.marker.enabled = false
            boxArange.fillOpacity = 0.1
            boxArange.lineWidth = 0
            
            
            
            //圖表縮放
            let chart = HIChart()
            chart.zoomType = "x"
            chart.scrollablePlotArea = HIScrollablePlotArea()
            chart.scrollablePlotArea.minWidth = 300
            chart.scrollablePlotArea.scrollPositionX = 1
            options.chart = chart

            
            options.series = [boxArange, observations, outliers, nowData]

        
            //關閉有右上功能鍵
            let exporting = HIExporting()
            exporting.enabled = false
            options.exporting = exporting
            
            
            //浮水印
            let credict = HICredits()
            credict.enabled = false
            options.credits = credict

            chartView.options = options
            
            chartView.translatesAutoresizingMaskIntoConstraints = false
            
            self.MaxPressureView.addSubview(chartView)
            

            
            chartView.leadingAnchor.constraint(equalTo: MaxPressureView.leadingAnchor, constant: 0).isActive = true
            chartView.topAnchor.constraint(equalTo: MaxPressureView.topAnchor, constant: 5).isActive = true
            chartView.trailingAnchor.constraint(equalTo: MaxPressureView.trailingAnchor, constant: 0).isActive = true
            chartView.bottomAnchor.constraint(equalTo: MaxPressureView.bottomAnchor, constant: 0).isActive = true
            

            
            let PchartView = HIChartView(frame: view.bounds)

            PchartView.plugins = ["boost"]

            let Poptions = HIOptions()

            let Pchart = HIChart()
            Pchart.zoomType = "x"
            Poptions.chart = Pchart

            let Ptitle = HITitle()
            Ptitle.text = "Pressure Curve"
            Poptions.title = Ptitle



            let Ptooltip = HITooltip()
            Ptooltip.valueDecimals = 2
            Poptions.tooltip = Ptooltip


            let PxAxis = HIXAxis()

            PxAxis.type = "linear"
            PxAxis.tickInterval = 0.2
            let PplotLine = HIPlotLines()
            PplotLine.value = 1.63
            PplotLine.color = HIColor(name: "purple")
            PplotLine.width = 1
            PplotLine.label = HILabel()

            PplotLine.label.text = "保壓"
            PplotLine.label.style = HICSSObject()
            PplotLine.label.style.color = "gray"
            PxAxis.plotLines = [PplotLine]
            Poptions.xAxis = [PxAxis]

            let PyAxis = HIYAxis()
            PyAxis.title = HITitle()
            PyAxis.title.text = ""
            PyAxis.tickInterval = 100
            Poptions.yAxis = [PyAxis]


            var DD: [HISeries] = []
            for item in 49...self.oldPressureCurve.count-1 {
                let PDataPoints = HISeries()
                PDataPoints.name = "當秒壓力"
                PDataPoints.data = self.oldPressureCurve[item]
                PDataPoints.marker = HIMarker()
                PDataPoints.marker.enabled = false
                PDataPoints.lineWidth = 2
                if item == self.oldPressureCurve.count-1 {

                    PDataPoints.color = HIColor(hexValue: "6b79e4")

                } else {

                    PDataPoints.color = HIColor(hexValue: "cccccc")
                }

                DD.append(PDataPoints)
            }



            Poptions.series = DD

            //關閉有右上功能鍵
            let Pexporting = HIExporting()
            Pexporting.enabled = false
            Poptions.exporting = Pexporting


            //浮水印
            let Pcredict = HICredits()
            Pcredict.enabled = false
            Poptions.credits = Pcredict

            //關掉分類標籤
            let Plegend = HILegend()
            Plegend.enabled = false
            Poptions.legend = Plegend

            PchartView.options = Poptions



            PchartView.translatesAutoresizingMaskIntoConstraints = false

            self.PressureView.addSubview(PchartView)

            PchartView.leadingAnchor.constraint(equalTo: PressureView.leadingAnchor, constant: 0).isActive = true
            PchartView.topAnchor.constraint(equalTo: PressureView.topAnchor, constant: 5).isActive = true
            PchartView.trailingAnchor.constraint(equalTo: PressureView.trailingAnchor, constant: 0).isActive = true
            PchartView.bottomAnchor.constraint(equalTo: PressureView.bottomAnchor, constant: 0).isActive = true




            let SchartView = HIChartView(frame: view.bounds)

            SchartView.plugins = ["boost"]

            let Soptions = HIOptions()

            let Schart = HIChart()
            Schart.zoomType = "x"
            Soptions.chart = Schart

            let Stitle = HITitle()
            Stitle.text = "Speed Curve"
            Soptions.title = Stitle



            let Stooltip = HITooltip()
            Stooltip.valueDecimals = 2
            Soptions.tooltip = Stooltip


            let SxAxis = HIXAxis()
            SxAxis.type = "linear"
            SxAxis.tickInterval = 0.2

            Soptions.xAxis = [SxAxis]

            let SyAxis = HIYAxis()
            SyAxis.title = HITitle()
            SyAxis.title.text = ""
            SyAxis.tickInterval = 20
            Soptions.yAxis = [SyAxis]


         var CC: [HISeries] = []
            for item in 49...self.oldSpeedCurve.count-1 {
             let SDataPoints = HISeries()
             SDataPoints.name = "當秒速度"
                SDataPoints.data = self.oldSpeedCurve[item]
             SDataPoints.marker = HIMarker()
             SDataPoints.marker.enabled = false
             SDataPoints.lineWidth = 2
                if item == self.oldSpeedCurve.count-1 {
                    SDataPoints.color = HIColor(hexValue: "6b79e4")
                } else {
                    SDataPoints.color = HIColor(hexValue: "cccccc")
                }

             CC.append(SDataPoints)
         }


            Soptions.series = CC

            //關閉有右上功能鍵
            let Sexporting = HIExporting()
            Sexporting.enabled = false
            Soptions.exporting = Sexporting


            //浮水印
            let Scredict = HICredits()
            Scredict.enabled = false
            Soptions.credits = Scredict

            //關掉分類標籤
            let Slegend = HILegend()
            Slegend.enabled = false
            Soptions.legend = Slegend

            SchartView.options = Soptions

            SchartView.translatesAutoresizingMaskIntoConstraints = false

            self.velocityView.addSubview(SchartView)

            SchartView.leadingAnchor.constraint(equalTo: velocityView.leadingAnchor, constant: 0).isActive = true
            SchartView.topAnchor.constraint(equalTo: velocityView.topAnchor, constant: 5).isActive = true
            SchartView.trailingAnchor.constraint(equalTo: velocityView.trailingAnchor, constant: 0).isActive = true
            SchartView.bottomAnchor.constraint(equalTo: velocityView.bottomAnchor, constant: 0).isActive = true



            self.choose = true

        } else {
            
            self.choose50B.isSelected = false
            
          

            
            //箱形圖繪製
            let chartView = HIChartView(frame: view.bounds)
            let options = HIOptions()

            let title = HITitle()
            title.text = "Multplas MaxPressure Box Plot"
            options.title = title

            let legend = HILegend()
            legend.enabled = false
            options.legend = legend

            let xAxis = HIXAxis()
            xAxis.title = HITitle()
            xAxis.title.text = "模次"
       
            options.xAxis = [xAxis]

            let yAxis = HIYAxis()
            yAxis.title = HITitle()
            yAxis.title.text = "SPC_maxPressure"
            let plotLine = HIPlotLines()

            yAxis.plotLines = [plotLine]
            options.yAxis = [yAxis]

            //相形圖資料更新
            let observations = HIBoxplot()
            observations.name = "SPC_maxPressure"
            observations.color = HIColor(hexValue: "41505b")
            observations.data = self.boxdata
            observations.tooltip = HITooltip()
            observations.tooltip.headerFormat = "<em>No {point.key}</em><br/>"
            observations.tooltip.valueDecimals = 2

            
            //最大壓力本模次數值
            let nowData = HISpline()
            nowData.name = "Now"
            nowData.data = self.maxPressuredata
            nowData.color = HIColor(hexValue: "f59a44")
            nowData.marker = HIMarker()
            nowData.marker.symbol = "diamond"
            nowData.marker.fillColor = HIColor(name: "white")
            nowData.marker.lineColor = "#facf4c"
            nowData.tooltip = HITooltip()
            nowData.tooltip.pointFormat = "本模次數值: {point.y}"
            nowData.tooltip.valueDecimals = 2
            
            
            
            //離群值資料更新
            let outliers = HIScatter()
            outliers.name = "Outliers"
            outliers.color = HIColor(name: "white")
            outliers.data = self.outliers
            outliers.marker = HIMarker()
            outliers.marker.fillColor = HIColor(name: "white")
            outliers.marker.lineWidth = 1.5
            outliers.marker.lineColor = "#add666"
            outliers.marker.symbol = "circle"
            outliers.tooltip = HITooltip()
            outliers.tooltip.pointFormat = "離群值: {point.y}"
            outliers.tooltip.valueDecimals = 2
            

            
            //匡線款式
            let plotOptions = HIPlotOptions()
            plotOptions.series = HISeries()
            let animation = HIAnimationOptionsObject()
            animation.defer = 1
            plotOptions.series.animation = animation
            plotOptions.spline = HISpline()
            plotOptions.spline.marker = HIMarker()
            plotOptions.spline.marker.radius = 4
            plotOptions.spline.marker.lineColor = "#666666"
            plotOptions.spline.marker.lineWidth = 1
            options.plotOptions = plotOptions
            
            
            
            //離散值區間
            let boxArange = HIArearange()
            boxArange.name = "Range"
            boxArange.data = self.boxArrageData
            boxArange.color = HIColor(hexValue: "2f7ed8")
            boxArange.tooltip = HITooltip()
            boxArange.tooltip.valueDecimals = 2
            boxArange.marker = HIMarker()
            boxArange.marker.enabled = false
            boxArange.fillOpacity = 0.1
            boxArange.lineWidth = 0
            
            
            
            //圖表縮放
            let chart = HIChart()
            chart.zoomType = "x"
            chart.scrollablePlotArea = HIScrollablePlotArea()
            chart.scrollablePlotArea.minWidth = 300
            chart.scrollablePlotArea.scrollPositionX = 1
            options.chart = chart

            
            options.series = [boxArange, observations, outliers, nowData]

        
            //關閉有右上功能鍵
            let exporting = HIExporting()
            exporting.enabled = false
            options.exporting = exporting
            
            
            //浮水印
            let credict = HICredits()
            credict.enabled = false
            options.credits = credict

            chartView.options = options
            
            chartView.translatesAutoresizingMaskIntoConstraints = false
            
            self.MaxPressureView.addSubview(chartView)
            

            
            chartView.leadingAnchor.constraint(equalTo: MaxPressureView.leadingAnchor, constant: 0).isActive = true
            chartView.topAnchor.constraint(equalTo: MaxPressureView.topAnchor, constant: 5).isActive = true
            chartView.trailingAnchor.constraint(equalTo: MaxPressureView.trailingAnchor, constant: 0).isActive = true
            chartView.bottomAnchor.constraint(equalTo: MaxPressureView.bottomAnchor, constant: 0).isActive = true
            
            
            let PchartView = HIChartView(frame: view.bounds)

            PchartView.plugins = ["boost"]

            let Poptions = HIOptions()

            let Pchart = HIChart()
            Pchart.zoomType = "x"
            Poptions.chart = Pchart

            let Ptitle = HITitle()
            Ptitle.text = "Pressure Curve"
            Poptions.title = Ptitle



            let Ptooltip = HITooltip()
            Ptooltip.valueDecimals = 2
            Poptions.tooltip = Ptooltip


            let PxAxis = HIXAxis()

            PxAxis.type = "linear"
            PxAxis.tickInterval = 0.2
            let PplotLine = HIPlotLines()
            PplotLine.value = 1.63
            PplotLine.color = HIColor(name: "purple")
            PplotLine.width = 1
            PplotLine.label = HILabel()

            PplotLine.label.text = "保壓"
            PplotLine.label.style = HICSSObject()
            PplotLine.label.style.color = "gray"
            PxAxis.plotLines = [PplotLine]
            Poptions.xAxis = [PxAxis]

            let PyAxis = HIYAxis()
            PyAxis.title = HITitle()
            PyAxis.title.text = ""
            PyAxis.tickInterval = 100
            Poptions.yAxis = [PyAxis]


            var DD: [HISeries] = []
            for item in 0...self.oldPressureCurve.count-1 {
                let PDataPoints = HISeries()
                PDataPoints.name = "當秒壓力"
                PDataPoints.data = self.oldPressureCurve[item]
                PDataPoints.marker = HIMarker()
                PDataPoints.marker.enabled = false
                PDataPoints.lineWidth = 2
                if item == self.oldPressureCurve.count-1 {

                    PDataPoints.color = HIColor(hexValue: "6b79e4")

                } else {

                    PDataPoints.color = HIColor(hexValue: "cccccc")
                }

                DD.append(PDataPoints)
            }



            Poptions.series = DD

            //關閉有右上功能鍵
            let Pexporting = HIExporting()
            Pexporting.enabled = false
            Poptions.exporting = Pexporting


            //浮水印
            let Pcredict = HICredits()
            Pcredict.enabled = false
            Poptions.credits = Pcredict

            //關掉分類標籤
            let Plegend = HILegend()
            Plegend.enabled = false
            Poptions.legend = Plegend

            PchartView.options = Poptions



            PchartView.translatesAutoresizingMaskIntoConstraints = false

            self.PressureView.addSubview(PchartView)

            PchartView.leadingAnchor.constraint(equalTo: PressureView.leadingAnchor, constant: 0).isActive = true
            PchartView.topAnchor.constraint(equalTo: PressureView.topAnchor, constant: 5).isActive = true
            PchartView.trailingAnchor.constraint(equalTo: PressureView.trailingAnchor, constant: 0).isActive = true
            PchartView.bottomAnchor.constraint(equalTo: PressureView.bottomAnchor, constant: 0).isActive = true




            let SchartView = HIChartView(frame: view.bounds)

            SchartView.plugins = ["boost"]

            let Soptions = HIOptions()

            let Schart = HIChart()
            Schart.zoomType = "x"
            Soptions.chart = Schart

            let Stitle = HITitle()
            Stitle.text = "Speed Curve"
            Soptions.title = Stitle



            let Stooltip = HITooltip()
            Stooltip.valueDecimals = 2
            Soptions.tooltip = Stooltip


            let SxAxis = HIXAxis()
            SxAxis.type = "linear"
            SxAxis.tickInterval = 0.2

            Soptions.xAxis = [SxAxis]

            let SyAxis = HIYAxis()
            SyAxis.title = HITitle()
            SyAxis.title.text = ""
            SyAxis.tickInterval = 20
            Soptions.yAxis = [SyAxis]


         var CC: [HISeries] = []
            for item in 0...self.oldSpeedCurve.count-1 {
             let SDataPoints = HISeries()
             SDataPoints.name = "當秒速度"
                SDataPoints.data = self.oldSpeedCurve[item]
             SDataPoints.marker = HIMarker()
             SDataPoints.marker.enabled = false
             SDataPoints.lineWidth = 2
                if item == self.oldSpeedCurve.count-1 {
                    SDataPoints.color = HIColor(hexValue: "6b79e4")
                } else {
                    SDataPoints.color = HIColor(hexValue: "cccccc")
                }

             CC.append(SDataPoints)
         }


            Soptions.series = CC

            //關閉有右上功能鍵
            let Sexporting = HIExporting()
            Sexporting.enabled = false
            Soptions.exporting = Sexporting


            //浮水印
            let Scredict = HICredits()
            Scredict.enabled = false
            Soptions.credits = Scredict

            //關掉分類標籤
            let Slegend = HILegend()
            Slegend.enabled = false
            Soptions.legend = Slegend

            SchartView.options = Soptions

            SchartView.translatesAutoresizingMaskIntoConstraints = false

            self.velocityView.addSubview(SchartView)

            SchartView.leadingAnchor.constraint(equalTo: velocityView.leadingAnchor, constant: 0).isActive = true
            SchartView.topAnchor.constraint(equalTo: velocityView.topAnchor, constant: 5).isActive = true
            SchartView.trailingAnchor.constraint(equalTo: velocityView.trailingAnchor, constant: 0).isActive = true
            SchartView.bottomAnchor.constraint(equalTo: velocityView.bottomAnchor, constant: 0).isActive = true




            self.choose = false
        }


        print(self.choose)

    }
    
    
    
    
    
    
//MARK: -當日資料
    
    //將當日射出資訊傳入
    func getData() {
        print("====================================================")
        let url = URL(string: "http://140.135.97.69:8787/TodayINJdata")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    //解碼ＪＳＯＮ
                    let createUserResponse = try decoder.decode(injectiontheDayData.self, from: data)
                   // print(createUserResponse.data)
                            
                    //如果資料庫無資料，就不讀取
                    if createUserResponse.data.count == 0 {
                        
                    } else {
                        for i in 0...createUserResponse.data.count-1 {
                            
                            //離群值的暫存序號
                            self.outerlierIndex += 1
                            
                            let maxPStr: String = createUserResponse.data[i].SPC_maxPressure.replacingOccurrences(of: ",", with: "")
                            //最大壓力傳到外部儲存
                            self.maxPressuredata.append(Float(maxPStr)!)
                            self.SPC_maxpressure = Float(maxPStr)!
                            
                            //箱型圖資料
                            self.boxdata.append(self.medial(listArr: self.maxPressuredata, indexAll: i).boxDatas)
                            //箱型圖區間資料
                            self.boxArrageData.append(self.medial(listArr: self.maxPressuredata, indexAll: i).boxrange)
                            //離散點資料
                            for item in self.medial(listArr: self.maxPressuredata, indexAll: i).outDatas {
                                self.outliers.append(item)
                            }
                            
                            //充填時間＋保壓時間=總時間
                            self.AllTime = Float(createUserResponse.data[i].SPC_fillingTime)! + Float(createUserResponse.data[i].PACK_T_1st)! + Float(createUserResponse.data[i].PACK_T_2nd)! + Float(createUserResponse.data[i].PACK_T_3rd)!
                            
                            //最大壓力曲線的值
                            self.oldPressureCurve.append(self.tidyData(arryStr: createUserResponse.data[i].Pressure_Curve, FullT: self.AllTime).pressureData)
                            
                            //最大速度曲線的值
                            self.oldSpeedCurve.append(self.tidyData(arryStr: createUserResponse.data[i].Pressure_Curve, FullT: self.AllTime).speedData)
                        }
                    }
          

                    

                 
                } catch  {
                    print(error)
                }
            }
            
            
        }.resume()
        
    }
    
    
//MARK: -四分位數計算
    func medial(listArr: Array<Float>, indexAll: Int) -> (boxDatas: [Float], outDatas: [[Any]], boxrange: [Float]) {
        
        //此indexAll是用來計算當前最大壓力中,不在boxrange的序號
        
        let list = listArr.sorted(by: <)
        
        var Q1: Float = 0
        var Q2: Float = 0
        var Q3: Float = 0
        
        if list.count == 1 {
            
            Q1 = list.first!
            Q2 = list.first!
            Q3 = list.first!
            
            return ([list.first!, list.first!, list.first!, list.first!, list.first!],[],[list.first!,list.first!])
            
        } else {
            
            //求取Q2
            if list.count % 2 == 0 {
                let index = Int((list.count - 1) / 2)
                Q2 = (list[index] + list[index + 1]) / 2
                let half = list.count / 2
                if half  % 2 == 0 {
                    let index = Int((half - 1) / 2)
                    Q1 = (list[index] + list[index + 1]) / 2
                    Q3 = (list[index + half] + list[index + 1 + half]) / 2
                } else {
                    let index = Int((half - 1) / 2)
                    Q1 = list[index]
                    Q3 = list[index + half]
                }
            } else {
                
                let index = Int((list.count - 1) / 2)
                Q2 = list[index]
                
                let half = (list.count - 1)  / 2
                if half  % 2 == 0 {
                    let index = Int((half - 1) / 2)
                    Q1 = (list[index] + list[index + 1]) / 2
                    Q3 = (list[index + half + 1] + list[index + 1 + half + 1]) / 2
                } else {
                    let index = Int((half - 1) / 2)
                    Q1 = list[index]
                    Q3 = list[index + half + 1]
                }
            }

            //print("Q1: \(Q1),Q2: \(Q2),Q3: \(Q3)")
            
            let IQR = Q3 - Q1
            
            if IQR == 0 {
                
                return ([list.first!, list.first!, list.first!, list.first!, list.first!],[],[list.first!,list.first!])
                
            } else {
                
                let boxmin = Q1 - 1.5 * IQR
                let boxmax = Q3 + 1.5 * IQR
                var boxData = [Float]()
                
                //過濾偏差值較大的數

                let boxDataA = listArr.filter({ $0 > boxmin })

                boxData = boxDataA.filter({ $0 < boxmax })

               
                
                let max:Float = boxData.max()!
                let min:Float = boxData.min()!
         
                //計算當最大壓力array離散點
                var pointOut: [[Any]] = []
                

                for i in 0...listArr.count-1 {

                    if listArr[i] < boxmin || listArr[i] > boxmax {
                        
                        pointOut.append([indexAll, listArr[i]])
                        
                    } else {
                      
                    }
                }

        //        print(boxmin)
        //        print(boxmax)
        //        print(boxData)
        //        print(max)
        //        print(min)
        //        print(pointOut)
                
                return ([min, Q1, Q2, Q3, max], pointOut, [boxmin,boxmax])
                
            }
            
        }
       

    }

    
    //處理射出曲線資料
    func tidyData(arryStr: String, FullT: Float) -> (pressureData: [[Float]], speedData: [[Float]]) {
        let str = NSString(string: arryStr)
        let div = str.components(separatedBy: ",")
  //      print(div)
        //將每筆資料處理成Float
        var PressureArray:[Float] = []
        for data in div {
            PressureArray.append(Float(data) ?? 0)
        }
        let pressureArr = Array(PressureArray[499...749])
        let speedArr = Array(PressureArray[749...999])
 //       print(pressureArr)
        //過濾掉不是0的數字
        let pressureFillter = pressureArr.filter{ $0 != 0}
        
        var pressureData: [[Float]] = []
        var set: Float = 0
        
        let TimeInterval: Float = (FullT / Float(pressureFillter.count - 1))
        for data in pressureFillter {
            pressureData.append([set, data])
            
            set += TimeInterval
           
        }
 //       print(pressureData)
        
        //抓取壓力曲線中不為零的序號
        var Datalist: [Int] = []
        var i = 0
        for data in pressureArr {
            if data != 0 {
                Datalist.append(i)
            }
            i += 1
        }
        //利用上方抓取壓力曲線中不為0的序號再到速度曲線資料中過濾
        var speedFillter: [Float] = []
        for list in Datalist {
            speedFillter.append(speedArr[list])
        }

        //整理速度曲線，將資料整理成要使用的型態
        //最終資料
        var speedData: [[Float]] = []
        var set2: Float = 0
        for data in speedFillter {
            speedData.append([set2, data])
            set2 += TimeInterval
        }
        return (pressureData, speedData)
    }
  
    

    
}
