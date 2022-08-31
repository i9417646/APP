//
//  CNCHisProjectNoTableViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2022/4/8.
//

import UIKit
import CodableCSV

class CNCHisProjectNoTableViewController: UITableViewController {
    
    var CNCData:[CNCHistoryData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("外面的的喔\(CNCFile().csvFileName)")
        getData()

       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

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
    
    //取得CNC檔案
    func CNCFile() -> (txtFileName: [String], csvFileName: [String]){
        var txtFile = [String]()
        var csvFile = [String]()
        
        let url = URL(string: "http://140.135.97.72:8787/selectCNCfile")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { data, request, error in
                if let data = data {
                  
                    do {
                        let decoder = JSONDecoder()
                        let createUserResponse = try decoder.decode([[String]].self, from: data)
                        
                        for item in createUserResponse[0] {
                            txtFile.append(item)
                        }
                        for item in createUserResponse[0] {
                            csvFile.append(item)
                        }
            
                        print("csvFile:\(csvFile)")
                        
                    } catch {
                        print(error)
                    }
                }
            }.resume()

        
        return (txtFile, csvFile)
    }
    
    func getData() {
        let url = URL(string: "http://140.135.97.72:8787/CNC_YTM763/CNCData/20210527184612YTM763.csv")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            //print(data)
            if let data = data {
                
                do {
//                    //讀取CSV檔
//                    let result = try CSVReader.decode(input: data)
//                    ///讀取CSV檔:標題
//                    let headers: [String] = result.headers
//                    ///讀取CSV檔行列
//                    let rows = result.rows
//                    let row = result[1]
                    //CSV解碼方法
                    let decoder = CSVDecoder { $0.headerStrategy = .firstLine }
                    //執行CSV解碼
                    let response = try decoder.decode([CNCHistoryData].self, from: data)
                    
                    let DataFilter = response.filter { $0.partNo != "text" }
                    
                    for item in DataFilter{
                        self.CNCData.append(item)
                    }
                    
                    print(self.CNCData.count)
                    print(response.count)

    //                print("record\(response[0])")
                    
                    
                   
                } catch {
                    print(error)
                }
            }
            
        }.resume()
        print("----------------------------------------------------------")
    }

}
