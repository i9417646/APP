//
//  SectionEWViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2022/4/21.
//

import UIKit
import SocketIO
import Highcharts

class SectionEWViewController: UIViewController {
    
    //用來預設初始圖表的數據
    var firstData: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    
//EWA01的UI
    @IBOutlet weak var A01Volts: UILabel!
    @IBOutlet weak var A01CWT: UILabel!
    @IBOutlet weak var A01OV: UILabel!
    @IBOutlet weak var A01ON: UILabel!
    @IBOutlet weak var A01OFF: UILabel!
    @IBOutlet weak var A01AON: UILabel!
    @IBOutlet weak var A01AOFF: UILabel!
    @IBOutlet weak var A01WT: UILabel!
    @IBOutlet weak var A01WF: UILabel!
    @IBOutlet weak var A01FR: UILabel!
    @IBOutlet weak var A01F: UILabel!
    @IBOutlet weak var A01Feedrate: UILabel!
    
    @IBOutlet weak var A01VoltsView: UIView!
    @IBOutlet weak var A01CWTView: UIView!
    @IBOutlet weak var A01OVView: UIView!
    @IBOutlet weak var A01ONView: UIView!
    @IBOutlet weak var A01OFFView: UIView!
    @IBOutlet weak var A01AONView: UIView!
    @IBOutlet weak var A01AOFFView: UIView!
    @IBOutlet weak var A01WTView: UIView!
    @IBOutlet weak var A01WFView: UIView!
    @IBOutlet weak var A01FRView: UIView!
    @IBOutlet weak var A01FView: UIView!
    @IBOutlet weak var A01FeedrateView: UIView!
    
    
    
    
//EWA02的UI
    @IBOutlet weak var A02Volts: UILabel!
    @IBOutlet weak var A02CWT: UILabel!
    @IBOutlet weak var A02OV: UILabel!
    @IBOutlet weak var A02ON: UILabel!
    @IBOutlet weak var A02OFF: UILabel!
    @IBOutlet weak var A02AON: UILabel!
    @IBOutlet weak var A02AOFF: UILabel!
    @IBOutlet weak var A02WT: UILabel!
    @IBOutlet weak var A02WF: UILabel!
    @IBOutlet weak var A02FR: UILabel!
    @IBOutlet weak var A02F: UILabel!
    @IBOutlet weak var A02Feedrate: UILabel!
    
    @IBOutlet weak var A02VoltsView: UIView!
    @IBOutlet weak var A02CWTView: UIView!
    @IBOutlet weak var A02OVView: UIView!
    @IBOutlet weak var A02ONView: UIView!
    @IBOutlet weak var A02OFFView: UIView!
    @IBOutlet weak var A02AONView: UIView!
    @IBOutlet weak var A02AOFFView: UIView!
    @IBOutlet weak var A02WTView: UIView!
    @IBOutlet weak var A02WFView: UIView!
    @IBOutlet weak var A02FRView: UIView!
    @IBOutlet weak var A02FView: UIView!
    @IBOutlet weak var A02FeedrateView: UIView!
    
 //socket
    let manager = SocketManager(socketURL: URL(string: "http://140.135.97.69:8787")!, config: [.log(false), .forceWebsockets(true)])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//MARK: -EWA01圖
        
    //間隙電壓
        let A01VoltsOptions = viewOptions()

        let A01Voltsseries = HISeries()
        A01Voltsseries.data = self.firstData
        A01Voltsseries.marker  = HIMarker()
        A01Voltsseries.marker.enabled = false
        A01Voltsseries.marker.radius = 2.6
        A01Voltsseries.lineWidth = 2
        A01Voltsseries.color = HIColor(hexValue: "6b79e4")

        A01VoltsOptions.series = [A01Voltsseries]
        
        let A01VoltschartView = HIChartView(frame: view.bounds)
        
        A01VoltschartView.options = A01VoltsOptions
       
        A01VoltschartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A01VoltsView.addSubview(A01VoltschartView)
        A01VoltschartView.leadingAnchor.constraint(equalTo: A01VoltsView.leadingAnchor, constant: 0).isActive = true
        A01VoltschartView.topAnchor.constraint(equalTo: A01VoltsView.topAnchor, constant: 0).isActive = true
        A01VoltschartView.trailingAnchor.constraint(equalTo: A01VoltsView.trailingAnchor, constant: 0).isActive = true
        A01VoltschartView.bottomAnchor.constraint(equalTo: A01VoltsView.bottomAnchor, constant: 0).isActive = true
        
        
    //間隙電壓
        let A01CWTOptions = viewOptions()

        let A01CWTseries = HISeries()
        A01CWTseries.data = self.firstData
        A01CWTseries.marker  = HIMarker()
        A01CWTseries.marker.enabled = false
        A01CWTseries.marker.radius = 2.6
        A01CWTseries.lineWidth = 2
        A01CWTseries.color = HIColor(hexValue: "6b79e4")

        A01CWTOptions.series = [A01CWTseries]
        
        let A01CWTchartView = HIChartView(frame: view.bounds)
        
        A01CWTchartView.options = A01CWTOptions
       
