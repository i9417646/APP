//
//  workTableViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2021/9/1.
//

import UIKit

class workTableViewController: UITableViewController {
    //求取資料的路徑
    let urlStr = "http://140.135.97.72:3000/swift/LoadProjectStatus"
    var work: [Work] = []
    var workDateLine:[String] = []
    let reuseIdentifier = "cell"
    
    //get資料
    func getData() {
        
        let url = URL(string: "http://140.135.97.72:3000/swift/LoadProjectStatus")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            //print(data!)
            if let data = data{
                       do {
                           let decoder = JSONDecoder()
                           let createUserResponse = try decoder.decode([Work].self, from: data)
                        print(createUserResponse)
                   
                        for item in createUserResponse {
                            self.work.append(item)
                            
                            
                            //處理開始時間及日期
                            let str = item.qcSchedule
                            let a = NSString(string: str)
                            let b = "專案交期: \(a.substring(with: NSMakeRange(0,10)))"
                            self.workDateLine.append(b)
                            
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
        
       
        
        //單個表格高度
        tableView.rowHeight = 110
        //getData()

  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        work = []
        workDateLine = []
        getData()
        

        // tableView.reloadData()
    }
    
    
// MARK: - Table view data source
   //表格section
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //表格有幾項
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return work.count
    }

    //表格資料
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! workTableViewCell
        
        cell.orderNBTitle.text = String("專案編號")
        cell.OrderFormNumber.text = work[indexPath.row].orderFormNumber
        cell.qcSchedule.text = workDateLine[indexPath.row]
        
        let string = NSMutableAttributedString(string: workDateLine[indexPath.row])
        string.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: work[indexPath.row].ScheduleStatusColor), range: NSMakeRange(0, 16))
        cell.qcSchedule.attributedText = string


        return cell
    }
    
    
    //segue換頁
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_orderinfo" {
             if let destation = segue.destination as? JKTableViewController{
                let cell = sender as! workTableViewCell
                let indexPath = tableView.indexPath(for:cell)
                let orderNumber = work[(indexPath?.row)!].orderFormNumber
                
                destation.orderNumberTest = orderNumber
                
             }
            
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
