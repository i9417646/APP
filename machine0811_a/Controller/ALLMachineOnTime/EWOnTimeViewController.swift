//
//  EWOnTimeViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2022/3/28.
//

import UIKit
import SocketIO

class EWOnTimeViewController: UIViewController {

    var NowMachine: String = ""
    
    
    //初始預設資料
    var machineData = _sourcePOST(AOFF: "-", AON: "-", AlarmTotal: "-", CWT: "-", CmpTap: "-", CutLen: "-", Elapsed: "-", F: "-", FR: "-", FT: "-", Feedrate: "-", ION: "-", IP: "-", Left: "-", NO: "", Ncode: "-", OFF: "-", ON: "-", OV: "-", Offset: "-", Progress: "-", SG: "-", SV: "-", Tangle: "-", TotalLen: "-", Ucoor: "-", Vcoor: "-", Volts: "-", WA: "-", WF: "-", WT: "-", Xcoor: "-", Ycoor: "-", Zcoor: "-", timestamp: "-")
    
   
    private weak var task: URLSessionTask?
    
    //創建時間變數來儲存計時器
    var timer = Timer()
    
 
    
    
    @IBOutlet weak var parameterView: UIView!
    @IBOutlet weak var information: UIView!
    @IBOutlet var coordinateView: UIView!
    
    @IBOutlet weak var receivedAtStr: UILabel!
    
    
    @IBOutlet weak var VoltsStr: UILabel!
    @IBOutlet weak var ION: UILabel!
    @IBOutlet weak var CWT: UILabel!
    @IBOutlet weak var NO: UILabel!
    @IBOutlet weak var IPStr: UILabel!
    @IBOutlet weak var OVStr: UILabel!
    @IBOutlet weak var ONStr: UILabel!
    @IBOutlet weak var OFFStr: UILabel!
    
    @IBOutlet weak var AONStr: UILabel!
    @IBOutlet weak var AOFFStr: UILabel!
    @IBOutlet weak var SVStr: UILabel!
    @IBOutlet weak var WTStr: UILabel!
    @IBOutlet weak var WFStr: UILabel!
    @IBOutlet weak var WAStr: UILabel!
    @IBOutlet weak var FRStr: UILabel!
    @IBOutlet weak var FStr: UILabel!
    @IBOutlet weak var FTStr: UILabel!
    
    @IBOutlet weak var FeedrateStr: UILabel!
    @IBOutlet weak var Elapsed: UILabel!
    @IBOutlet weak var LeftStr: UILabel!
    @IBOutlet weak var TotalLenStr: UILabel!
    @IBOutlet weak var CutLenStr: UILabel!
    @IBOutlet weak var CmpTap: UILabel!
    @IBOutlet weak var OffsetStr: UILabel!
    @IBOutlet weak var TangleStr: UILabel!
    @IBOutlet weak var ProgressStr: UILabel!
    
    @IBOutlet weak var XcoorStr: UILabel!
    @IBOutlet weak var YcoorStr: UILabel!
    @IBOutlet weak var ZcoorStr: UILabel!
    
    
///    let manager = SocketManager(socketURL: URL(string: "http://140.135.97.69:8787")!, config: [.log(false), .forceWebsockets(true)])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIStyle()
        
        //計時器，每秒求取API
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in

            //取得資料
            self?.machineOnTimeData ()