        A01CWTchartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A01CWTView.addSubview(A01CWTchartView)
        A01CWTchartView.leadingAnchor.constraint(equalTo: A01CWTView.leadingAnchor, constant: 0).isActive = true
        A01CWTchartView.topAnchor.constraint(equalTo: A01CWTView.topAnchor, constant: 0).isActive = true
        A01CWTchartView.trailingAnchor.constraint(equalTo: A01CWTView.trailingAnchor, constant: 0).isActive = true
        A01CWTchartView.bottomAnchor.constraint(equalTo: A01CWTView.bottomAnchor, constant: 0).isActive = true
        
    //加工電壓
        let A01OVOptions = viewOptions()

        let A01OVseries = HISeries()
        A01OVseries.data = self.firstData
        A01OVseries.marker  = HIMarker()
        A01OVseries.marker.enabled = false
        A01OVseries.marker.radius = 2.6
        A01OVseries.lineWidth = 2
        A01OVseries.color = HIColor(hexValue: "6b79e4")

        A01OVOptions.series = [A01OVseries]
        
        let A01OVchartView = HIChartView(frame: view.bounds)
        
        A01OVchartView.options = A01OVOptions
       
        A01OVchartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A01OVView.addSubview(A01OVchartView)
        A01OVchartView.leadingAnchor.constraint(equalTo: A01OVView.leadingAnchor, constant: 0).isActive = true
        A01OVchartView.topAnchor.constraint(equalTo: A01OVView.topAnchor, constant: 0).isActive = true
        A01OVchartView.trailingAnchor.constraint(equalTo: A01OVView.trailingAnchor, constant: 0).isActive = true
        A01OVchartView.bottomAnchor.constraint(equalTo: A01OVView.bottomAnchor, constant: 0).isActive = true
        
        
    //放電時間
        let A01ONOptions = viewOptions()

        let A01ONseries = HISeries()
        A01ONseries.data = self.firstData
        A01ONseries.marker  = HIMarker()
        A01ONseries.marker.enabled = false
        A01ONseries.marker.radius = 2.6
        A01ONseries.lineWidth = 2
        A01ONseries.color = HIColor(hexValue: "6b79e4")

        A01ONOptions.series = [A01ONseries]
        
        let A01ONchartView = HIChartView(frame: view.bounds)
        
        A01ONchartView.options = A01ONOptions
       
        A01ONchartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A01ONView.addSubview(A01ONchartView)
        A01ONchartView.leadingAnchor.constraint(equalTo: A01ONView.leadingAnchor, constant: 0).isActive = true
        A01ONchartView.topAnchor.constraint(equalTo: A01ONView.topAnchor, constant: 0).isActive = true
        A01ONchartView.trailingAnchor.constraint(equalTo: A01ONView.trailingAnchor, constant: 0).isActive = true
        A01ONchartView.bottomAnchor.constraint(equalTo: A01ONView.bottomAnchor, constant: 0).isActive = true
            
        
    //休止時間
        let A01OFFOptions = viewOptions()

        let A01OFFseries = HISeries()
        A01OFFseries.data = self.firstData
        A01OFFseries.marker  = HIMarker()
        A01OFFseries.marker.enabled = false
        A01OFFseries.marker.radius = 2.6
        A01OFFseries.lineWidth = 2
        A01OFFseries.color = HIColor(hexValue: "6b79e4")

        A01OFFOptions.series = [A01OFFseries]
        
        let A01OFFchartView = HIChartView(frame: view.bounds)
        
        A01OFFchartView.options = A01OFFOptions
       
        A01OFFchartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A01OFFView.addSubview(A01OFFchartView)
        A01OFFchartView.leadingAnchor.constraint(equalTo: A01OFFView.leadingAnchor, constant: 0).isActive = true
        A01OFFchartView.topAnchor.constraint(equalTo: A01OFFView.topAnchor, constant: 0).isActive = true
        A01OFFchartView.trailingAnchor.constraint(equalTo: A01OFFView.trailingAnchor, constant: 0).isActive = true
        A01OFFchartView.bottomAnchor.constraint(equalTo: A01OFFView.bottomAnchor, constant: 0).isActive = true
        
        
        
        
    //短路放電時間
        let A01AONOptions = viewOptions()

        let A01AONseries = HISeries()
        A01AONseries.data = self.firstData
        A01AONseries.marker  = HIMarker()
        A01AONseries.marker.enabled = false
        A01AONseries.marker.radius = 2.6
        A01AONseries.lineWidth = 2
        A01AONseries.color = HIColor(hexValue: "6b79e4")

        A01AONOptions.series = [A01AONseries]
        
        let A01AONchartView = HIChartView(frame: view.bounds)
        
        A01AONchartView.options = A01AONOptions
       
        A01AONchartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A01AONView.addSubview(A01AONchartView)
        A01AONchartView.leadingAnchor.constraint(equalTo: A01AONView.leadingAnchor, constant: 0).isActive = true
        A01AONchartView.topAnchor.constraint(equalTo: A01AONView.topAnchor, constant: 0).isActive = true
        A01AONchartView.trailingAnchor.constraint(equalTo: A01AONView.trailingAnchor, constant: 0).isActive = true
        A01AONchartView.bottomAnchor.constraint(equalTo: A01AONView.bottomAnchor, constant: 0).isActive = true
        
        
    //短路休止時間
        let A01AOFFOptions = viewOptions()

