//
//  gantViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2021/9/10.
//

import UIKit
import Highcharts

class gantViewController: UIViewController {
    
    var ymachine:[String] = []
    var xdata:[[String:Any]] = []
   // var Data:[Xdata] = []
    
    func getData (){
        let url = URL(string: "http://140.135.97.72:3000/swift/ACOTest2")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data{
                       do {
                        print(data)
                           let decoder = JSONDecoder()
                           let createUserResponse = try decoder.decode(gann.self, from: data)
                        //print(createUserResponse)
                        self.ymachine = createUserResponse.YAxisCategories
                        print(createUserResponse.XrangeData)
                        //print(createUserResponse.XrangeData)
                       // var xJSON:[String:Any] = ["x": Int(),"y": Int(),"x2":Int(),"color":""]
                        for item in createUserResponse.XrangeData{
                            var xJSON:[String:Any] = ["x": Int(),"y": Int(),"x2":Int(),"color":""]
                            xJSON["x"] = item.x
                            xJSON["x2"] = item.x2
                            xJSON["y"] = item.y
                            xJSON["color"] = item.color
                            
                            self.xdata.append(xJSON)
                            //print(xJSON)

                        }
                        
                   
                    
                   
                       } catch  {
                           print(error)
                       }
                   }
        }.resume()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData ()
        sleep(1)
        print(xdata)
        //print(ymachine)
        //print(Data[0])

        
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

            let xrange = HIXrange()
            
            xrange.name = "Project 1"
             //xrange.pointPadding = 20
            // xrange.groupPadding = 0
            xrange.borderColor = HIColor(name: "gray")
            xrange.pointWidth = 20
            xrange.borderRadius = 0
            xrange.colors = [HIColor(name: "red")]
            xrange.data = xdata
//                [ [
//                        "x": 1416528000000,
//                        "x2": 1417478400000,
//                        "y": 0,
//                        "color": "#FFFFFF"
//                        //"partialFill": 0.25
//                      ]]
//        [
//              [
//                "x": 1416528000000,
//                "x2": 1417478400000,
//                "y": 0,
//                "color": "#FFFFFF"
//                //"partialFill": 0.25
//              ], [
//                "x": 1417478400000,
//                "x2": 1417737600000,
//                "y": 0
//              ], [
//                "x": 1417996800000,
//                "x2": 1418083200000,
//                "y": 2
//              ], [
//                "x": 1418083200000,
//                "x2": 1418947200000,
//                "y": 1
//              ], [
//                "x": 1418169600000,
//                "x2": 1419292800000,
//                "y": 2
//              ]
//            ]
        
        
        
        let xrange1 = HIXrange()
        xrange1.name = "2Y0040176"
         //xrange.pointPadding = 20
        // xrange.groupPadding = 0
        xrange1.borderColor = HIColor(name: "gray")
        xrange1.pointWidth = 20
        xrange1.colors = [HIColor(name: "yellow")]
        xrange1.data = [
          [
            "x": 1416528000000,
            "x2": 1417478400000,
            "y": 0,
            //"color": yellow
            //"partialFill": 0.25
          ], [
            "x": 1417478400000,
            "x2": 1417737600000,
            "y": 1
          ], [
            "x": 1417996800000,
            "x2": 1418083200000,
            "y": 2
          ], [
            "x": 1418083200000,
            "x2": 1418947200000,
            "y": 1
          ], [
            "x": 1418169600000,
            "x2": 1419292800000,
            "y": 2
          ]
        ]

            let dataLabels = HIDataLabels()
            dataLabels.enabled = true
            xrange.dataLabels = [dataLabels]

            options.series = [xrange]

            chartView.options = options
        
        
            let chart = HIChart()
            chart.zoomType = "x"
            chart.scrollablePlotArea = HIScrollablePlotArea()
            chart.scrollablePlotArea.minWidth = 700
        
            options.chart = chart
            

            self.view.addSubview(chartView)

        // Do any additional setup after loading the view.
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
 
