//
//  SingalEditScheduleViewController.swift
//  machine0811_a
///Users/cax521/Desktop/檔案/20220536memory/machine_ganti/machine0811_a/Controller/ALLMachineOnTime/OnTimeViewController.swift
//  Created by CAX521 on 2021/10/12.
//

import UIKit
import Highcharts

class SingalEditScheduleViewController: UIViewController {
    
    //此專案狀態(是否已加入排程)
    var projectStatus: String?
    
    //前面表格所傳過來的專案名稱
    var sendNumber: String?
    
    //甘特圖的Y軸(使用EDD)
    var Ymachine:[String] = []
    
    //此專案零件
    var tasks:[String] = []
    
    //EDD的Ｘ軸
    var EDDX:[[String:Any]] = []
    
    //GA的Ｘ軸
    var GAX:[[String:Any]] = []
    
    //ACO的Ｘ軸
    var ACOX:[[String:Any]] = []
    
    //GAACO的Ｘ軸
    var GAACOX:[[String:Any]] = []
    
    //ScheduleValue專案資料
    var ScheduleValue:[ProjectDataArray] = [ProjectDataArray(orderNumber: "nil", Best: "nil", EDD: "nil", ACO: "nil", GA: "nil", GAACO: "nil", EDDTime: "nil", ACOTime: "nil", GATime: "nil", GAACOTime: "nil", ProcessQuantity: "nil")]
    
    
    //UI連接
    @IBOutlet weak var ScheduleNumber: UILabel!
    @IBOutlet weak var TaskCount: UILabel!
    @IBOutlet weak var ProcessQuantity: UILabel!
    
    //退回排程(功能都做完剩下API)
    @IBOutlet weak var delet: UIButton!
    

    @IBOutlet weak var EDDTime: UILabel!
    @IBOutlet weak var GATime: UILabel!
    @IBOutlet weak var ACOTime: UILabel!
    @IBOutlet weak var GAACOTime: UILabel!
    
    
    @IBOutlet weak var EDDView: UIView!
    @IBOutlet weak var GAView: UIView!
    @IBOutlet weak var ACOView: UIView!
    @IBOutlet weak var GAACOView: UIView!
    
    @IBOutlet weak var lowView: UIView!
    
    @IBOutlet weak var gantt: UIView!
    
    //加入實際排成按鈕(功能都做完剩下API)
    @IBOutlet weak var AddToSchedule: UIButton!
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        
        print("此專案狀態：\(self.projectStatus!)000000000000000000000000000")
        
        //隱藏按鈕(功能未啟用)
        self.AddToSchedule.isHidden = true
        self.delet.isHidden = true
        
        //如果專案已經加入排程就不會顯示刪除鍵
        if self.projectStatus == "A" {
            

        } else {
            AddToSchedule.isHidden = true
          //  AddToSchedule.isEnabled = true
           // AddToSchedule.backgroundColor = UIColor.lightGray
        }

        //post資料
        getData()
        
        //程式延遲等待資料都進來
        sleep(1)
        
        print("傳過來的專案編號：\(String(describing: sendNumber!))")
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //頁面資料
        ScheduleNumber.text = ScheduleValue[0].orderNumber
        TaskCount.text = String(tasks.count)
        ProcessQuantity.text = ScheduleValue[0].ProcessQuantity
        
        EDDTime.text = "\(ScheduleValue[0].EDDTime)(s) / \(ScheduleValue[0].EDD)(hr)"
        GATime.text = "\(ScheduleValue[0].GATime)(s) / \(ScheduleValue[0].GA)(hr)"
        ACOTime.text = "\(ScheduleValue[0].ACOTime)(s) / \(ScheduleValue[0].ACO)(hr)"
        GAACOTime.text = "\(ScheduleValue[0].GAACOTime)(s) / \(ScheduleValue[0].GAACO)(hr)"
        
        
        
        //邊框框線
        let TOPBorder = CALayer()
        TOPBorder.frame = CGRect(x: 0, y: 0, width: lowView.frame.size.width, height: 1)
        TOPBorder.backgroundColor = UIColor(displayP3Red: 185/255, green: 195/255, blue: 199/255, alpha: 1).cgColor
        lowView.layer.addSublayer(TOPBorder)
        
        EDDView.layer.borderWidth = 1
        EDDView.layer.borderColor = UIColor(displayP3Red: 185/255, green: 195/255, blue: 199/255, alpha: 1).cgColor
        
