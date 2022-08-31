//
//  EditSchduleTableViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2021/10/7.
//

import UIKit

class EditSchduleTableViewController: UITableViewController {
    
    //UI連接
    @IBOutlet weak var orderNumberString: UILabel!
    @IBOutlet weak var BestString: UILabel!
    @IBOutlet weak var TimeString: UILabel!
    @IBOutlet weak var StatusString: UILabel!
    
    
    //將get到的資料儲存在這
    var data: [AllWorkSchedule] = []
    //最佳演算法時間
    var BestTime:[String] = []
    var StatusStr:[String] = []
    //工作進度的字串
    var StatusE:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        orderNumberString.text = "排程編號"
        BestString.text = "最佳演算法"
        TimeString.text = "排程時數"
        StatusString.text = "工作進度"
        
        
        getData ()
        
       
        
        tableView.rowHeight = 75
        //sleep(1)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        

        
    }
    
    
    
    func getData (){
        let url = URL(string: "http://140.135.97.72:3000/swift/AllWorkSchedule")!
        let request = URLRequest(url: url)
        
  
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data{
                 do {
                    
                    let decoder = JSONDecoder()
                    let createUserResponse = try decoder.decode([AllWorkSchedule].self, from: data)
                        
                    print("11111111:\(createUserResponse)")
                   
                        
                    //匯入array中
                    self.data = createUserResponse
                    
                    
                    for item in createUserResponse {
                        let BestName = String(item.PorjectData["Best"]!)
                        self.BestTime.append(item.PorjectData[BestName]!)
                        self.StatusE.append(item.Status)
//                        print(BestName)
//                        print(item.PorjectData[BestName]!)
                        
                        
                        if item.Status == "A"{
                            let StatusStr: String = "尚未排入"
                            self.StatusStr.append(StatusStr)
                        }else{
                            let StatusStr: String = "已排入"
                            self.StatusStr.append(StatusStr)
                        }
                        
                 //       print(self.StatusStr)


                    }
   
                    //更新表格
                    OperationQueue.main.addOperation({
                        self.tableView.reloadData()
                    })
                       } catch  {
                           print(error)
                       }
                   }
        }.resume()
        
    }

    // MARK: - Table view data source
    //tableview資料
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    //表格總數
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    //表格資料
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditScheduleTableViewCell

        cell.orderNumber?.text = data[indexPath.row].PorjectData["orderNumber"]
        cell.BestString?.text = data[indexPath.row].PorjectData["Best"]
        cell.TimeString?.text = "\(BestTime[indexPath.row]) 小時"
        cell.Status?.text = StatusStr[indexPath.row]
        
        return cell
    }
    
    
    
    
    
    
    
    //cell是否可滑動
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //向左滑動產生動作
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //所選的專案名稱
        let Schedule = self.data[indexPath.row].PorjectData["orderNumber"]
        let BEST = self.data[indexPath.row].PorjectData["Best"]
        let status = self.StatusE[indexPath.row]
        //加入左滑指令
        let work = UIContextualAction(style: .destructive, title: "排程結果") { (action, view, complectionHandle) in
            print("排程結果.....")
            let work = self.storyboard?.instantiateViewController(identifier: "work") as? SingalEditScheduleViewController
            work!.sendNumber = Schedule
            work!.projectStatus = status
           
            self.present(work!, animated: true, completion: nil)
            
        }
        
        //不使用segue來跳頁
        let edit = UIContextualAction(style: .destructive, title: "工作狀況") {(action, view, complectionHandle) in
            print("工作狀況.....")
            
            let task = self.storyboard?.instantiateViewController(identifier: "task") as? JKSingalScheduleTableViewController
            //將數據傳入下一頁
            task!.chooseNumber = Schedule
            task!.Best = BEST
            task!.state = status
            self.present(task!, animated: true, completion: nil)
        }
        
        work.backgroundColor = UIColor.orange
       
        edit.backgroundColor = UIColor.systemBlue
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [work, edit])
        
        return swipeConfiguration
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