            self?.VoltsStr.text = self?.machineData.Volts
            self?.ION.text = self?.machineData.ION
            self?.CWT.text = self?.machineData.CWT
            self?.NO.text = self?.machineData.NO
            self?.IPStr.text = self?.machineData.IP
            self?.OVStr.text = self?.machineData.OV
            self?.ONStr.text = self?.machineData.ON
            self?.OFFStr.text = self?.machineData.OFF
            self?.AONStr.text = self?.machineData.AON
            self?.AOFFStr.text = self?.machineData.AOFF
            self?.SVStr.text = self?.machineData.SV
            self?.WTStr.text = self?.machineData.WT
            self?.WFStr.text = self?.machineData.WF
            self?.WAStr.text = self?.machineData.WA
            self?.FRStr.text = self?.machineData.FR
            self?.FStr.text = self?.machineData.F
            self?.FTStr.text = self?.machineData.FT
            self?.FeedrateStr.text = self?.machineData.Feedrate
            self?.Elapsed.text = self?.machineData.Elapsed
            self?.LeftStr.text = self?.machineData.Left
            self?.TotalLenStr.text = self?.machineData.TotalLen
            self?.CutLenStr.text = self?.machineData.CutLen
            self?.CmpTap.text = self?.machineData.CmpTap
            self?.OffsetStr.text = self?.machineData.Offset
            self?.TangleStr.text = self?.machineData.Tangle
            self?.ProgressStr.text = self?.machineData.Progress
            self?.XcoorStr.text = self?.machineData.Xcoor
            self?.YcoorStr.text = self?.machineData.Ycoor
            self?.ZcoorStr.text = self?.machineData.Zcoor
            self?.receivedAtStr.text = self?.machineData.timestamp
            print("1111111111")


//使用service來求取資料
//            service.shared.fetchData{ (err) in

//                if let EWData = service.datas {
//                    self.machineData = EWData
//                } else {
//                    print("EW API can't getData")
//                    return
//                }
//
//                if let err = err {
//                    print(err)
//                    return
//                }
//            }

        })

        
        

//        print(self.NowMachine)
//
//        print("有接到線割機")
//
//        let socket = manager.defaultSocket
//
//        socket.on(clientEvent: .connect) { (data, _) in
//
//            print("單台：socket connected")
//        }
//
//        socket.on(clientEvent: .error) { (data, eck) in
//            print(data)
//            print("socket error")
//
//        }
//
//        socket.on(clientEvent: .disconnect) { (data, eck) in
//            print(data)
//            print("socket disconnect")
//        }
//
//
//        var SoketStr: String = ""
//
//        if self.NowMachine == "EWA_01" {
//            SoketStr = "WEDM_AccuteX_A01"
//        } else {
//            SoketStr = "WEDM_AccuteX_A02"
//        }
//
//
//        socket.on(SoketStr) { (data, _) in
//
//            print(data)
//            guard let dataInfo = data.first else { return }
//
//            if let response: EWSocketData = try? SocketParser.convert(data: dataInfo) {
//                print(response)
//
//                self.receivedAtStr.text = "\(response.receivedAt)"
//                self.VoltsStr.text = "\(response.Volts)"
//                self.ION.text = "\(response.ION)"
//                self.CWT.text = "\(response.CWT)"
//                self.NO.text = "\(response.NO)"
//                self.IPStr.text = "\(response.IP)"
//                self.OVStr.text = "\(response.OV)"
//                self.ONStr.text = "\(response.ON)"
//                self.OFFStr.text = "\(response.OFF)"
//
//                self.AONStr.text = "\(response.AON)"
//                self.AOFFStr.text = "\(response.AOFF)"
//                self.SVStr.text = "\(response.SV)"
//                self.WTStr.text = "\(response.WT)"
//                self.WFStr.text = "\(response.WF)"
//                self.WAStr.text = "\(response.WA)"
//                self.FRStr.text = "\(response.FR)"
//                self.FStr.text = "\(response.F)"
//                self.FTStr.text = "\(response.FT)"
//
//                self.FeedrateStr.text = "\(response.Feedrate)"
//                self.Elapsed.text = "\(response.Elapsed)"
//                self.LeftStr.text = "\(response.Left)"
//                self.TotalLenStr.text = "\(response.TotalLen)"
//                self.CutLenStr.text = "\(response.CutLen)"
//                self.CmpTap.text = "\(response.CmpTap)"
//                self.OffsetStr.text = "\(response.Offset)"
//                self.TangleStr.text = "\(response.Tangle)"
//                self.ProgressStr.text = "\(response.Progress)"
//
//                self.XcoorStr.text = "\(response.Xcoor)"
//                self.YcoorStr.text = "\(response.Ycoor)"
//                self.ZcoorStr.text = "\(response.Zcoor)"
//            }
//        }
//
//        socket.connect()
    }
    
    
    func UIStyle() {
        parameterView.layer.borderWidth = 1
        information.layer.borderWidth = 1
        coordinateView.layer.borderWidth = 1
        parameterView.layer.borderColor = CGColor(red: 200/234, green: 200/234, blue: 200/234, alpha: 1)
        information.layer.borderColor = CGColor(red: 200/234, green: 200/234, blue: 200/234, alpha: 1)
        coordinateView.layer.borderColor = CGColor(red: 200/234, green: 200/234, blue: 200/234, alpha: 1)
    }
    
    
    func machineOnTimeData (){
        
        var URLStr: String = ""
        
        if self.NowMachine == "EWA_01" {
                    URLStr = "https://elasticsearch.smccycu.cloud/wedm-accutex-31/_search"
                } else {
                    URLStr = "https://elasticsearch.smccycu.cloud/wedm-accutex-30/_search"
                }
        print(URLStr)
        
        let url = URL(string: "https://elasticsearch.smccycu.cloud/wedm-accutex-31/_search")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let user = OnTimePOSTKey(sort: [ sortPOSTKey(timestamp: "desc") ], size: 1)
        let data = try? encoder.encode(user)
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            // print("有收到\(data)")
             if let data = data {

                 do {
                     let decoder = JSONDecoder()
                     let createUserResponse = try decoder.decode(EWOnTimeAPI.self, from: data)
                     //print(createUserResponse)
                     self!.machineData = createUserResponse.hits.hits[0]._source
                     //print("匯入的資料喔喔喔喔：\(self.machineData)")



                 } catch  {
                     print(error)
                 }
             }
         }
        task.resume()
        
        //暫存task
        self.task = task

    }
    
    //如果退回頁面會使放記憶體
    deinit{
        
        //釋放task
        task?.cancel()
        //停止計時器
        timer.invalidate()
        print("EW OS==================")
    }
    


}