        let A01AOFFseries = HISeries()
        A01AOFFseries.data = self.firstData
        A01AOFFseries.marker  = HIMarker()
        A01AOFFseries.marker.enabled = false
        A01AOFFseries.marker.radius = 2.6
        A01AOFFseries.lineWidth = 2
        A01AOFFseries.color = HIColor(hexValue: "6b79e4")

        A01AOFFOptions.series = [A01AOFFseries]
        
        let A01AOFFchartView = HIChartView(frame: view.bounds)
        
        A01AOFFchartView.options = A01AOFFOptions
       
        A01AOFFchartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A01AOFFView.addSubview(A01AOFFchartView)
        A01AOFFchartView.leadingAnchor.constraint(equalTo: A01AOFFView.leadingAnchor, constant: 0).isActive = true
        A01AOFFchartView.topAnchor.constraint(equalTo: A01AOFFView.topAnchor, constant: 0).isActive = true
        A01AOFFchartView.trailingAnchor.constraint(equalTo: A01AOFFView.trailingAnchor, constant: 0).isActive = true
        A01AOFFchartView.bottomAnchor.constraint(equalTo: A01AOFFView.bottomAnchor, constant: 0).isActive = true
        
        
        
    //短路線張力
        let A01WTOptions = viewOptions()

        let A01WTseries = HISeries()
        A01WTseries.data = self.firstData
        A01WTseries.marker  = HIMarker()
        A01WTseries.marker.enabled = false
        A01WTseries.marker.radius = 2.6
        A01WTseries.lineWidth = 2
        A01WTseries.color = HIColor(hexValue: "6b79e4")

        A01WTOptions.series = [A01WTseries]
        
        let A01WTchartView = HIChartView(frame: view.bounds)
        
        A01WTchartView.options = A01WTOptions
       
        A01WTchartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A01WTView.addSubview(A01WTchartView)
        A01WTchartView.leadingAnchor.constraint(equalTo: A01WTView.leadingAnchor, constant: 0).isActive = true
        A01WTchartView.topAnchor.constraint(equalTo: A01WTView.topAnchor, constant: 0).isActive = true
        A01WTchartView.trailingAnchor.constraint(equalTo: A01WTView.trailingAnchor, constant: 0).isActive = true
        A01WTchartView.bottomAnchor.constraint(equalTo: A01WTView.bottomAnchor, constant: 0).isActive = true
        
        
       
        
        
    //短路線進給
        let A01WFOptions = viewOptions()

        let A01WFseries = HISeries()
        A01WFseries.data = self.firstData
        A01WFseries.marker  = HIMarker()
        A01WFseries.marker.enabled = false
        A01WFseries.marker.radius = 2.6
        A01WFseries.lineWidth = 2
        A01WFseries.color = HIColor(hexValue: "6b79e4")

        A01WFOptions.series = [A01WFseries]
        
        let A01WFchartView = HIChartView(frame: view.bounds)
        
        A01WFchartView.options = A01WFOptions
       
        A01WFchartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A01WFView.addSubview(A01WFchartView)
        A01WFchartView.leadingAnchor.constraint(equalTo: A01WFView.leadingAnchor, constant: 0).isActive = true
        A01WFchartView.topAnchor.constraint(equalTo: A01WFView.topAnchor, constant: 0).isActive = true
        A01WFchartView.trailingAnchor.constraint(equalTo: A01WFView.trailingAnchor, constant: 0).isActive = true
        A01WFchartView.bottomAnchor.constraint(equalTo: A01WFView.bottomAnchor, constant: 0).isActive = true
            
        
        
    //短路進給倍率
        let A01FROptions = viewOptions()

        let A01FRseries = HISeries()
        A01FRseries.data = self.firstData
        A01FRseries.marker  = HIMarker()
        A01FRseries.marker.enabled = false
        A01FRseries.marker.radius = 2.6
        A01FRseries.lineWidth = 2
        A01FRseries.color = HIColor(hexValue: "6b79e4")

        A01FROptions.series = [A01FRseries]
        
        let A01FRchartView = HIChartView(frame: view.bounds)
        
        A01FRchartView.options = A01FROptions
       
        A01FRchartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A01FRView.addSubview(A01FRchartView)
        A01FRchartView.leadingAnchor.constraint(equalTo: A01FRView.leadingAnchor, constant: 0).isActive = true
        A01FRchartView.topAnchor.constraint(equalTo: A01FRView.topAnchor, constant: 0).isActive = true
        A01FRchartView.trailingAnchor.constraint(equalTo: A01FRView.trailingAnchor, constant: 0).isActive = true
        A01FRchartView.bottomAnchor.constraint(equalTo: A01FRView.bottomAnchor, constant: 0).isActive = true
                
        
    //短路進給速度
        let A01FOptions = viewOptions()

        let A01Fseries = HISeries()
        A01Fseries.data = self.firstData
        A01Fseries.marker  = HIMarker()
        A01Fseries.marker.enabled = false
        A01Fseries.marker.radius = 2.6
        A01Fseries.lineWidth = 2
        A01Fseries.color = HIColor(hexValue: "6b79e4")

        A01FOptions.series = [A01Fseries]
        
        let A01FchartView = HIChartView(frame: view.bounds)
        
        A01FchartView.options = A01FOptions
       