        GAView.layer.borderWidth = 1
        GAView.layer.borderColor = UIColor(displayP3Red: 185/255, green: 195/255, blue: 199/255, alpha: 1).cgColor
        
        ACOView.layer.borderWidth = 1
        ACOView.layer.borderColor = UIColor(displayP3Red: 185/255, green: 195/255, blue: 199/255, alpha: 1).cgColor
        
        GAACOView.layer.borderWidth = 1
        GAACOView.layer.borderColor = UIColor(displayP3Red: 185/255, green: 195/255, blue: 199/255, alpha: 1).cgColor
        
        gantt.layer.borderWidth = 1
        gantt.layer.borderColor = UIColor(displayP3Red: 185/255, green: 195/255, blue: 199/255, alpha: 1).cgColor
        
        
        
        //gantt chart畫甘特圖
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
        
        
      
        
        let patternObject = HIPatternObject()
        patternObject.pattern = HIPatternOptionsObject()
        patternObject.pattern.path = "M 0 0 L 10 10 M 9 -1 L 11 1 M -1 9 L 1 11"
        patternObject.pattern.width = 10
        patternObject.pattern.height = 10
        patternObject.pattern.opacity = 0.4
        patternObject.pattern.id = "style"
        patternObject.pattern.color = "red"
        
       // options.plotOptions = plotOptions
    


        let xAxis = HIXAxis()
        xAxis.type = "datetime"
        options.xAxis = [xAxis]

        let yAxis = HIYAxis()
        yAxis.title = HITitle()
        yAxis.title.text = ""
        yAxis.categories = Ymachine
  

        yAxis.reversed = true
        
        options.yAxis = [yAxis]
    
    
        //分類
        let legend = HILegend()
        legend.margin = 20
        options.legend = legend
        

        //EDD資料
        let EDDxrange = HIXrange()
        EDDxrange.name = "EDD"
        EDDxrange.borderColor = HIColor(name: "gray")
        EDDxrange.pointWidth = 14
        EDDxrange.borderRadius = 0
        EDDxrange.data = EDDX
        let EDDPattern = HIPatternObject()
        EDDPattern.pattern = HIPatternOptionsObject()
        EDDPattern.pattern.color = "#11d"
        EDDxrange.colors = [HIColor(pattern: EDDPattern)]
    
        
        //GA資料
        let GAxrange = HIXrange()
        GAxrange.name = "GA"
        //xrange.pointPadding = 20
        // xrange.groupPadding = 0
        GAxrange.borderColor = HIColor(name: "gray")
        GAxrange.pointWidth = 14
        GAxrange.borderRadius = 0
        GAxrange.data = GAX
        
        //ACO資料
        let ACOxrange = HIXrange()
        ACOxrange.name = "ACO"
        //xrange.pointPadding = 20
        // xrange.groupPadding = 0
        ACOxrange.borderColor = HIColor(name: "gray")
        ACOxrange.pointWidth = 14
        ACOxrange.borderRadius = 0
        ACOxrange.data = ACOX
        
        //GAACO資料
        let GAACOxrange = HIXrange()
        GAACOxrange.name = "GAACO"
        //xrange.pointPadding = 20
        // xrange.groupPadding = 0
        GAACOxrange.borderColor = HIColor(name: "gray")
        GAACOxrange.pointWidth = 14
        GAACOxrange.borderRadius = 0
        GAACOxrange.data = GAACOX
        
        
        
        
        //logo隱藏
        let credict = HICredits()
        credict.enabled = false
        options.credits = credict
        
        

        
        //未使用demo
        let xrange1 = HIXrange()
        
