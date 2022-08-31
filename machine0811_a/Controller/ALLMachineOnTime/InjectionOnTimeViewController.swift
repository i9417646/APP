//
//  InjectionOnTimeViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2021/12/29.
//

import UIKit
import SocketIO

class InjectionOnTimeViewController: UIViewController {
    
    //用來做切換頁籤(即時數據/數據分析)的參數依據
    var chooseID: String = "InjectionOnTimeData"
    //目前選到的機台名稱
    var NowMachine: String = ""
    //目前模數
    var mold: Int = 0
    //總模數
    var AllMold: Int = 3672

    @IBOutlet weak var BottomView: UIView!
    
    @IBOutlet weak var startTime: UILabel!
    
    @IBOutlet weak var EndTime: UILabel!
    
    @IBOutlet weak var moldStr: UILabel!
    
    @IBOutlet weak var AllMoldStr: UILabel!
    


    
    
   //Socket
    let manager = SocketManager(socketURL: URL(string: "http://140.135.97.69:8787")!, config: [.log(false), .forceWebsockets(true)])
    
    var socket:SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //拿過去前面100筆資料
        getdata()
        
        self.moldStr.text = "\(self.mold)"
        
        self.AllMoldStr.text = "\(self.AllMold)"

        
        let socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { (data, ack) in
            print(data)
            print("socket connected射出機即時資訊主頁")
            
           
            
        }
        
        socket.on(clientEvent: .error) { (data, eck) in
            print(data)
            print("socket error")
            
        }
        
        socket.on(clientEvent: .disconnect) { (data, eck) in
            print(data)
            print("socket disconnect")
        }
        
        socket.on("injDDS"){ (data, _) in
        
            
            
            guard let dataInfo = data.first else { return }
            
            //將Socket所收到的資料進行解碼
            if let response: InjSocketData = try? SocketParser.convert(data: dataInfo) {
                //目前模數加一
                self.mold += 1
                //總模數加一
                self.AllMold += 1
                
                self.moldStr.text = "\(self.mold)"
                
                self.AllMoldStr.text = "\(self.AllMold)"
                
                print(response)
                    
                //作為時間解碼格式
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                //時間格式
                let fomatter = DateFormatter()
                fomatter.dateFormat = "HH:mm:ss"
                    
                //冷卻結束時間＝數據傳出當下時間點
                ///將UTC時間轉為Date格式,再以HH:mm:ss顯示
                let EndData = dateFormatter.date(from: response.receivedAt)
                let EndDataN = EndData?.addingH(hours: -8)
                self.EndTime.text = "\(fomatter.string(from: EndDataN!))"
                //總時間
                let allTime: Int = lround(Double(response.SPC_fillingTime)! + Double(response.Cooling_T)! + Double(response.PACK_T_1st)! + Double(response.PACK_T_2nd)! + Double(response.PACK_T_3rd)!)
                
                print(allTime)
                //時間格式轉換
                let startTimeData = EndData?.addingS(seconds: -allTime)
                self.startTime.text = "\(fomatter.string(from: startTimeData!))"
                
            }
        }
        
        socket.connect()
    }
    
    //get讀取歷史資料
    func getdata() {
        let url = URL(string: "http://140.135.97.69:8787/TodayINJcount")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do{
                    
                    let decoder = JSONDecoder()
                    //TodayINJcount
                    let createUserResponse = try decoder.decode(TodayINJcount.self, from: data)
                    
                    print(createUserResponse.count)
                    
                    self.mold = createUserResponse.count
                    
                    OperationQueue.main.addOperation({
                        self.moldStr.text = "\(self.mold)"
                    })
                    
                } catch  {
                    print(error)
                }
                
            }
            
        }.resume()
        
    }
    
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadBottomView()
        
    }
    
    @IBAction func MachineDataClick(_ sender: Any) {
        self.chooseID = "InjectionOnTimeData"
        
        self.loadBottomView()
        
        print(self.chooseID)
  
    }
    
    @IBAction func AnalysisClick(_ sender: Any) {
        
        
        self.chooseID = "InjectionOnTimeAnalysis"
        print(self.chooseID)
        self.loadBottomView()
        
 
    }
    
    //切換頁籤所要顯示的畫面放入下面的視窗中
    func loadBottomView(){
        if self.chooseID == "InjectionOnTimeData" {
            
            //刪除BottomView的所有子視圖
            for view in self.BottomView.subviews {
                view.removeFromSuperview()
            }
            
            //使用Storyboard ID的方式來加入畫面(不使用segue)
            let controller = storyboard!.instantiateViewController(withIdentifier: "InjectionOnTimeData") as! InjectionOnTimeMachineDataViewController
            addChild(controller)
            BottomView.addSubview(controller.view)
        
            
        } else {
            
            //刪除BottomView的所有子視圖
            for view in self.BottomView.subviews {
                view.removeFromSuperview()
            }
            
            //使用Storyboard ID的方式來加入畫面(不使用segue)
            if self.chooseID == "InjectionOnTimeAnalysis" {
                let controller = storyboard!.instantiateViewController(withIdentifier: "InjectionOnTimeAnalysis")
                addChild(controller)
                BottomView.addSubview(controller.view)
            }
        }
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