        A01FchartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A01FView.addSubview(A01FchartView)
        A01FchartView.leadingAnchor.constraint(equalTo: A01FView.leadingAnchor, constant: 0).isActive = true
        A01FchartView.topAnchor.constraint(equalTo: A01FView.topAnchor, constant: 0).isActive = true
        A01FchartView.trailingAnchor.constraint(equalTo: A01FView.trailingAnchor, constant: 0).isActive = true
        A01FchartView.bottomAnchor.constraint(equalTo: A01FView.bottomAnchor, constant: 0).isActive = true
        
        
    //短路切削進給速度
        let A01FeedrateOptions = viewOptions()

        let A01Feedrateseries = HISeries()
        A01Feedrateseries.data = self.firstData
        A01Feedrateseries.marker  = HIMarker()
        A01Feedrateseries.marker.enabled = false
        A01Feedrateseries.marker.radius = 2.6
        A01Feedrateseries.lineWidth = 2
        A01Feedrateseries.color = HIColor(hexValue: "6b79e4")

        A01FeedrateOptions.series = [A01Feedrateseries]
        
        let A01FeedratechartView = HIChartView(frame: view.bounds)
        
        A01FeedratechartView.options = A01FeedrateOptions
       
        A01FeedratechartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A01FeedrateView.addSubview(A01FeedratechartView)
        A01FeedratechartView.leadingAnchor.constraint(equalTo: A01FeedrateView.leadingAnchor, constant: 0).isActive = true
        A01FeedratechartView.topAnchor.constraint(equalTo: A01FeedrateView.topAnchor, constant: 0).isActive = true
        A01FeedratechartView.trailingAnchor.constraint(equalTo: A01FeedrateView.trailingAnchor, constant: 0).isActive = true
        A01FeedratechartView.bottomAnchor.constraint(equalTo: A01FeedrateView.bottomAnchor, constant: 0).isActive = true
        
        
        
        
        
        
        
        
        
        
//MARK: -EWA02圖
        
        
        
        
    //間隙電壓
        let A02VoltsOptions = viewOptions()

        let A02Voltsseries = HISeries()
        A02Voltsseries.data = self.firstData
        A02Voltsseries.marker  = HIMarker()
        A02Voltsseries.marker.enabled = false
        A02Voltsseries.marker.radius = 2.6
        A02Voltsseries.lineWidth = 2
        A02Voltsseries.color = HIColor(hexValue: "6b79e4")

        A02VoltsOptions.series = [A02Voltsseries]
        
        let A02VoltschartView = HIChartView(frame: view.bounds)
        
        A02VoltschartView.options = A02VoltsOptions
       
        A02VoltschartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A02VoltsView.addSubview(A02VoltschartView)
        A02VoltschartView.leadingAnchor.constraint(equalTo: A02VoltsView.leadingAnchor, constant: 0).isActive = true
        A02VoltschartView.topAnchor.constraint(equalTo: A02VoltsView.topAnchor, constant: 0).isActive = true
        A02VoltschartView.trailingAnchor.constraint(equalTo: A02VoltsView.trailingAnchor, constant: 0).isActive = true
        A02VoltschartView.bottomAnchor.constraint(equalTo: A02VoltsView.bottomAnchor, constant: 0).isActive = true
        
        
    //間隙電壓
        let A02CWTOptions = viewOptions()

        let A02CWTseries = HISeries()
        A02CWTseries.data = self.firstData
        A02CWTseries.marker  = HIMarker()
        A02CWTseries.marker.enabled = false
        A02CWTseries.marker.radius = 2.6
        A02CWTseries.lineWidth = 2
        A02CWTseries.color = HIColor(hexValue: "6b79e4")

        A02CWTOptions.series = [A02CWTseries]
        
        let A02CWTchartView = HIChartView(frame: view.bounds)
        
        A02CWTchartView.options = A02CWTOptions
       
        A02CWTchartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A02CWTView.addSubview(A02CWTchartView)
        A02CWTchartView.leadingAnchor.constraint(equalTo: A02CWTView.leadingAnchor, constant: 0).isActive = true
        A02CWTchartView.topAnchor.constraint(equalTo: A02CWTView.topAnchor, constant: 0).isActive = true
        A02CWTchartView.trailingAnchor.constraint(equalTo: A02CWTView.trailingAnchor, constant: 0).isActive = true
        A02CWTchartView.bottomAnchor.constraint(equalTo: A02CWTView.bottomAnchor, constant: 0).isActive = true
        
    //加工電壓
        let A02OVOptions = viewOptions()

        let A02OVseries = HISeries()
        A02OVseries.data = self.firstData
        A02OVseries.marker  = HIMarker()
        A02OVseries.marker.enabled = false
        A02OVseries.marker.radius = 2.6
        A02OVseries.lineWidth = 2
        A02OVseries.color = HIColor(hexValue: "6b79e4")

        A02OVOptions.series = [A02OVseries]
        
        let A02OVchartView = HIChartView(frame: view.bounds)
        
        A02OVchartView.options = A02OVOptions
       