        xrange1.name = "假"
        //xrange1.pointPadding = 5
         //xrange1.groupPadding = 20
        xrange1.borderColor = HIColor(name: "gray")
        xrange1.pointWidth = 12
        xrange1.colors = [HIColor(name: "yellow")]
        xrange1.data = [
          [
            "x": 1416528000000,
            "x2": 1417478400000,
            "y": 1,
            "color": "pink",
            "borderWidth": 3,
            "borderColor":"blue"
            //"color": yellow
            //"partialFill": 0.25
          ], [
            "x": 1417478400000,
            "x2": 1417737600000,
            "y": 2,
//            "color":[
//                "pattern":[
//                    "path":"M 0 0 L 10 10 M 9 -1 L 11 1 M -1 9 L 1 11",
//                    "width": 10,
//                    "height": 10,
//                    "color": "red"
//                ]
//            ]

          ], [
            "x": 1417996800000,
            "x2": 1418083200000,
            "y": 2,
//            "color":"url(#style)"

          ], [
            "x": 1418083200000,
            "x2": 1418947200000,
            "y": 3,
            "pattern":"M 0 0 L 10 10 M 9 -1 L 11 1 M -1 9 L 1 11",
            "color": "blue"
//                "d": "M 0 0 L 10 10 M 9 - 1 L 11 1 M - 1 9 L 1 11",
//                "width": 10,
//                "height": 10,
//

          ], [
            "x": 1418169600000,
            "x2": 1419292800000,
            "y": 3,
            "color": "HIColor(named: green)"
          ]
        ]


        

        options.series = [EDDxrange,GAxrange,ACOxrange,GAACOxrange]
        chartView.options = options
        
 

//MARK: - HighCharts高度
        let chart = HIChart()
        chart.zoomType = "x"
        chart.scrollablePlotArea = HIScrollablePlotArea()
        chart.scrollablePlotArea.minHeight = NSNumber(value: Int(chartHeight(counts: Ymachine.count)))
    
//MARK: - 取消選取同零件
        
        let borderNone = HIFunction(closure: {_ in
            
            options.series = [EDDxrange,GAxrange,ACOxrange,GAACOxrange]
            chartView.options = options
            
        })
        
        chart.events = HIEvents()
        chart.events.click = borderNone
        options.chart = chart
        
        
//MARK: - 選取同零件
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
        
        let chartFunction = HIFunction(closure: { context in
            guard let context = context else { return }

            let alertMessage = " 零件: \(context.getProperty("this.tasks") ?? "unknown")"
            
            let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
            
            
            
           var EDDdict: [[String: Any]] = []
            for item in self.EDDX {
                var xJSON:[String:Any] = ["x": Int(),"y": Int(),"x2":Int(),"color":"","tasks":"","borderWidth":Int(),"borderColor":""]
                xJSON["x"] = item["x"]
                xJSON["x2"] = item["x2"]
                xJSON["y"] = item["y"]
                xJSON["color"] = item["color"]
                xJSON["tasks"] = item["tasks"]
                if  item["tasks"] as! String == context.getProperty("this.tasks") as! String{
                    xJSON["borderWidth"] = 4
                    xJSON["borderColor"] = "blue"
                } else {
                    xJSON["borderWidth"] = 0
                    xJSON["borderColor"] = "gray"
                }
                EDDdict.append(xJSON)
            }
            self.EDDX = EDDdict
            
            
            var GAdict: [[String: Any]] = []
            for item in self.GAX {
                var xJSON:[String:Any] = ["x": Int(),"y": Int(),"x2":Int(),"color":"","tasks":"","borderWidth":Int(),"borderColor":""]
                xJSON["x"] = item["x"]
                xJSON["x2"] = item["x2"]
                xJSON["y"] = item["y"]
                xJSON["color"] = item["color"]
                xJSON["tasks"] = item["tasks"]
                if  item["tasks"] as! String == context.getProperty("this.tasks") as! String{
                    xJSON["borderWidth"] = 4
                    xJSON["borderColor"] = "blue"
                } else {
                    xJSON["borderWidth"] = 0
                    xJSON["borderColor"] = "gray"
                }
                GAdict.append(xJSON)
            }
            self.GAX = GAdict
            
            
            var ACOdict: [[String: Any]] = []
            for item in self.ACOX {
                var xJSON:[String:Any] = ["x": Int(),"y": Int(),"x2":Int(),"color":"","tasks":"","borderWidth":Int(),"borderColor":""]
                xJSON["x"] = item["x"]
                xJSON["x2"] = item["x2"]
                xJSON["y"] = item["y"]
                xJSON["color"] = item["color"]
                xJSON["tasks"] = item["tasks"]
                if  item["tasks"] as! String == context.getProperty("this.tasks") as! String{
                    xJSON["borderWidth"] = 4
                    xJSON["borderColor"] = "blue"
                } else {
                    xJSON["borderWidth"] = 0
                    xJSON["borderColor"] = "gray"
                }
                ACOdict.append(xJSON)
            }
            self.ACOX = ACOdict
            
            var GAACOdict: [[String: Any]] = []
            for item in self.GAACOX {
                var xJSON:[String:Any] = ["x": Int(),"y": Int(),"x2":Int(),"color":"","tasks":"","borderWidth":Int(),"borderColor":""]
                xJSON["x"] = item["x"]
                xJSON["x2"] = item["x2"]
                xJSON["y"] = item["y"]
                xJSON["color"] = item["color"]
                xJSON["tasks"] = item["tasks"]
                if  item["tasks"] as! String == context.getProperty("this.tasks") as! String{
                    xJSON["borderWidth"] = 4
                    xJSON["borderColor"] = "blue"
                } else {
                    xJSON["borderWidth"] = 0
                    xJSON["borderColor"] = "gray"
                }
                GAACOdict.append(xJSON)
            }
            self.GAACOX = GAACOdict
        

            let EDDxrange = HIXrange()
            EDDxrange.name = "EDD"
            EDDxrange.borderColor = HIColor(name: "gray")
            EDDxrange.pointWidth = 14
            EDDxrange.borderRadius = 0
            EDDxrange.data = self.EDDX
            
            let GAxrange = HIXrange()
            GAxrange.name = "GA"
            //xrange.pointPadding = 20
            // xrange.groupPadding = 0
            GAxrange.borderColor = HIColor(name: "gray")
            GAxrange.pointWidth = 14
            GAxrange.borderRadius = 0
            GAxrange.data = self.GAX
            
            let ACOxrange = HIXrange()
            ACOxrange.name = "ACO"
            //xrange.pointPadding = 20
            // xrange.groupPadding = 0
            ACOxrange.borderColor = HIColor(name: "gray")
            ACOxrange.pointWidth = 14
            ACOxrange.borderRadius = 0
            ACOxrange.data = self.ACOX
            
            let GAACOxrange = HIXrange()
            GAACOxrange.name = "GAACO"

            GAACOxrange.borderColor = HIColor(name: "gray")
            GAACOxrange.pointWidth = 14
            GAACOxrange.borderRadius = 0
            GAACOxrange.data = self.GAACOX
            
            
            options.series = [EDDxrange,GAxrange,ACOxrange,GAACOxrange]

            chartView.options = options

            
        }, properties: ["this.category", "this.tasks"])
        
