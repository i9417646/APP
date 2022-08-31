//
//  ScheduleViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2021/10/4.
//

import UIKit
import Highcharts

class ScheduleViewController: UIViewController {

    
    // 機台列表
    var ymachine:[String] = []
    //甘特圖數據
    var xdata:[[String:Any]] = []
   // var Data:[Xdata] = []
    
    //get資料
    func getData (){
        
        let url = URL(string: "http://140.135.97.72:3000/swift/ACOTest2")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data{
                       do {
                        
                           let decoder = JSONDecoder()
                           let createUserResponse = try decoder.decode(gann.self, from: data)
                        //print(createUserResponse)
                        self.ymachine = createUserResponse.YAxisCategories
                        //print(createUserResponse.XrangeData)
                        //print(createUserResponse.XrangeData)
                       // var xJSON:[String:Any] = ["x": Int(),"y": Int(),"x2":Int(),"color":""]
                        for item in createUserResponse.XrangeData{
                            var xJSON:[String:Any] = ["x": Int(),"y": Int(),"x2":Int(),"color":"","tasks":"","borderWidth":Int(),"borderColor":"", "Img":""]
                            xJSON["x"] = item.x
                            xJSON["x2"] = item.x2
                            xJSON["y"] = item.y
                            xJSON["color"] = item.color
                            xJSON["color"] = item.color
                            xJSON["tasks"] = item.tasks
                            xJSON["borderWidth"] = 0
                            xJSON["borderColor"] = "gray"
                            xJSON["Img"] = item.ImgUrl
                            self.xdata.append(xJSON)
                            //print(xJSON)

                        }
                        
                        
                       
                        //更新畫面，但是應該沒用haha
                        OperationQueue.main.addOperation({
                            self.view.setNeedsLayout()
                        })
                   
                       } catch  {
                           print(error)
                       }
                   }
        }.resume()
        
    }

 

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ymachine = []
        xdata = []
        
        
        print("viewload第一歌加仔")
      //  getData ()
        fetchData { (gnn) in
            print("+++++++++++++++")
        }
        
        //gantt chart
        let chartView = HIChartView(frame: view.bounds)
            chartView.theme = "grid-light"
            chartView.plugins = ["xrange"]
        
            let options = HIOptions()
        
        
            let exporting = HIExporting()
            exporting.enabled = false
        
            options.exporting = exporting

            let title = HITitle()
            title.text = ""
            options.title = title

            let accessibility = HIAccessibility()
            accessibility.point = HIPoint()
            accessibility.point.descriptionFormatter = HIFunction(jsFunction: "function (point) { var ix = point.index + 1, category = point.yCategory, from = new Date(point.x), to = new Date(point.x2); return ix + '. ' + category + ', ' + from.toDateString() + ' to ' + to.toDateString() + '.'; }")
            options.accessibility = accessibility

            let xAxis = HIXAxis()
            xAxis.type = "datetime"
            options.xAxis = [xAxis]

            let yAxis = HIYAxis()
            yAxis.title = HITitle()
            yAxis.title.text = ""
            yAxis.categories = ymachine
            yAxis.reversed = true
            options.yAxis = [yAxis]
        
        
            //關掉分類
            let legend = HILegend()
            legend.enabled = false
            options.legend = legend
        
            //浮水印
            let credict = HICredits()
            credict.enabled = false
            options.credits = credict
        
        

            let xrange = HIXrange()
            xrange.name = "場域排程"
             //xrange.pointPadding = 20
            // xrange.groupPadding = 0
            xrange.borderColor = HIColor(name: "gray")
            xrange.pointWidth = 25
            xrange.borderRadius = 0
            xrange.colors = [HIColor(name: "red")]
            xrange.data = xdata

        
        
        //未使用demo
//        let xrange1 = HIXrange()
//        xrange1.name = "2Y0040176"
//         //xrange.pointPadding = 20
//        // xrange.groupPadding = 0
//        xrange1.borderColor = HIColor(name: "gray")
//        xrange1.pointWidth = 15
//        xrange1.colors = [HIColor(name: "yellow")]
//        xrange1.data = [
//          [
//            "x": 1416528000000,
//            "x2": 1417478400000,
//            "y": 0,
//            //"color": yellow
//            //"partialFill": 0.25
//          ], [
//            "x": 1417478400000,
//            "x2": 1417737600000,
//            "y": 1
//          ], [
//            "x": 1417996800000,
//            "x2": 1418083200000,
//            "y": 2
//          ], [
//            "x": 1418083200000,
//            "x2": 1418947200000,
//            "y": 1
//          ], [
//            "x": 1418169600000,
//            "x2": 1419292800000,
//            "y": 2
//          ]
//        ]

//            let dataLabels = HIDataLabels()
//            dataLabels.enabled = true
//            xrange.dataLabels = [dataLabels]

            options.series = [xrange]

            chartView.options = options
        
 
        
        
            let chart = HIChart()
            chart.zoomType = "x"
            chart.scrollablePlotArea = HIScrollablePlotArea()
            chart.scrollablePlotArea.minHeight = NSNumber(value: Int(chartHeight(counts: ymachine.count)))
        
            options.chart = chart
        