        A02OVchartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A02OVView.addSubview(A02OVchartView)
        A02OVchartView.leadingAnchor.constraint(equalTo: A02OVView.leadingAnchor, constant: 0).isActive = true
        A02OVchartView.topAnchor.constraint(equalTo: A02OVView.topAnchor, constant: 0).isActive = true
        A02OVchartView.trailingAnchor.constraint(equalTo: A02OVView.trailingAnchor, constant: 0).isActive = true
        A02OVchartView.bottomAnchor.constraint(equalTo: A02OVView.bottomAnchor, constant: 0).isActive = true
        
        
        
        
    //放電時間
        let A02ONOptions = viewOptions()

        let A02ONseries = HISeries()
        A02ONseries.data = self.firstData
        A02ONseries.marker  = HIMarker()
        A02ONseries.marker.enabled = false
        A02ONseries.marker.radius = 2.6
        A02ONseries.lineWidth = 2
        A02ONseries.color = HIColor(hexValue: "6b79e4")

        A02ONOptions.series = [A02ONseries]
        
        let A02ONchartView = HIChartView(frame: view.bounds)
        
        A02ONchartView.options = A02ONOptions
       
        A02ONchartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A02ONView.addSubview(A02ONchartView)
        A02ONchartView.leadingAnchor.constraint(equalTo: A02ONView.leadingAnchor, constant: 0).isActive = true
        A02ONchartView.topAnchor.constraint(equalTo: A02ONView.topAnchor, constant: 0).isActive = true
        A02ONchartView.trailingAnchor.constraint(equalTo: A02ONView.trailingAnchor, constant: 0).isActive = true
        A02ONchartView.bottomAnchor.constraint(equalTo: A02ONView.bottomAnchor, constant: 0).isActive = true
            
        
    //休止時間
        let A02OFFOptions = viewOptions()

        let A02OFFseries = HISeries()
        A02OFFseries.data = self.firstData
        A02OFFseries.marker  = HIMarker()
        A02OFFseries.marker.enabled = false
        A02OFFseries.marker.radius = 2.6
        A02OFFseries.lineWidth = 2
        A02OFFseries.color = HIColor(hexValue: "6b79e4")

        A02OFFOptions.series = [A02OFFseries]
        
        let A02OFFchartView = HIChartView(frame: view.bounds)
        
        A02OFFchartView.options = A02OFFOptions
       
        A02OFFchartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A02OFFView.addSubview(A02OFFchartView)
        A02OFFchartView.leadingAnchor.constraint(equalTo: A02OFFView.leadingAnchor, constant: 0).isActive = true
        A02OFFchartView.topAnchor.constraint(equalTo: A02OFFView.topAnchor, constant: 0).isActive = true
        A02OFFchartView.trailingAnchor.constraint(equalTo: A02OFFView.trailingAnchor, constant: 0).isActive = true
        A02OFFchartView.bottomAnchor.constraint(equalTo: A02OFFView.bottomAnchor, constant: 0).isActive = true
        
        
        
        
    //短路放電時間
        let A02AONOptions = viewOptions()

        let A02AONseries = HISeries()
        A02AONseries.data = self.firstData
        A02AONseries.marker  = HIMarker()
        A02AONseries.marker.enabled = false
        A02AONseries.marker.radius = 2.6
        A02AONseries.lineWidth = 2
        A02AONseries.color = HIColor(hexValue: "6b79e4")

        A02AONOptions.series = [A02AONseries]
        
        let A02AONchartView = HIChartView(frame: view.bounds)
        
        A02AONchartView.options = A02AONOptions
       
        A02AONchartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A02AONView.addSubview(A02AONchartView)
        A02AONchartView.leadingAnchor.constraint(equalTo: A02AONView.leadingAnchor, constant: 0).isActive = true
        A02AONchartView.topAnchor.constraint(equalTo: A02AONView.topAnchor, constant: 0).isActive = true
        A02AONchartView.trailingAnchor.constraint(equalTo: A02AONView.trailingAnchor, constant: 0).isActive = true
        A02AONchartView.bottomAnchor.constraint(equalTo: A02AONView.bottomAnchor, constant: 0).isActive = true
        
        
        
        
    //短路休止時間
        let A02AOFFOptions = viewOptions()

        let A02AOFFseries = HISeries()
        A02AOFFseries.data = self.firstData
        A02AOFFseries.marker  = HIMarker()
        A02AOFFseries.marker.enabled = false
        A02AOFFseries.marker.radius = 2.6
        A02AOFFseries.lineWidth = 2
        A02AOFFseries.color = HIColor(hexValue: "6b79e4")

        A02AOFFOptions.series = [A02AOFFseries]
        
        let A02AOFFchartView = HIChartView(frame: view.bounds)
        
        A02AOFFchartView.options = A02AOFFOptions
       
        A02AOFFchartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A02AOFFView.addSubview(A02AOFFchartView)
        A02AOFFchartView.leadingAnchor.constraint(equalTo: A02AOFFView.leadingAnchor, constant: 0).isActive = true
        A02AOFFchartView.topAnchor.constraint(equalTo: A02AOFFView.topAnchor, constant: 0).isActive = true
        A02AOFFchartView.trailingAnchor.constraint(equalTo: A02AOFFView.trailingAnchor, constant: 0).isActive = true
        A02AOFFchartView.bottomAnchor.constraint(equalTo: A02AOFFView.bottomAnchor, constant: 0).isActive = true
        
        
        
    //短路線張力
        let A02WTOptions = viewOptions()

