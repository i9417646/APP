//
//  injectionProductViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2021/12/8.
//

import UIKit
import Highcharts

class injectionProductViewController: UIViewController {
    
    //前一頁傳進來的資料
    var productDate: String = ""
    var imgURL: String = ""
    var shortshot: String = ""
    var shotPercent: String = ""
    var weight: String = ""
    var pressureCurve: String = ""
    
    //壓力 速度分割後陣列
    var PressureVectorArray: [Float] = []
    
    //UI
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productWeight: UILabel!
    @IBOutlet weak var productSituation: UILabel!
    @IBOutlet weak var shortshotPercent: UILabel!
    @IBOutlet weak var HIView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            
            self.UIData()
            
            self.CurveHI()

        }



        // Do any additional setup after loading the view.
    }
    
    //將資料放進去
    func UIData() {
        self.productName.text = productDate
        self.img.load(urlString: imgURL)
        self.productWeight.text = self.weight
        self.productSituation.text = self.shortshot == "1" ? "短射" : "完整"
        self.shortshotPercent.text = self.shotPercent == "0" ? "-" : "\(self.shotPercent)"
    }
    
    //整理壓力和速度資料
    func PressureVectorData() {
        let str = NSString(string: self.pressureCurve)
        let div = str.components(separatedBy: ",")
        var b:[Float] = []
        for i in div {
            b.append(Float(i) ?? 0)
        }
        self.PressureVectorArray = b
    }

    //壓力 速度highChart圖
    func CurveHI() {
        
        //處理壓力、速度資料
        self.PressureVectorData()
        
        
        let chartView = HIChartView(frame: view.bounds)
        chartView.theme = "brand-light"
        chartView.plugins = ["series-label"]

       let options = HIOptions()
        
//        let chart = HIChart()
//        chart.scrollablePlotArea = HIScrollablePlotArea()
//        chart.scrollablePlotArea.minWidth = 700
//        options.chart = chart

       let title = HITitle()
       title.text = ""
       options.title = title


        let xAxis = HIXAxis()
        xAxis.gridLineWidth = 1
        xAxis.labels = HILabels()
        xAxis.labels.align = "left"
        xAxis.labels.x = 3
        xAxis.labels.y = 12
//        xAxis.title = HITitle()
//        xAxis.title.text = "個數"
        xAxis.type = "linear"
        options.xAxis = [xAxis]
        
        
        
        
        let leftYAxis = HIYAxis()
        leftYAxis.title = HITitle()
        leftYAxis.title.text = "射出壓力"
        leftYAxis.labels = HILabels()
        leftYAxis.labels.align = "left"
        leftYAxis.labels.x = -6
        leftYAxis.labels.y = 16
        leftYAxis.labels.format = "{value:.,0f}"
       leftYAxis.showFirstLabel = false

        let rightYAxis = HIYAxis()
        rightYAxis.linkedTo = 0
        rightYAxis.gridLineWidth = 0
        rightYAxis.opposite = true
        rightYAxis.title = HITitle()
        rightYAxis.title.text = "射出速度"
        rightYAxis.labels = HILabels()
        rightYAxis.labels.align = "right"
        rightYAxis.labels.x = 6
        rightYAxis.labels.y = 16
        rightYAxis.labels.format = "{value:.,0f}"
        rightYAxis.showFirstLabel = false

        options.yAxis = [leftYAxis, rightYAxis]
        
     
       let legend = HILegend()
       legend.align = "center"
       legend.verticalAlign = "bottom"
        legend.borderWidth = 0
       options.legend = legend
        
        //浮水印
        let credict = HICredits()
        credict.enabled = false
        options.credits = credict

        
        let tooltip = HITooltip()
        tooltip.shared = true
        options.tooltip = tooltip
        
       let plotOptions = HIPlotOptions()
       plotOptions.series = HISeries()
       plotOptions.series.cursor = "pointer"
       plotOptions.series.label = HILabel()
       plotOptions.series.marker = HIMarker()
       plotOptions.series.marker.lineWidth = 1
       plotOptions.series.label.connectorAllowed = false
       
       options.plotOptions = plotOptions

       let installation = HISeries()
       installation.name = "壓力"
        installation.data = Array(self.PressureVectorArray[499...749])
        print(Array(self.PressureVectorArray[499...749]))

       let manufacturing = HISeries()
       manufacturing.name = "速度"
       manufacturing.data = Array(self.PressureVectorArray[749...999])
        print(Array(self.PressureVectorArray[749...999]))

     

       options.series = [installation, manufacturing]

//       let responsive = HIResponsive()
//       let rules = HIRules()
//       rules.condition = HICondition()
//       rules.condition.maxWidth = 500
//       rules.chartOptions = [
//         "legend": [
//            "layout": "horizontal",
//            "align": "center",
//            "verticalAlign": "bottom"
//         ]
//       ]
//       responsive.rules = [rules]
//       options.responsive = responsive
//
//
        
        //關閉有右上功能鍵
        let exporting = HIExporting()
        exporting.enabled = false
        options.exporting = exporting

       chartView.options = options
    
    
        chartView.translatesAutoresizingMaskIntoConstraints = false

        self.HIView.addSubview(chartView)
        chartView.leadingAnchor.constraint(equalTo: HIView.leadingAnchor, constant: 0).isActive = true
        chartView.topAnchor.constraint(equalTo: HIView.topAnchor, constant: 0).isActive = true
        chartView.trailingAnchor.constraint(equalTo: HIView.trailingAnchor, constant: 0).isActive = true
        chartView.bottomAnchor.constraint(equalTo: HIView.bottomAnchor, constant: 0).isActive = true
        
        
         }
}