//MARK: - 顯示同零件製程
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
        
        //highchart的事件
        //點擊單段製程會顯示該製成的圖片以及將同一零件的匡線顏色改變來顯示
        let chartFunction = HIFunction(closure: { context in
            guard let context = context else { return }
            
            let alertMessage = "\n\n\n\n\n 零件: \(context.getProperty("this.tasks") ?? "unknown")"
            
            let taskIMG = UIImageView(frame: CGRect(x: 70, y: 15, width: 140, height: 100))
            //載入圖片
            taskIMG.load(urlString: context.getProperty("this.Img") as! String)
        
           
            //UIAlert
            let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
            
            alert.view.addSubview(taskIMG)
            
  
        
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)

            alert.addAction(defaultAction)
            
            self.present(alert, animated: true, completion: nil)
            
            var Xdict: [[String: Any]] = []
            for item in self.xdata {
                var xJSON:[String:Any] = ["x": Int(),"y": Int(),"x2":Int(),"color":"","tasks":"","borderWidth":Int(),"borderColor":"","Img":""]
                xJSON["x"] = item["x"]
                xJSON["x2"] = item["x2"]
                xJSON["y"] = item["y"]
                xJSON["color"] = item["color"]
                xJSON["tasks"] = item["tasks"]
                xJSON["Img"] =  item["Img"]
                if  item["tasks"] as! String == context.getProperty("this.tasks") as! String{
                    xJSON["borderWidth"] = 4
                    xJSON["borderColor"] = "blue"
                } else {
                    xJSON["borderWidth"] = 0
                    xJSON["borderColor"] = "gray"
                }
                Xdict.append(xJSON)
            }
            self.xdata = Xdict
            
            
            let xrange = HIXrange()
            xrange.name = "場域排程"
            xrange.borderColor = HIColor(name: "gray")
            xrange.pointWidth = 25
            xrange.borderRadius = 0
            xrange.colors = [HIColor(name: "red")]
            xrange.data = self.xdata
            
            
            
            options.series = [xrange]

            chartView.options = options

            
            
        }, properties: ["this.category", "this.tasks","this.Img"])
        
        
        plotOptions.series.point.events.click = chartFunction
        options.plotOptions = plotOptions

        
        
//MARK: - 取消選取同零件
                
        let borderNone = HIFunction(closure: {_ in
            
            options.series = [xrange]
            chartView.options = options
            
        })
        
        chart.events = HIEvents()
        chart.events.click = borderNone
        options.chart = chart
        
        
        
        
        
        
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chartView)
        
        //甘特圖高度
        //chartView.heightAnchor.constraint(equalToConstant: CGFloat(300 * ymachine.count)).isActive = true
        //甘特圖左,上,右constraint
        chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        chartView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        chartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
       

    }
    
    func chartHeight(counts: Int) -> Int{
        let height:Int = Int(150 * counts)
        
        return height
    }
    
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        ymachine = []
//        xdata = []
//        getData ()
//        print(chartHeight(counts: 2))
//        print(type(of: chartHeight(counts: 2)))
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        ymachine = []
        xdata = []
        
        
        fetchData { (gnn) in
            print("+++++++++++++++")
        }
        
        print("我是viewdidApear 重新加仔囉")
        

        for i in self.view.subviews{
            print("我有幾個視窗")
            print(i)
            
            let xrange = HIXrange()
            xrange.name = "場域排程"
             //xrange.pointPadding = 20
            // xrange.groupPadding = 0
            xrange.borderColor = HIColor(name: "gray")
            xrange.pointWidth = 25
            xrange.borderRadius = 0
            xrange.colors = [HIColor(name: "red")]
            xrange.data = xdata
            
            
            
        }
    

        
    }
    
    


    
    //取得資訊
    fileprivate func fetchData(completion: @escaping (gann) -> ()){
        
        print("get撈取資料一次囉000000000000000000")
        let urlString = "http://140.135.97.72:3000/swift/ACOTest2"
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with:  url!) { (data, resp, err) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let createUserResponse = try decoder.decode(gann.self, from: data)
            // print(createUserResponse)
             self.ymachine = createUserResponse.YAxisCategories
             //print(createUserResponse.XrangeData)
             //print(createUserResponse.XrangeData)
            // var xJSON:[String:Any] = ["x": Int(),"y": Int(),"x2":Int(),"color":""]
             for item in createUserResponse.XrangeData{
                 var xJSON:[String:Any] = ["x": Int(),"y": Int(),"x2":Int(),"color":"","tasks":"","borderWidth":Int(),"borderColor":"", "Img":""]
                 xJSON["x"] = item.x
                 xJSON["x2"] = item.x2
                 xJSON["y"] = item.y
                 xJSON["color"] = item.color
                 xJSON["color"] = item.color
                 xJSON["tasks"] = item.tasks
                 xJSON["borderWidth"] = 0
                 xJSON["borderColor"] = "gray"
                 xJSON["Img"] = item.ImgUrl
                 self.xdata.append(xJSON)
                 //print(xJSON)

             }
             
             
            

             OperationQueue.main.addOperation({
                self.view.subviews.forEach({ $0.setNeedsLayout() })
                self.view.subviews.forEach({ $0.layoutIfNeeded() })
                 
                
                print("我有更新視窗囉")
             })
                
                //將json解碼關閉
                completion(createUserResponse)
                
            } catch let jsonErr {
                print("Failed to decode json", jsonErr)
            }
            
        }.resume()
        
    }
    
    
    
    
    @IBAction func backSchedule(for segue: UIStoryboardSegue) {
        if segue.identifier == "back_edit"{
            print("it work!!")
        }
    }

}