        let A02WTseries = HISeries()
        A02WTseries.data = self.firstData
        A02WTseries.marker  = HIMarker()
        A02WTseries.marker.enabled = false
        A02WTseries.marker.radius = 2.6
        A02WTseries.lineWidth = 2
        A02WTseries.color = HIColor(hexValue: "6b79e4")

        A02WTOptions.series = [A02WTseries]
        
        let A02WTchartView = HIChartView(frame: view.bounds)
        
        A02WTchartView.options = A02WTOptions
       
        A02WTchartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A02WTView.addSubview(A02WTchartView)
        A02WTchartView.leadingAnchor.constraint(equalTo: A02WTView.leadingAnchor, constant: 0).isActive = true
        A02WTchartView.topAnchor.constraint(equalTo: A02WTView.topAnchor, constant: 0).isActive = true
        A02WTchartView.trailingAnchor.constraint(equalTo: A02WTView.trailingAnchor, constant: 0).isActive = true
        A02WTchartView.bottomAnchor.constraint(equalTo: A02WTView.bottomAnchor, constant: 0).isActive = true
        
        
       
        
        
    //短路線進給
        let A02WFOptions = viewOptions()

        let A02WFseries = HISeries()
        A02WFseries.data = self.firstData
        A02WFseries.marker  = HIMarker()
        A02WFseries.marker.enabled = false
        A02WFseries.marker.radius = 2.6
        A02WFseries.lineWidth = 2
        A02WFseries.color = HIColor(hexValue: "6b79e4")

        A02WFOptions.series = [A02WFseries]
        
        let A02WFchartView = HIChartView(frame: view.bounds)
        
        A02WFchartView.options = A02WFOptions
       
        A02WFchartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A02WFView.addSubview(A02WFchartView)
        A02WFchartView.leadingAnchor.constraint(equalTo: A02WFView.leadingAnchor, constant: 0).isActive = true
        A02WFchartView.topAnchor.constraint(equalTo: A02WFView.topAnchor, constant: 0).isActive = true
        A02WFchartView.trailingAnchor.constraint(equalTo: A02WFView.trailingAnchor, constant: 0).isActive = true
        A02WFchartView.bottomAnchor.constraint(equalTo: A02WFView.bottomAnchor, constant: 0).isActive = true
        
        
        
        
        
        
    //短路進給倍率
        let A02FROptions = viewOptions()

        let A02FRseries = HISeries()
        A02FRseries.data = self.firstData
        A02FRseries.marker  = HIMarker()
        A02FRseries.marker.enabled = false
        A02FRseries.marker.radius = 2.6
        A02FRseries.lineWidth = 2
        A02FRseries.color = HIColor(hexValue: "6b79e4")

        A02FROptions.series = [A02FRseries]
        
        let A02FRchartView = HIChartView(frame: view.bounds)
        
        A02FRchartView.options = A02FROptions
       
        A02FRchartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A02FRView.addSubview(A02FRchartView)
        A02FRchartView.leadingAnchor.constraint(equalTo: A02FRView.leadingAnchor, constant: 0).isActive = true
        A02FRchartView.topAnchor.constraint(equalTo: A02FRView.topAnchor, constant: 0).isActive = true
        A02FRchartView.trailingAnchor.constraint(equalTo: A02FRView.trailingAnchor, constant: 0).isActive = true
        A02FRchartView.bottomAnchor.constraint(equalTo: A02FRView.bottomAnchor, constant: 0).isActive = true
                
        
    //短路進給速度
        let A02FOptions = viewOptions()

        let A02Fseries = HISeries()
        A02Fseries.data = self.firstData
        A02Fseries.marker  = HIMarker()
        A02Fseries.marker.enabled = false
        A02Fseries.marker.radius = 2.6
        A02Fseries.lineWidth = 2
        A02Fseries.color = HIColor(hexValue: "6b79e4")

        A02FOptions.series = [A02Fseries]
        
        let A02FchartView = HIChartView(frame: view.bounds)
        
        A02FchartView.options = A02FOptions
       
        A02FchartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A02FView.addSubview(A02FchartView)
        A02FchartView.leadingAnchor.constraint(equalTo: A02FView.leadingAnchor, constant: 0).isActive = true
        A02FchartView.topAnchor.constraint(equalTo: A02FView.topAnchor, constant: 0).isActive = true
        A02FchartView.trailingAnchor.constraint(equalTo: A02FView.trailingAnchor, constant: 0).isActive = true
        A02FchartView.bottomAnchor.constraint(equalTo: A02FView.bottomAnchor, constant: 0).isActive = true
        
        
    //短路切削進給速度
        let A02FeedrateOptions = viewOptions()

        let A02Feedrateseries = HISeries()
        A02Feedrateseries.data = self.firstData
        A02Feedrateseries.marker  = HIMarker()
        A02Feedrateseries.marker.enabled = false
        A02Feedrateseries.marker.radius = 2.6
        A02Feedrateseries.lineWidth = 2
        A02Feedrateseries.color = HIColor(hexValue: "6b79e4")

        A02FeedrateOptions.series = [A02Feedrateseries]
        
        let A02FeedratechartView = HIChartView(frame: view.bounds)
        
        A02FeedratechartView.options = A02FeedrateOptions
       