//創建class來請求資料(沒用到)
class service {
    static let shared = service()
    
    static var datas:_sourcePOST?
    
    func fetchData(completion: (Error?) -> ()){
        
        let url = URL(string: "https://elasticsearch.smccycu.cloud/wedm-accutex-31/_search")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let user = OnTimePOSTKey(sort: [ sortPOSTKey(timestamp: "desc") ], size: 1)
        let data = try? encoder.encode(user)
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { data, response, error in

           // print("有收到\(data)")
            if let data = data {


                do {
                    let decoder = JSONDecoder()
                    let createUserResponse = try decoder.decode(EWOnTimeAPI.self, from: data)
                    //print(createUserResponse)
                    service.datas = createUserResponse.hits.hits[0]._source
                    //print("匯入的資料喔喔喔喔：\(self.machineData)")

          


                } catch  {
                    print(error)
                }
            }
        }.resume()
        
        completion(nil)
    }
    
}





struct EWSocketData: Codable {
    var Volts: String
    var ION: String
    var CWT: String
    var NO: String
    var IP: String
    var OV: String
    var ON: String
    var OFF: String
    var AON: String
    var AOFF: String
    var SV: String
    var WT: String
    var WF: String
    var WA: String
    var FR: String
    var F: String
    var FT: String
    var SG: String
    var Feedrate: String
    var Elapsed: String
    var Left: String
    var TotalLen: String
    var CutLen: String
    var CmpTap: String
    var Offset: String
    var Ncode: String
    var Tangle: String
    var Progress: String
    var Xcoor: String
    var Ycoor: String
    var Zcoor: String
    var receivedAt: String
}

