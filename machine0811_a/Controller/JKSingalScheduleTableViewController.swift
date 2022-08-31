//
//  JKSingalScheduleTableViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2021/10/15.
//

import UIKit

class JKSingalScheduleTableViewController: UITableViewController {
    
    //所選專案號(前面所選)
    var chooseNumber:String?
    var Best: String?
    var state: String?
    

    
    //上方專案資料
    var ScheduleData = [String: String]()
    
    //下方零件資料
    var tasksData: [SignalSTData] = []
    
    //步進圖資料
    var SingalET: [[String]] = []
    var SingalRT: [[String]] = []
    
    //專案號碼
    @IBOutlet weak var ScheduleNumber: UILabel!
    //零件數量
    @IBOutlet weak var tasksCount: UILabel!
    //製程數量
    @IBOutlet weak var AllScheduleCount: UILabel!
    //加工時數
    @IBOutlet weak var AllWorkTime: UILabel!
    //專案狀況
    @IBOutlet weak var ScheduleSituation: UILabel!
    //上方白色view(加底線)
    @IBOutlet weak var underborder: UIView!
    
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(chooseNumber!)
        
        tableView.rowHeight = 141
        postData()
        sleep(1)
        //上方資料
        ScheduleNumber.text = chooseNumber
        tasksCount.text = ScheduleData["tasksCount"]
        AllScheduleCount.text = ScheduleData["AllScheduleCount"]
        AllWorkTime.text = "\(String(describing: ScheduleData["AllWorkTime"]!)) hr"
        ScheduleSituation.text = state == "A" ? "尚未排入":"已排入"
        
        //邊框框線
        let Border = CALayer()
        Border.frame = CGRect(x: 0, y: underborder.frame.size.height, width: underborder.frame.size.width, height: 1)
        Border.backgroundColor = UIColor(displayP3Red: 207/255, green: 207/255, blue: 207/255, alpha: 1).cgColor
        underborder.layer.addSublayer(Border)

        
        //不使用segue跳頁
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
    }

    //post資料
    func postData(){
        let url = URL(string: "http://140.135.97.72:3000/swift/SelectScheduleProject")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        
       
        let user = SingalPostKey(orderNumber: chooseNumber!, Best: Best!, State: state!)
        //let user = postvalue(orderNumber: sendNumber!)
        
        let data = try? encoder.encode(user)
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    
                    let decoder = JSONDecoder()
                    let createUserResponse = try decoder.decode(SingalScheduleTask.self, from: data)
                    //print(createUserResponse.Data[0])
                    
                    //將上方的專案資匯會到字典中
                    self.ScheduleData["orderNumber"] = createUserResponse.orderNumber
                    self.ScheduleData["tasksCount"] = String(createUserResponse.tasksCount)
                    self.ScheduleData["AllScheduleCount"] = String(createUserResponse.AllScheduleCount)
                    self.ScheduleData["AllWorkTime"] = String(createUserResponse.AllWorkTime)
                    
                    for item in createUserResponse.Data {
                        
                        //將Data資料轉到taskData
                        self.tasksData.append(item)
                        
                        //步進圖預估時間
                        var ETStr: [String] = []
                        for i in item.estimatedTime{
                            let list = "預估：\(i)hr"
                            ETStr.append(list)
                        }
                        self.SingalET.append(ETStr)
                        
                        //步進圖實際時間
                        var RTStr: [String] = []
                        for i in item.RealWorkTime {
                            let list = i == "0" ? "未完成":"實際: \(i)hr"
                            RTStr.append(list)
                        }
                        self.SingalRT.append(RTStr)
                        
                    }
                    print(self.SingalET)
                    print(self.SingalRT)
                   
                        OperationQueue.main.addOperation({
                            self.tableView.reloadData()
                        })
                    //print(self.ScheduleData)
                    //print(self.tasksData)
                } catch  {
                    print(error)
                }
            }
        }.resume()
    }

    // MARK: - Table view data source
    //表格資料
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    //表格數量
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasksData.count
    }

    //表格數據
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! JKSingalScheduleTableViewCell

        cell.tasks.text = self.tasksData[indexPath.row].tasks
        let realstr = self.tasksData[indexPath.row].TotalRealWorkTime == 0 ? "尚未完成":"\(self.tasksData[indexPath.row].TotalRealWorkTime)小時"
        cell.TotalRealWT.text = "加工時間: \(realstr)"
        cell.TotalEstWT.text = "預計完成工時: \(self.tasksData[indexPath.row].TotalWorkTime)小時"
        cell.configure(url: self.tasksData[indexPath.row].ImgUrl)
        cell.initbar(self.tasksData[indexPath.row])
        cell.initbarest(self.SingalET[indexPath.row])
        cell.initmachine(self.tasksData[indexPath.row].WorkerMachine)
        cell.initrealTime(self.SingalRT[indexPath.row])
        

        return cell
    }
    
    //表格title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title: String = "零件加工清單"
        return title
    }

    //表格調整樣式
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myLabel = UILabel()
            myLabel.frame = CGRect(x: 15, y: 30, width: 320, height: 25)
            myLabel.font = UIFont.boldSystemFont(ofSize: 16)
            myLabel.textColor = .gray
            myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)

            let headerView = UIView()
            headerView.addSubview(myLabel)

            return headerView
    }
    
    
    
    
    
    
    
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
