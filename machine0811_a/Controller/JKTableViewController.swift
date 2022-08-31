//
//  JKTableViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2021/9/7.
//

import UIKit
import JKSteppedProgressBar

class JKTableViewController: UITableViewController {
    
    @IBOutlet weak var orderNumberTitle: UILabel!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var taskcount: UILabel!
    @IBOutlet weak var ScheduleCount: UILabel!
    @IBOutlet weak var estordertime: UILabel!
    //@IBOutlet weak var addCase: UIButton!
    
    //所選的專案號
    var orderNumberTest:String?
    //var ordernumber: String = "2Y0040176"
    
    var progressBar: SteppedProgressBar!
    
    //專案資訊
    var ＷorkTitle1: Dictionary<String, String> = ["tasksCount": "0", "AllScheduleCount": "1","AllWorkTime":"2"]
    //總資料
    var Data:[singalWork] = []
    
    //單一零件各個製程時間
    var estTimeString:[Any] = []
    //單一零件總預估時間
    var allEstTimeString:[String] = []
    //單一零件製成數量
    var processcount:[String] = []
    
    
    //post取得資料
    func getData(){
        let url = URL(string: "http://140.135.97.72:3000/swift/LoadProjectValue")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        
        //let MachineName = machine!
        let user = postKey(orderFormNumber: orderNumberTest!)
        let data = try? encoder.encode(user)
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    
                    let decoder = JSONDecoder()
                    let createUserResponse = try decoder.decode(singleData.self, from: data)
                    //print(createUserResponse)
                   
                    self.ＷorkTitle1["tasksCount"] = "零件數量:\(createUserResponse.tasksCount)"
                    self.ＷorkTitle1["AllScheduleCount"] = "製程總數:\(createUserResponse.AllScheduleCount)"
                    self.ＷorkTitle1["AllWorkTime"] = "預估總工時:\(createUserResponse.AllWorkTime)hr"
                    
                    for item in createUserResponse.Data {
                        
                        //DATA
                        self.Data.append(item)
                        //print(item)
                        
                        //預估時間estTimeString
                        var listarray:[String] = []
                        for i in item.estimatedTime {
                            let str = String(i)
                            let list = "預估：\(str)hr"
                            listarray.append(list)
                        }
                        self.estTimeString.append(listarray)
                        
                        
                        //預估總工時allEstTimeString
                        let allest = String(item.TotalWorkTime)
                        let eststr = "預估總工時：\(allest)hr"
                        self.allEstTimeString.append(eststr)
                        
                        //製成數量
                        let processcountStr = String(item.processType.count)
                        self.processcount.append("製程數量：\(processcountStr)")
                        
                    }
                   
                        OperationQueue.main.addOperation({
                            self.tableView.reloadData()
                        })
                } catch  {
                    print(error)
                }
            }
        }.resume()
        
    }

    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
        //延遲一秒等資料進來
        sleep(1)
        orderNumberTitle.text = "專案號"
        orderNumber.text = orderNumberTest
        taskcount.text = ＷorkTitle1["tasksCount"]
        ScheduleCount.text = ＷorkTitle1["AllScheduleCount"]
        estordertime.text = ＷorkTitle1["AllWorkTime"]
        //addCase. = "加入排程"
        
        
        if let orderNumberTest = orderNumberTest{
            print("所選專案名稱\(orderNumberTest)")
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    
    
    
    //上方視圖
    // 點選加入排成選項所觸發的動作
    @IBAction func addMessage(sender: UIButton) {
        
        //alert視窗
        let alertController = UIAlertController(title: "加入排程", message: "確認是否要將專案此放入排程中？", preferredStyle: UIAlertController.Style.alert)
        
        let addProjectHandler = { (action: UIAlertAction!) -> Void in
            
            let alert = UIAlertController(title: "處理中...", message: nil, preferredStyle: .alert)
            //加入轉圈圖示
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.isUserInteractionEnabled = false
            activityIndicator.startAnimating()
            
            alert.view.addSubview(activityIndicator)
            alert.view.heightAnchor.constraint(equalToConstant: 95).isActive = true
            
            activityIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor, constant: 0).isActive = true
            activityIndicator.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -20).isActive = true
            

            
            self.present(alert, animated: true)
            
            self.postData()
            
            //將資料放入排成計算並且更新
//            self.dismiss(animated: true) {
//                    // If you need call someFunction()
//                    self.postData()
//                    self.navigationController?.popViewController(animated: true)
//                    self.tableView.reloadData()
//                }
            
            
        }
        
        
     
        //alert選項
        let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: addProjectHandler)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    //postkey的架構
    struct Body: Encodable {
        let orderFormNumber: String
    }
    //post回來資料的架構
    struct Response: Decodable {
        let ScheduleNumber: String
    }
    
    //post資料
    func postData(){
        let url = URL(string: "http://140.135.97.72:3000/swift/RunSchedule")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        let user = Body(orderFormNumber: orderNumberTest!)
        let data = try? encoder.encode(user)
        request.httpBody = data
        URLSession.shared.dataTask(with: request){ data, response, error in
            if let data = data{
                do {
                    let  decoder = JSONDecoder()
                    let createUserResponse = try decoder.decode([Response].self, from: data)
                    print(createUserResponse)
                    print("============================================")
                }catch{
                    print(error)
                }
                
            }
            //更新表格
            OperationQueue.main.addOperation({
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popToRootViewController(animated: true)
               // self.tableView.reloadData()
            })

            
        }.resume()
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //表格
// MARK: - Table view data source
    
    
    //表格section為1
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    //表格總數
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Data.count
    }

    //表格資料
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! JKTableViewCell

        cell.img.image = UIImage(named: "OR_VC-P76_LC1602_自動")
        cell.task.text = Data[indexPath.row].tasks
        cell.processcount.text = processcount[indexPath.row]
        cell.estalltime.text = allEstTimeString[indexPath.row]
        cell.configure(url: Data[indexPath.row].ImgUrl)
        cell.initbar(Data[indexPath.row])
        cell.initbarest(estTimeString[indexPath.row])

        return cell
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//    override var prefersStatusBarHidden: Bool{
//        get {
//            return true
//        }
//    }
    
    
    
    
    


}