       // plotOptions.series.point.events.click = HIFunction(jsFunction: "function () { alert(this.series);this.series.remove();  }")
        plotOptions.series.point.events.click = chartFunction
        options.plotOptions = plotOptions

        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        gantt.addSubview(chartView)
        
   
        //甘特圖左,上,右constraint
        chartView.leadingAnchor.constraint(equalTo: gantt.leadingAnchor, constant: 0).isActive = true
        chartView.topAnchor.constraint(equalTo: gantt.topAnchor, constant: 0).isActive = true
        chartView.trailingAnchor.constraint(equalTo: gantt.trailingAnchor, constant: 0).isActive = true
        chartView.bottomAnchor.constraint(equalTo: gantt.bottomAnchor, constant: 0).isActive = true
        
        
        
        
        
        
        
        
        
        
        
        

//MARK: - 返回前一頁(偵測滑動螢幕左邊)
        //跳頁
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
        
        
    }
    
    
    
    //甘特圖高度
    func chartHeight(counts: Int) -> Int{
        let height:Int = Int(250 * counts)
        return height
    }
    
    
    //將專案加入排程池的UIAlert
    @IBAction func button_Action_AddSchedule(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "加入排程", message: "確認是否要將專案此放入實際排程中？", preferredStyle: UIAlertController.Style.alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: nil)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    

    
