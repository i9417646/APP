//
//  CNCHistoryViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2022/4/1.
//

import UIKit
import CodableCSV




class CNCHistoryViewController: UIViewController {


    var CNCDataStr: String = ""
    
    var CNCData:[CNCHistoryData] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("890")

        CNCFile()
        getData()
       
        
        print("1234")
        

    }
    
    
    func testDecoder() {
        let AAAdata = """
[["1","2","3","3"],["1","2","3","3"]]
""".data(using: .utf8)
        do {
            let createUserResponse = try JSONDecoder().decode([[String]].self, from: AAAdata!)
            print(createUserResponse)
        } catch {
            print(error)
        }
    
    }

    //取得CNC檔案
    func CNCFile(){
        let url = URL(string: "http://140.135.97.72:8787/selectCNCfile")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, request, error in
            if let data = data {
              
                do {
                    let decoder = JSONDecoder()
                    let createUserResponse = try decoder.decode([[String]].self, from: data)
                    print(createUserResponse[1])
                } catch {
                    print(error)
                }
            }
        }.resume()
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
