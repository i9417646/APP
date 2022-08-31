//
//  orderTableViewController.swift
//  machine0811_a
//
//  Created by julie on 2021/8/11.
//

import UIKit




//用來求取資料的路徑
private let urlStr = "http://140.135.97.72:3000/swift/ACOTest"

private let orders:[order] = []

private let estimatedTimeString:[String] = []


//var machineName:String?


private var machineDatas:[machineData] = []
//private var postvalue = "MachineName=\(machineName)"




class orderTableViewController: UITableViewController {
    
    
    //從container傳值
    var machine: String? = "twice"
    
    lazy var machineDatas:[machineData] = []

    //求取資料後經過解碼的資料放這作暫存
    var orders:[CreateUserResponse] = []
    //預估時間
    var estimatedTimeString:[String] = []
    var StartDate:[String] = []
    var StartTime:[String] = []
   
    
   
    

    
    //post資料進來
    func postdata(){
        let url = URL(string: "http://140.135.97.72:3000/swift/SelectMachineProjectInside")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        //let user = CreateUserBody(MachineName: machineName)
        let MachineName = machine!
        let user = CreateUserBody(MachineName: MachineName)
        let data = try? encoder.encode(user)
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let createUserResponse = try decoder.decode([CreateUserResponse].self, from: data)
                   // print(createUserResponse)
                    for item in createUserResponse{
                        self.orders.append(item)
                        
                    
                    //轉換時間資料
                        let est = item.estimatedTime * 60
                        let eststring = String(format:"%.f",est)
                        let list = " \(eststring) 分鐘"
                        self.estimatedTimeString.append(list)
                     //處理開始時間及日期
                        let str = item.fifoStartTime
                        let a = NSString(string:str)
                        self.StartDate.append(a.substring(with: NSMakeRange(5, 5)))
                        self.StartTime.append(a.substring(with: NSMakeRange(11, 5)))
                        
                    }
                        OperationQueue.main.addOperation({
                            self.tableView.reloadData()
                        })
                } catch  {
                    print(error)
                }
            }
        }.resume()
        print("123 \((machine)!)")
    }
    


    
 

    override func viewDidLoad() {
        
        //getData()
        
        postdata()
        //print(machineName)

        
        
        super.viewDidLoad()
       
        //getpostdata(machineName1: machineName)
        

        

        
        //print(orders)
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return machine
//    }
    
    //單格表格高度
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //一個section
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //表格有幾項
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orders.count
    }
    
    //將資料填入
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "datacell", for: indexPath) as! orderTableViewCell
        
        cell.tasks.text = orders[indexPath.row].tasks
        cell.orderFormNumber.text = orders[indexPath.row].orderNumber
        //cell.fifoStartTime.text = orders[indexPath.row].fifoStartTime
        cell.estimatedTime.text = estimatedTimeString[indexPath.row]
        cell.StartDate.text = StartDate[indexPath.row]
        cell.StartTime.text = StartTime[indexPath.row]
        cell.configure(url: orders[indexPath.row].ImgUrl)
        
        //cell.machineImg.image = UIImage(named: "CNC_01")
//        for item in orders{
//            let task2 = URLSession.shared.dataTask(with: item.ImgUrl) { (data, response, error) in
//                if let data = data{
//                   DispatchQueue.main.async {
//                     cell.machineImg.image = UIImage(data: data)
//                   }
//                }
//            }
//            task2.resume()
//        }

        
        return cell
    }
    
    
    
//    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//
//        let header = view as! UITableViewHeaderFooterView
//
//        header.textLabel?.font = UIFont(name: "Futura", size: 30)!
//
//    }
   

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