//MARK: - POST資料
    
    func getData(){
        
        print("我有在載資洛")
        let url = URL(string: "http://140.135.97.72:3000/swift/ScheduleResult")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        
        //let MachineName = machine!
        let user = postvalue(orderNumber: sendNumber!)
        //let user = postKey(orderFormNumber: orderNumberTest!)
        let data = try? encoder.encode(user)
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                   // print("data:\(data),~~~~~~~~~~")
                    let decoder = JSONDecoder()
                    let createUserResponse = try decoder.decode(SingalSchedule.self, from: data)
                    //print(createUserResponse)
                    
                    //甘特圖Ｙ軸的機台
                    self.Ymachine = createUserResponse.EDDYAxisCategories
                    
                   //此專案零件
                    self.tasks = createUserResponse.tasks

                    //EDD的Ｘ軸資料
                    for item in createUserResponse.EDDXrangeData{
                        var xJSON:[String:Any] = ["x": Int(),"y": Int(),"x2":Int(),"color":"","tasks":"","borderWidth":Int(),"borderColor":""]
                        xJSON["x"] = item.x
                        xJSON["x2"] = item.x2
                        xJSON["y"] = item.y
                        xJSON["color"] = item.color
                        xJSON["tasks"] = item.tasks
                        xJSON["borderWidth"] = 0
                        xJSON["borderColor"] = "gray"
                        self.EDDX.append(xJSON)

                    }

                    
                    //GA的Ｘ軸資料
                    for item in createUserResponse.GAXrangeData{
                        var xJSON:[String:Any] = ["x": Int(),"y": Int(),"x2":Int(),"color":"","tasks":"","borderWidth":Int(),"borderColor":""]
                        xJSON["x"] = item.x
                        xJSON["x2"] = item.x2
                        xJSON["y"] = item.y
                        xJSON["color"] = item.color
                        xJSON["tasks"] = item.tasks
                        xJSON["borderWidth"] = 0
                        xJSON["borderColor"] = "gray"
                        self.GAX.append(xJSON)
                    }
        
                    
                    //ACO的Ｘ軸資料
                    for item in createUserResponse.ACOXrangeData{
                        var xJSON:[String:Any] = ["x": Int(),"y": Int(),"x2":Int(),"color":"","tasks":"","borderWidth":Int(),"borderColor":""]
                        xJSON["x"] = item.x
                        xJSON["x2"] = item.x2
                        xJSON["y"] = item.y
                        xJSON["color"] = item.color
                        xJSON["tasks"] = item.tasks
                        xJSON["borderWidth"] = 0
                        xJSON["borderColor"] = "gray"
                        self.ACOX.append(xJSON)
                    }
                   
                    
                    //GAACO的Ｘ軸資料
                    for item in createUserResponse.GAACOXrangeData{
                        var xJSON:[String:Any] = ["x": Int(),"y": Int(),"x2":Int(),"color":"","tasks":"","borderWidth":Int(),"borderColor":""]
                        xJSON["x"] = item.x
                        xJSON["x2"] = item.x2
                        xJSON["y"] = item.y
                        xJSON["color"] = item.color
                        xJSON["tasks"] = item.tasks
                        xJSON["borderWidth"] = 0
                        xJSON["borderColor"] = "gray"
                        self.GAACOX.append(xJSON)
                    }

                    self.ScheduleValue = createUserResponse.ScheduleValue
                    
                    //使四排程計算時間取小數後兩位
                    let EDDTimestring = String(format:"%.2f",Double(createUserResponse.ScheduleValue[0].EDDTime)!)
                    self.ScheduleValue[0].EDDTime = EDDTimestring
                    print(EDDTimestring)
                    
                    let GATimestr = String(format: "%.2f", Double(createUserResponse.ScheduleValue[0].GATime)!)
                    self.ScheduleValue[0].GATime = GATimestr
                    
                    let ACOTimestr = String(format: "%.2f", Double(createUserResponse.ScheduleValue[0].ACOTime)!)
                    self.ScheduleValue[0].ACOTime = ACOTimestr
                    
                    let GAACOTimestr = String(format: "%.2f", Double(createUserResponse.ScheduleValue[0].GAACOTime)!)
                    self.ScheduleValue[0].GAACOTime = GAACOTimestr
                    
                    print("最後資料\(self.ScheduleValue)")
                    
       
                   
                        OperationQueue.main.addOperation({
                            self.view.setNeedsLayout()
                           // self.view.reloadInputViews()
                            //self.loadView()
                            
                            self.gantt.subviews.forEach({ $0.setNeedsLayout() })
                            self.gantt.subviews.forEach({ $0.layoutIfNeeded() })
                             
                            
                            print("我有更新視窗囉")
                        })
                } catch  {
                    print(error)
                }
            }
        }.resume()
        
    
    }
    
    
//MARK: - 跳頁回上一頁(動作)
        //跳頁回去
        @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
            if recognizer.state == .recognized {
                print("Screen edge swiped!")
    
 //               let EditSchedule = self.storyboard?.instantiateViewController(identifier: "EditSchedule")
//                self.present(EditSchedule!, animated: true, completion: nil)
                
                //回上一頁
                self.dismiss(animated: true, completion: nil)
    
            }
        }
    
}


