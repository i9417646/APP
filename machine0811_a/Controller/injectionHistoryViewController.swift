//
//  injectionHistoryViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2021/11/26.
//

import UIKit
import Highcharts

class injectionHistoryViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
    //UI
    @IBOutlet weak var HCTop: UIView!
    @IBOutlet weak var HCCenter: UIView!
    @IBOutlet weak var HCBottom: UIView!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var chooseLabel: UITextField!
    @IBOutlet weak var analysisTop: UIView!
    @IBOutlet weak var analysisCenter: UIView!
    @IBOutlet weak var analysisBottom: UIView!
    
    //分析項目名稱
    let datas = ["週期時間","填充時間","儲料時間","螺桿轉速","最大射出壓力","背壓","起始位置","終點位置","V/P轉換壓力","V/P轉換位置","最小殘量"]
    
    
    
    //想選擇的資料
    var nowChoose: String = "週期時間"
    
    //想選擇的資料(英文)
    var nowChooseEnglish: String = "SPC_cycleTime"
    
    //post送進來的資料
    var injectData: [rejectionData] = []
    
    //highgChart 週期時間 與數量資料(s)
    var cycleTimeData:[[String:Any]] = []
    
    //highgChart 填充時間 與數量資料(s)
    var fillingTimeData:[[String:Any]] = []
    
    //highgChart 儲料時間 與數量資料(s)
    var meteringTimeData:[[String:Any]] = []
    
    //highgChart 螺桿轉速 與數量資料(rpm)
    var screwSpeedData:[[String:Any]] = []
    
    //highgChart 最大射出壓力 與數量資料(kgf/cm^2)
    var maxPressureData:[[String:Any]] = []
    
    //highgChart 背壓 與數量資料(kgf/cm^2)
    var suckBackPressureData:[[String:Any]] = []
    
    //highgChart 起始位置 與數量資料(mm)
    var meteringEndPosData:[[String:Any]] = []
    
    //highgChart 終點位置 與數量資料(mm)
    var minResidueData:[[String:Any]] = []
    
    //highgChart V/P轉換壓力 與數量資料(kgf/cm^2)
    var vpSwitchPressureData:[[String:Any]] = []
    
    //highgChart V/P轉換位置 與數量資料(mm)
    var vpSwitchPosData:[[String:Any]] = []
    
    //highgChart 最小殘量 與數量資料(mm)
    var finalResidueData:[[String:Any]] = []
    
    //百分比整理後相關資料
    var circleDataRelated:[circleDataStruct] = []
    
    //百分比整理後不相關資料
    var circleDataUnrelated:[circleDataStruct] = []
    
    //暫存圓餅圖
    var circleUIView:[UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            //UI樣式
            self.UIstyles()
            //因為進來頁面前會先跑一次,必須先凍結選單
            self.chooseLabel.isEnabled = false
            //load資料進來
            self.getData()
            //分析項目選單
            self.labelselector()
            //相關性分析
            self.computedanalysisRelated()
            

        }
        

   
    }


    