        A02FeedratechartView.translatesAutoresizingMaskIntoConstraints = false

        
        self.A02FeedrateView.addSubview(A02FeedratechartView)
        A02FeedratechartView.leadingAnchor.constraint(equalTo: A02FeedrateView.leadingAnchor, constant: 0).isActive = true
        A02FeedratechartView.topAnchor.constraint(equalTo: A02FeedrateView.topAnchor, constant: 0).isActive = true
        A02FeedratechartView.trailingAnchor.constraint(equalTo: A02FeedrateView.trailingAnchor, constant: 0).isActive = true
        A02FeedratechartView.bottomAnchor.constraint(equalTo: A02FeedrateView.bottomAnchor, constant: 0).isActive = true
        
//MARK: -EWA01Socket
        
        let socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { (data, _) in
            
            print("socket connected")
        }
        
        socket.on(clientEvent: .error) { (data, eck) in
            print(data)
            print("socket error")
            
        }
        
        socket.on(clientEvent: .disconnect) { (data, eck) in
            print(data)
            print("socket disconnect")
        }
        
        socket.on("WEDM_AccuteX_A01") { (data, _) in
            
           // print(data)
            guard let dataInfo = data.first else { return }
            
            if let response: EWSocketData = try? SocketParser.convert(data: dataInfo) {
              //  print(response)
                
                self.A01Volts.text = "\(response.Volts)"
                self.A01CWT.text = "\(response.CWT)"
                self.A01OV.text = "\(response.OV)"
                self.A01ON.text = "\(response.ON)"
                self.A01OFF.text = "\(response.OFF)"
                self.A01AON.text = "\(response.AON)"
                self.A01AOFF.text = "\(response.AOFF)"
                self.A01WT.text = "\(response.WT)"
                self.A01WF.text = "\(response.WF)"
                self.A01FR.text = "\(response.FR)"
                self.A01F.text = "\(response.F)"
                self.A01Feedrate.text = "\(response.Feedrate)"
                
                
            //新增間隙電壓
                let A01VoltsNewData = HIData()
                A01VoltsNewData.y = NSNumber(value: Float(response.Volts) ?? 0)
                A01Voltsseries.addPoint(A01VoltsNewData)
                A01Voltsseries.removePoint(0)
                
                
            //新增線張力
                let A01CWTNewData = HIData()
                A01CWTNewData.y = NSNumber(value: Float(response.CWT) ?? 0)
                A01CWTseries.addPoint(A01CWTNewData)
                A01CWTseries.removePoint(0)
                
            //新增加工電壓
                let A01OVNewData = HIData()
                A01OVNewData.y = NSNumber(value: Float(response.OV) ?? 0)
                A01OVseries.addPoint(A01OVNewData)
                A01OVseries.removePoint(0)
                
            //新增加工電壓
                let A01ONNewData = HIData()
                A01ONNewData.y = NSNumber(value: Float(response.ON) ?? 0)
                A01ONseries.addPoint(A01ONNewData)
                A01ONseries.removePoint(0)
                
            //新增休止電壓
                let A01OFFNewData = HIData()
                A01OFFNewData.y = NSNumber(value: Float(response.OFF) ?? 0)
                A01OFFseries.addPoint(A01OFFNewData)
                A01OFFseries.removePoint(0)
                
            //新增短路放電放電
                let A01AONNewData = HIData()
                A01AONNewData.y = NSNumber(value: Float(response.AON) ?? 0)
                A01AONseries.addPoint(A01AONNewData)
                A01AONseries.removePoint(0)
                
                
            //新增短路休止放電
                let A01AOFFNewData = HIData()
                A01AOFFNewData.y = NSNumber(value: Float(response.AOFF) ?? 0)
                A01AOFFseries.addPoint(A01AOFFNewData)
                A01AOFFseries.removePoint(0)
                
            //新增線張力
                let A01WTNewData = HIData()
                A01WTNewData.y = NSNumber(value: Float(response.WT) ?? 0)
                A01WTseries.addPoint(A01WTNewData)
                A01WTseries.removePoint(0)
                
                
            //新增線近幾
                let A01WFNewData = HIData()
                A01WFNewData.y = NSNumber(value: Float(response.WF) ?? 0)
                A01WFseries.addPoint(A01WFNewData)
                A01WFseries.removePoint(0)
                
                
            //新增線近幾倍率
                let A01FRNewData = HIData()
                A01FRNewData.y = NSNumber(value: Float(response.FR) ?? 0)
                A01FRseries.addPoint(A01FRNewData)
                A01FRseries.removePoint(0)
                
            //新增線近幾速度
                let A01FNewData = HIData()
                A01FNewData.y = NSNumber(value: Float(response.F) ?? 0)
                A01Fseries.addPoint(A01FNewData)
                A01Fseries.removePoint(0)
                
                
                
            //新增切削近幾速度
                let A01FeedrateNewData = HIData()
                A01FeedrateNewData.y = NSNumber(value: Float(response.Feedrate) ?? 0)
                A01Feedrateseries.addPoint(A01FeedrateNewData)
                A01Feedrateseries.removePoint(0)
                
            }
            
            
            
            socket.on("WEDM_AccuteX_A02") { (data, _) in
                // print(data)
                 guard let dataInfo = data.first else { return }
                 
                 if let response: EWSocketData = try? SocketParser.convert(data: dataInfo) {
                //     print("第二台\(response)")
                    self.A02Volts.text = "\(response.Volts)"
                    self.A02CWT.text = "\(response.CWT)"
                    self.A02OV.text = "\(response.OV)"
                    self.A02ON.text = "\(response.ON)"
                    self.A02OFF.text = "\(response.OFF)"
                    self.A02AON.text = "\(response.AON)"
                    self.A02AOFF.text = "\(response.AOFF)"
                    self.A02WT.text = "\(response.WT)"
                    self.A02WF.text = "\(response.WF)"
                    self.A02FR.text = "\(response.FR)"
                    self.A02F.text = "\(response.F)"
                    self.A02Feedrate.text = "\(response.Feedrate)"
                    
                    
                //新增間隙電壓
                    let A02VoltsNewData = HIData()
                    A02VoltsNewData.y = NSNumber(value: Float(response.Volts) ?? 0)
                    A02Voltsseries.addPoint(A02VoltsNewData)
                    A02Voltsseries.removePoint(0)
                    
                    
                //新增線張力
                    let A02CWTNewData = HIData()
                    A02CWTNewData.y = NSNumber(value: Float(response.CWT) ?? 0)
                    A02CWTseries.addPoint(A02CWTNewData)
                    A02CWTseries.removePoint(0)
                    
                //新增加工電壓
                    let A02OVNewData = HIData()
                    A02OVNewData.y = NSNumber(value: Float(response.OV) ?? 0)
                    A02OVseries.addPoint(A02OVNewData)
                    A02OVseries.removePoint(0)
                    
                
                //新增加工電壓
                    let A02ONNewData = HIData()
                    A02ONNewData.y = NSNumber(value: Float(response.ON) ?? 0)
                    A02ONseries.addPoint(A02ONNewData)
                    A02ONseries.removePoint(0)
                    
                //新增休止電壓
                    let A02OFFNewData = HIData()
                    A02OFFNewData.y = NSNumber(value: Float(response.OFF) ?? 0)
                    A02OFFseries.addPoint(A02OFFNewData)
                    A02OFFseries.removePoint(0)
                    
                //新增短路放電放電
                    let A02AONNewData = HIData()
                    A02AONNewData.y = NSNumber(value: Float(response.AON) ?? 0)
                    A02AONseries.addPoint(A02AONNewData)
                    A02AONseries.removePoint(0)
                    
                    
                //新增短路休止放電
                    let A02AOFFNewData = HIData()
                    A02AOFFNewData.y = NSNumber(value: Float(response.AOFF) ?? 0)
                    A02AOFFseries.addPoint(A02AOFFNewData)
                    A02AOFFseries.removePoint(0)
                    
                //新增線張力
                    let A02WTNewData = HIData()
                    A02WTNewData.y = NSNumber(value: Float(response.WT) ?? 0)
                    A02WTseries.addPoint(A02WTNewData)
                    A02WTseries.removePoint(0)
                    
                    
                //新增線近幾
                    let A02WFNewData = HIData()
                    A02WFNewData.y = NSNumber(value: Float(response.WF) ?? 0)
                    A02WFseries.addPoint(A02WFNewData)
                    A02WFseries.removePoint(0)
                    
                //新增線近幾倍率
                    let A02FRNewData = HIData()
                    A02FRNewData.y = NSNumber(value: Float(response.FR) ?? 0)
                    A02FRseries.addPoint(A02FRNewData)
                    A02FRseries.removePoint(0)
                    
                //新增線近幾速度
                    let A02FNewData = HIData()
                    A02FNewData.y = NSNumber(value: Float(response.F) ?? 0)
                    A02Fseries.addPoint(A02FNewData)
                    A02Fseries.removePoint(0)
                    
                    
                    
                //新增切削近幾速度
                    let A02FeedrateNewData = HIData()
                    A02FeedrateNewData.y = NSNumber(value: Float(response.Feedrate) ?? 0)
                    A02Feedrateseries.addPoint(A02FeedrateNewData)
                    A02Feedrateseries.removePoint(0)
                        
                 }
            }
        }
        socket.connect()
    }
    
    
//簡化highcharts繪圖程式
    func viewOptions() ->  HIOptions {

        let options = HIOptions()

        let title = HITitle()
         title.text = ""
         options.title = title

        let xAxis = HIXAxis()
         xAxis.visible = false
         xAxis.tickInterval = 1
         xAxis.accessibility = HIAccessibility()
         xAxis.accessibility.rangeDescription = "Range: 1 to 10"
         options.xAxis = [xAxis]

        let yAxis = HIYAxis()
         yAxis.visible = false
         yAxis.minorTickInterval = 0.1
         yAxis.accessibility = HIAccessibility()
         yAxis.accessibility.rangeDescription = "Range: 0.1 to 1000"
         options.yAxis = [yAxis]


        //關掉標籤
        let tooltip = HITooltip()
         tooltip.enabled = false
         options.tooltip = tooltip
        
   
        //關閉有右上功能鍵
        let exporting = HIExporting()
         exporting.enabled = false
         options.exporting = exporting
        
        
        //浮水印
        let credict = HICredits()
         credict.enabled = false
         options.credits = credict
        
        //關掉分類標籤
        let legend = HILegend()
         legend.enabled = false
         options.legend = legend

        
        return  options
    }

}