//MARK: -UI樣式
    //UI樣式
    func UIstyles(){
        //邊框框線
        let leftBorder = CALayer()
        leftBorder.frame = CGRect(x: 0, y: 0, width: 1, height: HCCenter.frame.size.height)
        leftBorder.backgroundColor = UIColor(displayP3Red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        let rightBorder = CALayer()
        rightBorder.frame = CGRect(x: HCCenter.frame.size.width - 1, y: 0, width: 1, height: HCCenter.frame.size.height)
        rightBorder.backgroundColor = UIColor(displayP3Red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        HCCenter.layer.addSublayer(leftBorder)
        HCCenter.layer.addSublayer(rightBorder)
        
        HCTop.layer.borderWidth = 1
        HCTop.layer.borderColor = UIColor(displayP3Red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        
        HCBottom.layer.borderWidth = 1
        HCBottom.layer.borderColor = UIColor(displayP3Red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        
        
        //圓角[右上,左上]
        HCTop.clipsToBounds = true
        HCTop.layer.cornerRadius = 8
        HCTop.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        //圓角[右下,左下]
        HCBottom.clipsToBounds = true
        HCBottom.layer.cornerRadius = 8
        HCBottom.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        projectLabel.layer.cornerRadius = 5
        projectLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        projectLabel.layer.borderWidth = 1
        projectLabel.layer.borderColor = UIColor(displayP3Red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        
        chooseLabel.layer.cornerRadius = 5
        chooseLabel.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        chooseLabel.layer.borderWidth = 1
        chooseLabel.layer.borderColor = UIColor(displayP3Red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        
        //相關性分析邊框框線
        analysisTop.layer.borderWidth = 1
        analysisTop.layer.borderColor = UIColor(displayP3Red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        
        let anleftBorder = CALayer()
        anleftBorder.frame = CGRect(x: 0, y: 0, width: 1, height: analysisCenter.frame.size.height)
        anleftBorder.backgroundColor = UIColor(displayP3Red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        let anrightBorder = CALayer()
        anrightBorder.frame = CGRect(x: analysisCenter.frame.size.width - 1, y: 0, width: 1, height: analysisCenter.frame.size.height)
        anrightBorder.backgroundColor = UIColor(displayP3Red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        analysisCenter.layer.addSublayer(anleftBorder)
        analysisCenter.layer.addSublayer(anrightBorder)
        let anBleftBorder = CALayer()
        anBleftBorder.frame = CGRect(x: 0, y: 0, width: 1, height: analysisCenter.frame.size.height + 1)
        anBleftBorder.backgroundColor = UIColor(displayP3Red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        let anBrightBorder = CALayer()
        anBrightBorder.frame = CGRect(x: analysisCenter.frame.size.width - 1, y: 0, width: 1, height: analysisCenter.frame.size.height + 1)
        anBrightBorder.backgroundColor = UIColor(displayP3Red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        let anBBottomBorder = CALayer()
        anBBottomBorder.frame = CGRect(x: 0, y: analysisCenter.frame.size.height - 1, width: analysisCenter.frame.size.width, height: 1)
        anBBottomBorder.backgroundColor = UIColor(displayP3Red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        analysisBottom.layer.addSublayer(anBleftBorder)
        analysisBottom.layer.addSublayer(anBrightBorder)
        analysisBottom.layer.addSublayer(anBBottomBorder)
        
        //相關性分析圓角
        //圓角[右上,左上]
        analysisTop.clipsToBounds = true
        analysisTop.layer.cornerRadius = 8
        analysisTop.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        //圓角[右下,左下]
        analysisBottom.clipsToBounds = true
        analysisBottom.layer.cornerRadius = 8
        analysisBottom.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
//MARK: -分析項目選單製作
    func labelselector() {
        //關閉UITextField開啟鍵盤功能
        chooseLabel.autocorrectionType = .no
        
        let pickerView = UIPickerView()
        chooseLabel.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        
        //UITextField預設工具變成UIPickerView
        chooseLabel.inputView = pickerView
        
        //隱藏輔助工具
        let shortcut:UITextInputAssistantItem = chooseLabel.inputAssistantItem
        shortcut.leadingBarButtonGroups = []
        shortcut.trailingBarButtonGroups = []
        //預設選項
        chooseLabel.text = self.datas[0]
        chooseLabel.tag = 100
        
    }
    
//MARK: -HighChart圖表
    //highChart圖表
    private  func HightChartView(){
        
        let chartView = HIChartView(frame: view.bounds)
        chartView.plugins = ["boost"]

        let options = HIOptions()

        let chart = HIChart()
        chart.zoomType = "x"
        options.chart = chart

        let title = HITitle()
        title.text = "  "
        options.title = title
//
//           let subtitle = HISubtitle()
//           subtitle.text = "Using the Boost module"
//           options.subtitle = subtitle

        let tooltip = HITooltip()
        tooltip.headerFormat = "<b>{point.key}</b><br />"
        //y小數點位數
        tooltip.valueDecimals = 2
        tooltip.pointFormat = "\(self.nowChoose) = {point.y}"
        options.tooltip = tooltip

        let xAxis = HIXAxis()
        xAxis.title = HITitle()
        xAxis.title.text = "數量"
        xAxis.type = "linear"
        options.xAxis = [xAxis]
        
        let yAxis = HIYAxis()
        yAxis.title = HITitle()
        yAxis.type = "linear"
        yAxis.title.text = "\(self.nowChoose)"
        yAxis.accessibility = HIAccessibility()
        
        options.yAxis = [yAxis]

        let hourlyDataPoints = HISeries()
        hourlyDataPoints.name = "\(self.nowChoose)"
        hourlyDataPoints.lineWidth = 1

        hourlyDataPoints.data = getHIData()
        //增加點的個數
        hourlyDataPoints.turboThreshold = 10000

        options.series = [hourlyDataPoints]

        //關閉有右上功能鍵
        let exporting = HIExporting()
        exporting.enabled = false
        options.exporting = exporting
        
        
        //浮水印
        let credict = HICredits()
        credict.enabled = false
        options.credits = credict
        
        //highChart事件
        let plotOptions = HIPlotOptions()
        plotOptions.scatter = HIScatter()
        plotOptions.scatter.point = HIPoint()
        plotOptions.scatter.point.events = HIEvents()
        
        let chartSeries = HISeries()
        plotOptions.series = chartSeries
        let chartPoint = HIPoint()
        plotOptions.series.point = chartPoint
        
        let chartEvents = HIEvents()
        plotOptions.series.point.events = chartEvents
        
        
        //點擊事件
        //點選折線圖顯示過去射出單筆詳細資料
        let chartFunction = HIFunction(closure: { context in
            
            //點擊到的物件
            guard let context = context else { return }

            //加入詳細資訊視窗
            let view = self.storyboard?.instantiateViewController(identifier: "injectionProduct") as? injectionProductViewController
            //傳遞使用者點擊折線圖的那筆資訊
            view!.productDate = context.getProperty("this.name")! as! String
            view!.imgURL = context.getProperty("this.url")! as! String
           view!.shortshot = context.getProperty("this.shortshot")! as! String
            view!.shotPercent = context.getProperty("this.shotPercent")! as! String
            view!.weight = context.getProperty("this.weight")! as! String
            view!.pressureCurve = context.getProperty("this.pressureCurve")! as! String
            
            self.present(view!, animated: true, completion: nil)
           
 
        
        }, properties: ["this.category", "this.name", "this.url", "this.shortshot", "this.shotPercent", "this.weight","this.pressureCurve"])
        
        plotOptions.series.point.events.click = chartFunction
        options.plotOptions = plotOptions
  
        chartView.options = options

        chartView.translatesAutoresizingMaskIntoConstraints = false

        self.HCBottom.addSubview(chartView)
        chartView.leadingAnchor.constraint(equalTo: HCBottom.leadingAnchor, constant: 0).isActive = true
        chartView.topAnchor.constraint(equalTo: HCBottom.topAnchor, constant: 30).isActive = true
        chartView.trailingAnchor.constraint(equalTo: HCBottom.trailingAnchor, constant: -20).isActive = true
        chartView.bottomAnchor.constraint(equalTo: HCBottom.bottomAnchor, constant: 0).isActive = true

    }
    
    //選到哪筆
    private func getHIData() -> [[String:Any]] {
        
        //資料結構
//       [
//            [
//                "url": "http://140.135.97.72:8787/INJPhoto/2021_6_1_12_30_24.jpg",
//                "x": 5,
//                "y": 69.27,
//                "name": "2021-06-01T12:30:24.870Z"]
//        ]
        var chooseData = [[String: Any]]()
        if self.nowChoose == "週期時間"{
            chooseData = self.cycleTimeData
        } else if self.nowChoose == "填充時間" {
            chooseData = self.fillingTimeData
        } else if self.nowChoose == "儲料時間" {
            chooseData = self.meteringTimeData
        } else if self.nowChoose == "螺桿轉速" {
            chooseData = self.screwSpeedData
        } else if self.nowChoose == "最大射出壓力" {
            chooseData = self.maxPressureData
        } else if self.nowChoose == "背壓" {
            chooseData = self.suckBackPressureData
        } else if self.nowChoose == "起始位置" {
            chooseData = self.meteringEndPosData
        } else if self.nowChoose == "終點位置" {
            chooseData = self.minResidueData
        } else if self.nowChoose == "V/P轉換壓力" {
            chooseData = self.vpSwitchPressureData
        } else if self.nowChoose == "V/P轉換位置" {
            chooseData = self.vpSwitchPosData
        } else if self.nowChoose == "最小殘量" {
            return self.finalResidueData
        }
        return chooseData
      }
    
    
    

    
//MARK: -分析資料圓餅圖
    func computedanalysisRelated(){
        
        print("跑一次post")
        //loading圖示
        let activityIndicator1 = UIActivityIndicatorView(style: .medium)
        activityIndicator1.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator1.isUserInteractionEnabled = false
        activityIndicator1.startAnimating()
        activityIndicator1.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        let activityIndicator2 = UIActivityIndicatorView(style: .medium)
        activityIndicator2.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator2.isUserInteractionEnabled = false
        activityIndicator2.startAnimating()
        activityIndicator2.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        analysisCenter.addSubview(activityIndicator1)
        analysisBottom.addSubview(activityIndicator2)
        
        activityIndicator1.centerXAnchor.constraint(equalTo: analysisCenter.centerXAnchor, constant: 0).isActive = true
        activityIndicator1.centerYAnchor.constraint(equalTo: analysisCenter.centerYAnchor, constant: 0).isActive = true
        activityIndicator2.centerXAnchor.constraint(equalTo: analysisBottom.centerXAnchor, constant: 0).isActive = true
        activityIndicator2.centerYAnchor.constraint(equalTo: analysisBottom.centerYAnchor, constant: 0).isActive = true
        
        //post取得分析後資料
        let url = URL(string: "http://140.135.97.72:88/inj/analysis_API")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let user = injectionAnalysisBody(a: self.nowChooseEnglish)
        let data = try? encoder.encode(user)
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let createUserResponse = try decoder.decode(injectionAnalysisResponse.self, from: data)
                   // print(createUserResponse)
                    
                    
                    //百分比
                    ///取數值絕對值總和
                    var num: Float = 0
                    for i in createUserResponse.corr_Data{
                        num += fabsf(Float(i))
                    }
                    ///取得百分比
                    var pattern: [Float] = []
                    for i in createUserResponse.corr_Data{
                        let myFloat = fabsf(Float(i)) * 100 / num
                        let a:Float = Float(String(format: "%.2f", myFloat))!
                        pattern.append(a)
                    }
                    
                
                    //儲存結果
                    var circleDataAll:[circleDataStruct] = []
                    for i in 0..<(createUserResponse.corr_title.count){
                        
                        let single = circleDataStruct(name: self.Chinese(input: createUserResponse.corr_title[i]), percent: pattern[i])
                        circleDataAll.append(single)
                        
                    }
                    
                    //由大到小排序
                    let listA = circleDataAll.sorted(by: { $0.percent > $1.percent})
                    //由小到大排序
                    let listB = circleDataAll.sorted(by: { $0.percent < $1.percent})
          
                    self.circleDataRelated = []
                    self.circleDataUnrelated = []
                    
                    if circleDataAll.count < 4 {
                        print("無相關性")
                    } else {
                        //取前五筆相關性資料
                        for a in 0...4{
                            
                            self.circleDataRelated.append(listA[a])
                            self.circleDataUnrelated.append(listB[a])
                        }
                    }
                   
   
                    
                    //資料跑好更新view
                    OperationQueue.main.addOperation({
                        activityIndicator1.stopAnimating()
                        activityIndicator2.stopAnimating()
                        
                        self.chooseLabel.isEnabled = true
                        
                        self.RelatedCircle()
                        self.UnrelatedCircle()
                    })
                    
                   
                } catch {
                    print(error)
                }
            }
        }.resume()
        
        
        
    }
    //MARK: 相關資料圓餅圖
        func RelatedCircle(){


            let chartView = HIChartView(frame: view.bounds)
            chartView.tag = 101
            chartView.theme = "grid-light"
            
            let options = HIOptions()

            let chart = HIChart()
            chart.type = "pie"
            chart.plotShadow = HICSSObject()
            chart.plotShadow.width = 0
            chart.plotBorderWidth = 0
            options.chart = chart

            let title = HITitle()
            title.text = "最相關百分比"
            options.title = title

            let tooltip = HITooltip()
            tooltip.pointFormat = "{series.name}: <b>{point.percentage:.1f}%</b>"
            options.tooltip = tooltip

            let accessibility = HIAccessibility()
            accessibility.point = HIPoint()
            accessibility.point.valueSuffix = "%"
            options.accessibility = accessibility

            let plotOptions = HIPlotOptions()

            plotOptions.pie = HIPie()
        
            plotOptions.pie.allowPointSelect = true
            plotOptions.pie.cursor = "pointer"
            plotOptions.pie.colors = [
              HIColor(name: "rgb(20,116,111)"),
              HIColor(name: "rgb(53,143,128)"),
              HIColor(name: "rgb(86,171,145)"),
              HIColor(name: "rgb(120,198,163)"),
              HIColor(name: "rgb(153,226,180)"),
            ]

            let dataLabels = HIDataLabels()
            dataLabels.enabled = true
      
            dataLabels.format = "<b>{point.name}</b><br>{point.percentage:.1f} %"
            dataLabels.distance = -25
            dataLabels.filter = HIFilter()
            dataLabels.filter.property = "percentage"
            dataLabels.filter.operator = ">"
            dataLabels.filter.value = 1
            plotOptions.pie.dataLabels = [dataLabels]

            options.plotOptions = plotOptions
            


            let share = HIPie()
            share.name = "Share"

    //        let chromeData = HIData()
    //        chromeData.name = "Chrome"
    //        chromeData.y = 61.41
    //
    //        let internetExplorerData = HIData()
    //        internetExplorerData.name = "Internet Explorer"
    //        internetExplorerData.y =  11.84
    //
    //        let firefoxData = HIData()
    //        firefoxData.name = "Firefox"
    //        firefoxData.y = 10.85
    //
    //        let edgeData = HIData()
    //        edgeData.name = "Edge"
    //        edgeData.y = 4.67
    //
    //        let safariData = HIData()
    //        safariData.name = "Safari"
    //        safariData.y = 4.18
    //
    //        let otherData = HIData()
    //        otherData.name = "Other"
    //        otherData.y = 7.05

            //將數據放到元餅圖上
            var Data:[Any] = []
            if self.circleDataRelated.count < 5 {
                
            } else {
                
                for a in 0...4{
                    let b = HIData()
                    b.name = self.circleDataRelated[a].name
                    b.y = NSNumber(value: self.circleDataRelated[a].percent)
                    Data.append(b)

                }
            }
            
            share.data = Data

            options.series = [share]

            chartView.options = options
            
            //關閉有右上功能鍵
            let exporting = HIExporting()
            exporting.enabled = false
            options.exporting = exporting
            
            
            
            //浮水印
            let credict = HICredits()
            credict.enabled = false
            options.credits = credict
            
            chartView.translatesAutoresizingMaskIntoConstraints = false
  
            self.circleUIView.append(chartView)
            self.analysisCenter.addSubview(chartView)
            
            chartView.leadingAnchor.constraint(equalTo: analysisCenter.leadingAnchor, constant: 10).isActive = true
            chartView.topAnchor.constraint(equalTo: analysisCenter.topAnchor, constant: 10).isActive = true
            chartView.trailingAnchor.constraint(equalTo: analysisCenter.trailingAnchor, constant: -10).isActive = true
            chartView.bottomAnchor.constraint(equalTo: analysisCenter.bottomAnchor, constant: -10).isActive = true
            
            
            
        }
        
    
//MARK: 未相關分析圓餅圖
    func UnrelatedCircle() {
        let chartView = HIChartView(frame: view.bounds)
        chartView.tag = 102
        chartView.theme = "grid-light"
        
        let options = HIOptions()

        let chart = HIChart()
        chart.type = "pie"
        chart.plotShadow = HICSSObject()
        chart.plotShadow.width = 0
        chart.plotBorderWidth = 0
        options.chart = chart

        let title = HITitle()
        title.text = "最不相關百分比"
        options.title = title

        let tooltip = HITooltip()
        tooltip.pointFormat = "{series.name}: <b>{point.percentage:.1f}%</b>"
        options.tooltip = tooltip

        let accessibility = HIAccessibility()
        accessibility.point = HIPoint()
        accessibility.point.valueSuffix = "%"
        options.accessibility = accessibility

        let plotOptions = HIPlotOptions()

        plotOptions.pie = HIPie()
    
        plotOptions.pie.allowPointSelect = true
        plotOptions.pie.cursor = "pointer"
        plotOptions.pie.colors = [
          HIColor(name: "rgb(115,93,120)"),
          HIColor(name: "rgb(179,146,172)"),
          HIColor(name: "rgb(209,179,196)"),
          HIColor(name: "rgb(232,194,202)"),
          HIColor(name: "rgb(247,209,205)"),
        ]

        let dataLabels = HIDataLabels()
        dataLabels.enabled = true
  
        dataLabels.format = "<b>{point.name}</b><br>{point.percentage:.1f} %"
        dataLabels.distance = -25
        dataLabels.filter = HIFilter()
        dataLabels.filter.property = "percentage"
        dataLabels.filter.operator = ">"
        dataLabels.filter.value = 6
        plotOptions.pie.dataLabels = [dataLabels]

        options.plotOptions = plotOptions

        let share = HIPie()
        share.name = "Share"

        //將數據放到元餅圖上
        var Data:[Any] = []
        if self.circleDataUnrelated.count < 5 {
            
        } else {
            for a in 0...4{
                let b = HIData()
                b.name = self.circleDataUnrelated[a].name
                b.y = NSNumber(value: self.circleDataUnrelated[a].percent)
                Data.append(b)

            }

        }
        
        share.data = Data

        options.series = [share]

        chartView.options = options
        
        //關閉有右上功能鍵
        let exporting = HIExporting()
        exporting.enabled = false
        options.exporting = exporting
        
        
        
        //浮水印
        let credict = HICredits()
        credict.enabled = false
        options.credits = credict
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
   
        self.circleUIView.append(chartView)
        self.analysisBottom.addSubview(chartView)
        
        chartView.leadingAnchor.constraint(equalTo: analysisBottom.leadingAnchor, constant: 10).isActive = true
        chartView.topAnchor.constraint(equalTo: analysisBottom.topAnchor, constant: -10).isActive = true
        chartView.trailingAnchor.constraint(equalTo: analysisBottom.trailingAnchor, constant: -10).isActive = true
        chartView.bottomAnchor.constraint(equalTo: analysisBottom.bottomAnchor, constant: -10).isActive = true
        
        
        
    }
    
    
//MARK: -資料匯入
    //post取得資料(沒有request資料)
    func getData(){
        let url = URL(string: "http://140.135.97.72:3000/swift/HisINJData")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let encoder = JSONEncoder()
//
//        //let MachineName = machine!
//        let user = postvalue(orderNumber: sendNumber!)
//        //let user = postKey(orderFormNumber: orderNumberTest!)
//        let data = try? encoder.encode(user)
//        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let createUserResponse = try decoder.decode([rejectionData].self, from: data)
                    
                    var xCount:Int = 0
                 
                    for item in createUserResponse{
                        
                        //匯入傳進的資料到injectData
                        self.injectData.append(item)
                        
                        //儲存第幾筆資料
                        xCount += 1
                        
//                        let str = NSString(string: item.Pressure_Curve)
//                        let div = str.components(separatedBy: ",")
//                        print(div)
                        
                        //處理週期時間資料格式
                        let SingalcycleTimeData = self.setDataType(xCount: xCount, y: Double(item.SPC_cycleTime) ?? 0, name: item.receivedAt, url: item.ImgUrl, pressureCurve: item.Pressure_Curve, shortshot: item.shortshot, shotPercent: item.shortshot_percent, weight: item.weight )
                        self.cycleTimeData.append(SingalcycleTimeData)
                        //處理填充時間資料格式
                        let SingalfillingTimeData = self.setDataType(xCount: xCount, y: Double(item.SPC_fillingTime) ?? 0, name: item.receivedAt, url: item.ImgUrl, pressureCurve: item.Pressure_Curve, shortshot: item.shortshot, shotPercent: item.shortshot_percent, weight: item.weight )
                        self.fillingTimeData.append(SingalfillingTimeData)
                        //處理儲料時間資料格式
                        let SingalmeteringTimeData = self.setDataType(xCount: xCount, y: Double(item.SPC_meteringTime) ?? 0, name: item.receivedAt, url: item.ImgUrl, pressureCurve: item.Pressure_Curve, shortshot: item.shortshot, shotPercent: item.shortshot_percent, weight: item.weight )
                        self.meteringTimeData.append(SingalmeteringTimeData)
                        //處理螺桿轉速資料格式
                        let SingalscrewSpeedData = self.setDataType(xCount: xCount, y: Double(item.SPC_screwSpeed) ?? 0, name: item.receivedAt, url: item.ImgUrl, pressureCurve: item.Pressure_Curve, shortshot: item.shortshot, shotPercent: item.shortshot_percent, weight: item.weight )
                        self.screwSpeedData.append(SingalscrewSpeedData)
                        //處理最大射出壓力資料格式
                        let SingalmaxPressureData = self.setDataType(xCount: xCount, y: Double(item.SPC_maxPressure) ?? 0, name: item.receivedAt, url: item.ImgUrl, pressureCurve: item.Pressure_Curve, shortshot: item.shortshot, shotPercent: item.shortshot_percent, weight: item.weight )
                        self.maxPressureData.append(SingalmaxPressureData)
                        //處理背壓資料格式
                        let SingalsuckBackPressureData = self.setDataType(xCount: xCount, y: Double(item.SPC_suckBackPressure)!, name: item.receivedAt, url: item.ImgUrl, pressureCurve: item.Pressure_Curve, shortshot: item.shortshot, shotPercent: item.shortshot_percent, weight: item.weight )
                        self.suckBackPressureData.append(SingalsuckBackPressureData)
                        //處理起始位置資料格式
                        let SingalmeteringEndPosData = self.setDataType(xCount: xCount, y: Double(item.SPC_meteringEndPos) ?? 0, name: item.receivedAt, url: item.ImgUrl, pressureCurve: item.Pressure_Curve, shortshot: item.shortshot, shotPercent: item.shortshot_percent, weight: item.weight )
                        self.meteringEndPosData.append(SingalmeteringEndPosData)
                        //處理終點位置資料格式
                        let SingalminResidueData = self.setDataType(xCount: xCount, y: Double(item.SPC_minResidue) ?? 0, name: item.receivedAt, url: item.ImgUrl, pressureCurve: item.Pressure_Curve, shortshot: item.shortshot, shotPercent: item.shortshot_percent, weight: item.weight )
                        self.minResidueData.append(SingalminResidueData)
                        //處理V/P轉換壓力資料格式
                        let SingalvpSwitchPressureData = self.setDataType(xCount: xCount, y: Double(item.SPC_vpSwitchPressure) ?? 0, name: item.receivedAt, url: item.ImgUrl, pressureCurve: item.Pressure_Curve, shortshot: item.shortshot, shotPercent: item.shortshot_percent, weight: item.weight )
                        self.vpSwitchPressureData.append(SingalvpSwitchPressureData)
                        //處理V/P轉換位置資料格式
                        let SingalvpSwitchPosData = self.setDataType(xCount: xCount, y: Double(item.SPC_vpSwitchPos) ?? 0, name: item.receivedAt, url: item.ImgUrl, pressureCurve: item.Pressure_Curve, shortshot: item.shortshot, shotPercent: item.shortshot_percent, weight: item.weight )
                        self.vpSwitchPosData.append(SingalvpSwitchPosData)
                        //處理最小殘量
                        let SingalfinalResidueData = self.setDataType(xCount: xCount, y: Double(item.SPC_finalResidue) ?? 0, name: item.receivedAt, url: item.ImgUrl, pressureCurve: item.Pressure_Curve, shortshot: item.shortshot, shotPercent: item.shortshot_percent, weight: item.weight )
                        self.finalResidueData.append(SingalfinalResidueData)
                        
                    }
                    
                    OperationQueue.main.addOperation({
                        self.HightChartView()
                       
                    })
                    
                }catch  {
                    print(error)
                }
            }
        }.resume()
        
    }
    
//MARK: 資料中英轉換
    func Chinese(input: String) -> String {
        var chinese = ""
        if input == "SPC_cycleTime" {
            chinese = "週期時間"
        } else if input == "SPC_fillingTime" {
            chinese = "填充時間"
        } else if input == "SPC_meteringTime" {
            chinese = "儲料時間"
        } else if input == "SPC_screwSpeed" {
            chinese = "螺桿轉速"
        } else if input == "SPC_maxPressure" {
            chinese = "最大射出壓力"
        } else if input == "SPC_suckBackPressure" {
            chinese = "背壓"
        } else if input == "SPC_meteringEndPos" {
            chinese = "起始位置"
        } else if input == "SPC_minResidue" {
            chinese = "終點位置"
        } else if input == "SPC_vpSwitchPressure" {
            chinese = "V/P轉換壓力"
        } else if input == "SPC_vpSwitchPos" {
            chinese = "V/P轉換位置"
        } else if input == "SPC_finalResidue" {
            chinese = "最小殘量"
        } else if input == "Pressure_Curve" {
            chinese = "射出曲線"
        } else if input == "IJ_Pre" {
            chinese = "射出壓力"
        } else if input == "IJ_Vel_1st" {
            chinese = "第一段射出速度"
        } else if input == "IJ_Vel_2nd" {
            chinese = "第二段射出速度"
        } else if input == "IJ_Vel_3rd" {
            chinese = "第三段射出速度"
        } else if input == "IJ_Vel_4th" {
            chinese = "第四段射出速度"
        } else if input == "IJ_Vel_5th" {
            chinese = "第五段射出速度"
        } else if input == "IP_1" {
            chinese = "第一段射出位置"
        } else if input == "IP_2" {
            chinese = "第二段射出位置"
        } else if input == "IP_3" {
            chinese = "第三段射出位置"
        } else if input == "IP_4" {
            chinese = "第四段射出位置"
        } else if input == "IP_5" {
            chinese = "第五段射出位置"
        } else if input == "FB_P" {
            chinese = "前鬆退位置"
        } else if input == "FB_S" {
            chinese = "前鬆退速度"
        } else if input == "MEP" {
            chinese = "後鬆退位置"
        } else if input == "MEP_S" {
            chinese = "後鬆退速度"
        } else if input == "BP_1st" {
            chinese = "儲料被壓1"
        } else if input == "BP_2nd" {
            chinese = "儲料被壓2"
        } else if input == "SRS_1" {
            chinese = "儲料轉速1"
        } else if input == "SRS_2" {
            chinese = "儲料轉速2"
        } else if input == "SRP_1" {
            chinese = "儲料位置1"
        } else if input == "SRP_2" {
            chinese = "儲料位置2"
        } else if input == "V2P_T" {
            chinese = "填充轉保壓時間"
        } else if input == "Cooling_T" {
            chinese = "冷卻時間"
        } else if input == "M_delay_T" {
            chinese = "加料延遲時間"
        } else if input == "PACK_P_1st" {
            chinese = "第一段保壓壓力"
        } else if input == "PACK_P_2nd" {
            chinese = "第二段保壓壓力"
        } else if input == "PACK_P_3rd" {
            chinese = "第三段保壓壓力"
        } else if input == "PACK_T_1st" {
            chinese = "第一段保壓時間"
        } else if input == "PACK_T_2nd" {
            chinese = "第二段保壓時間"
        } else if input == "PACK_T_3rd" {
            chinese = "第三段保壓時間"
        } else if input == "Temp_set_Z0" {
            chinese = "第一段料管溫度"
        } else if input == "Temp_set_Z1" {
            chinese = "第二段料管溫度"
        } else if input == "Temp_set_Z2" {
            chinese = "第三段料管溫度"
        } else if input == "Temp_set_Z3" {
            chinese = "第四段料管溫度"
        } else if input == "shortshot" {
            chinese = "是否短射"
        } else if input == "shortshot_percent" {
            chinese = "短射程度"
        } else if input == "weight" {
            chinese = "成品重量"
        }
        
        return chinese
    }
    
    func English(input: String) -> String {
        var EnglishData = ""
        if self.nowChoose == "週期時間"{
            EnglishData = "SPC_cycleTime"
        } else if self.nowChoose == "填充時間" {
            EnglishData = "SPC_fillingTime"
        } else if self.nowChoose == "儲料時間" {
            EnglishData = "SPC_meteringTime"
        } else if self.nowChoose == "螺桿轉速" {
            EnglishData = "SPC_screwSpeed"
        } else if self.nowChoose == "最大射出壓力" {
            EnglishData = "SPC_maxPressure"
        } else if self.nowChoose == "背壓" {
            EnglishData = "SPC_suckBackPressure"
        } else if self.nowChoose == "起始位置" {
            EnglishData = "SPC_meteringEndPos"
        } else if self.nowChoose == "終點位置" {
            EnglishData = "SPC_minResidue"
        } else if self.nowChoose == "V/P轉換壓力" {
            EnglishData = "SPC_vpSwitchPressure"
        } else if self.nowChoose == "V/P轉換位置" {
            EnglishData = "SPC_vpSwitchPos"
        } else if self.nowChoose == "最小殘量" {
            EnglishData = "SPC_finalResidue"
        }
        return EnglishData
    }
    
    //處理資料格式
    func setDataType(xCount: Int, y:Double, name: String, url:String, pressureCurve: String, shortshot: String, shotPercent: String, weight: String) -> [String:Any]{
        var dataJSON:[String:Any] = ["x": Int(), "y": Int(), "name": "", "url": "", "pressureCurve": "", "shortshot":"", "shotPercent":"", "weight":""]
        dataJSON["x"] = xCount
        dataJSON["y"] = y
        dataJSON["name"] = name
        dataJSON["url"] = url
        dataJSON["pressureCurve"] = pressureCurve
        dataJSON["shortshot"] = shortshot
        dataJSON["shotPercent"] = shotPercent
        dataJSON["weight"] = weight
        return dataJSON
    }
    
    func count(ADD: Int) -> Int{
        let a = ADD + 1
        return a
    }

    

    
    
//MARK: -分析項目Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datas.count
    }
    
    //UIPickerView的選項顯示
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return datas[row]
    }


    
    //分析項目選擇動作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       //let label = self.view.viewWithTag(100) as? UITextView
        
        for i in self.circleUIView {
            i.removeFromSuperview()
        }
        
        //關閉選擇列表
        chooseLabel.resignFirstResponder()
        view.endEditing(true)
        
        self.chooseLabel.isEnabled = false
        
        self.chooseLabel.text = datas[row]
        self.nowChoose = datas[row]
        print(self.nowChoose)
        
        self.nowChooseEnglish = self.English(input: datas[row])
        print(self.nowChooseEnglish)
        
        //選完後再重新畫一次圖表
        HightChartView()
        //相關性分析再重新畫一次圖表
        computedanalysisRelated()
    }

}
