//
//  SectionEDMViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2022/4/20.
//

import UIKit
import SocketIO
import Highcharts

class SectionEDMViewController: UIViewController {
    
    //用來作為各數據之圖表的初始數值
    var firstData: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    
    
    
//MARK: -先捷時機
    
    //連接Storyboard的UI
    @IBOutlet weak var Mechanical_coordinatesX: UILabel!
    @IBOutlet weak var Mechanical_coordinatesY: UILabel!
    @IBOutlet weak var Mechanical_coordinatesZ: UILabel!
    
    @IBOutlet weak var Working_coordinatesX: UILabel!
    @IBOutlet weak var Working_coordinatesY: UILabel!
    @IBOutlet weak var Working_coordinatesZ: UILabel!
    
    @IBOutlet weak var Servo: UILabel!
    @IBOutlet weak var T_OFF: UILabel!
    @IBOutlet weak var JD: UILabel!
    
    @IBOutlet weak var Mechanical_coordinatesXView: UIView!
    @IBOutlet weak var Mechanical_coordinatesYView: UIView!
    @IBOutlet weak var Mechanical_coordinatesZView: UIView!
    
    @IBOutlet weak var Working_coordinatesXView: UIView!
    @IBOutlet weak var Working_coordinatesYView: UIView!
    @IBOutlet weak var Working_coordinatesZView: UIView!
    
    @IBOutlet weak var ServoView: UIView!
    @IBOutlet weak var T_OFFView: UIView!
    @IBOutlet weak var JDView: UIView!
    
    
    
    
//MARK: -慶鴻
    
    //連接Storyboard的UI
    @IBOutlet weak var CHWorking_coordinatesX: UILabel!
    @IBOutlet weak var CHWorking_coordinatesY: UILabel!
    @IBOutlet weak var CHWorking_coordinatesZ: UILabel!
    
    @IBOutlet weak var CHMechanical_coordinatesX: UILabel!
    @IBOutlet weak var CHMechanical_coordinatesY: UILabel!
    @IBOutlet weak var CHMechanical_coordinatesZ: UILabel!
    
    @IBOutlet weak var CHSVO: UILabel!
    @IBOutlet weak var CHTOF: UILabel!
    @IBOutlet weak var CHJP_STE: UILabel!
    
    @IBOutlet weak var CHWorking_coordinatesXView: UIView!
    @IBOutlet weak var CHWorking_coordinatesYView: UIView!
    @IBOutlet weak var CHWorking_coordinatesZView: UIView!
    
    @IBOutlet weak var CHMechanical_coordinatesXView: UIView!
    @IBOutlet weak var CHMechanical_coordinatesYView: UIView!
    @IBOutlet weak var CHMechanical_coordinatesZView: UIView!
    
    @IBOutlet weak var CHSVOView: UIView!
    @IBOutlet weak var CHTOFView: UIView!
    @IBOutlet weak var CHJP_STEView: UIView!
    
    
    //socket
    let manager = SocketManager(socketURL: URL(string: "http://140.135.97.69:8787")!, config: [.log(false), .forceWebsockets(true)])
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("123456")
        
        
        
        
        
        
    //工作座標Ｘ
        let WorkXOptions = viewOptions()

        let WorkXseries = HISeries()
        WorkXseries.data = self.firstData
        WorkXseries.marker  = HIMarker()
        WorkXseries.marker.enabled = false
        WorkXseries.marker.radius = 2.6
        WorkXseries.lineWidth = 2
        WorkXseries.color = HIColor(hexValue: "6b79e4")

        WorkXOptions.series = [WorkXseries]
        
        let WorkXchartView = HIChartView(frame: view.bounds)
        
        WorkXchartView.options = WorkXOptions
       
        WorkXchartView.translatesAutoresizingMaskIntoConstraints = false

        self.Mechanical_coordinatesXView.addSubview(WorkXchartView)
        WorkXchartView.leadingAnchor.constraint(equalTo: Working_coordinatesXView.leadingAnchor, constant: 0).isActive = true
        WorkXchartView.topAnchor.constraint(equalTo: Working_coordinatesXView.topAnchor, constant: 0).isActive = true
        WorkXchartView.trailingAnchor.constraint(equalTo: Working_coordinatesXView.trailingAnchor, constant: 0).isActive = true
        WorkXchartView.bottomAnchor.constraint(equalTo: Working_coordinatesXView.bottomAnchor, constant: 0).isActive = true
        
        
        
        
    //工作座標Ｙ
        let WorkYOptions = viewOptions()

        let WorkYseries = HISeries()
        WorkYseries.data = self.firstData
        WorkYseries.marker  = HIMarker()
        WorkYseries.marker.enabled = false
        WorkYseries.marker.radius = 2.6
        WorkYseries.lineWidth = 2
        WorkYseries.color = HIColor(hexValue: "6b79e4")

        WorkYOptions.series = [WorkYseries]
        
        let WorkYchartView = HIChartView(frame: view.bounds)
        
        WorkYchartView.options = WorkYOptions
       
        WorkYchartView.translatesAutoresizingMaskIntoConstraints = false

        self.Mechanical_coordinatesYView.addSubview(WorkYchartView)
        WorkYchartView.leadingAnchor.constraint(equalTo: Working_coordinatesYView.leadingAnchor, constant: 0).isActive = true
        WorkYchartView.topAnchor.constraint(equalTo: Working_coordinatesYView.topAnchor, constant: 0).isActive = true
        WorkYchartView.trailingAnchor.constraint(equalTo: Working_coordinatesYView.trailingAnchor, constant: 0).isActive = true
        WorkYchartView.bottomAnchor.constraint(equalTo: Working_coordinatesYView.bottomAnchor, constant: 0).isActive = true
        
        
        
        
    //工作座標Z
        let WorkZOptions = viewOptions()

        let WorkZseries = HISeries()
        WorkZseries.data = self.firstData
        WorkZseries.marker  = HIMarker()
        WorkZseries.marker.enabled = false
        WorkZseries.marker.radius = 2.6
        WorkZseries.lineWidth = 2
        WorkZseries.color = HIColor(hexValue: "6b79e4")

        WorkZOptions.series = [WorkZseries]
        
        let WorkZchartView = HIChartView(frame: view.bounds)
        
        WorkZchartView.options = WorkZOptions
       
        WorkZchartView.translatesAutoresizingMaskIntoConstraints = false

        self.Mechanical_coordinatesZView.addSubview(WorkZchartView)
        WorkZchartView.leadingAnchor.constraint(equalTo: Working_coordinatesZView.leadingAnchor, constant: 0).isActive = true
        WorkZchartView.topAnchor.constraint(equalTo: Working_coordinatesZView.topAnchor, constant: 0).isActive = true
        WorkZchartView.trailingAnchor.constraint(equalTo: Working_coordinatesZView.trailingAnchor, constant: 0).isActive = true
        WorkZchartView.bottomAnchor.constraint(equalTo: Working_coordinatesZView.bottomAnchor, constant: 0).isActive = true
        
        
        
        
    //機械座標Ｘ
        let MechXOptions = viewOptions()

        let MechXseries = HISeries()
        MechXseries.data = self.firstData
        MechXseries.marker  = HIMarker()
        MechXseries.marker.enabled = false
        MechXseries.marker.radius = 2.6
        MechXseries.lineWidth = 2
        MechXseries.color = HIColor(hexValue: "6b79e4")

        MechXOptions.series = [MechXseries]
        
        let MechXchartView = HIChartView(frame: view.bounds)
        
        MechXchartView.options = MechXOptions
       
        MechXchartView.translatesAutoresizingMaskIntoConstraints = false

        self.Mechanical_coordinatesXView.addSubview(MechXchartView)
        MechXchartView.leadingAnchor.constraint(equalTo: Mechanical_coordinatesXView.leadingAnchor, constant: 0).isActive = true
        MechXchartView.topAnchor.constraint(equalTo: Mechanical_coordinatesXView.topAnchor, constant: 0).isActive = true
        MechXchartView.trailingAnchor.constraint(equalTo: Mechanical_coordinatesXView.trailingAnchor, constant: 0).isActive = true
        MechXchartView.bottomAnchor.constraint(equalTo: Mechanical_coordinatesXView.bottomAnchor, constant: 0).isActive = true
        

        
    // 機械座標Y
        let MechYOptions = viewOptions()

        let MechYseries = HISeries()
        MechYseries.data = self.firstData
        MechYseries.marker  = HIMarker()
        MechYseries.marker.enabled = false
        MechYseries.marker.radius = 2.6
        MechYseries.lineWidth = 2
        MechYseries.color = HIColor(hexValue: "6b79e4")

        MechYOptions.series = [MechYseries]
        
        let MechYchartView = HIChartView(frame: view.bounds)
        
        MechYchartView.options = MechYOptions
       
        MechYchartView.translatesAutoresizingMaskIntoConstraints = false

        self.Mechanical_coordinatesYView.addSubview(MechYchartView)
        MechYchartView.leadingAnchor.constraint(equalTo: Mechanical_coordinatesYView.leadingAnchor, constant: 0).isActive = true
        MechYchartView.topAnchor.constraint(equalTo: Mechanical_coordinatesYView.topAnchor, constant: 0).isActive = true
        MechYchartView.trailingAnchor.constraint(equalTo: Mechanical_coordinatesYView.trailingAnchor, constant: 0).isActive = true
        MechYchartView.bottomAnchor.constraint(equalTo: Mechanical_coordinatesYView.bottomAnchor, constant: 0).isActive = true
        
        
        
        
    //機械座標Z
        let MechZOptions = viewOptions()

        let MechZseries = HISeries()
        MechZseries.data = self.firstData
        MechZseries.marker  = HIMarker()
        MechZseries.marker.enabled = false
        MechZseries.marker.radius = 2.6
        MechZseries.lineWidth = 2
        MechZseries.color = HIColor(hexValue: "6b79e4")

        MechZOptions.series = [MechZseries]
        
        let MechZchartView = HIChartView(frame: view.bounds)
        
        MechZchartView.options = MechZOptions
       
        MechZchartView.translatesAutoresizingMaskIntoConstraints = false

        self.Mechanical_coordinatesZView.addSubview(MechZchartView)
        MechZchartView.leadingAnchor.constraint(equalTo: Mechanical_coordinatesZView.leadingAnchor, constant: 0).isActive = true
        MechZchartView.topAnchor.constraint(equalTo: Mechanical_coordinatesZView.topAnchor, constant: 0).isActive = true
        MechZchartView.trailingAnchor.constraint(equalTo: Mechanical_coordinatesZView.trailingAnchor, constant: 0).isActive = true
        MechZchartView.bottomAnchor.constraint(equalTo: Mechanical_coordinatesZView.bottomAnchor, constant: 0).isActive = true
        
        
        
    //伺服
        let ServoOptions = viewOptions()

        let Servoseries = HISeries()
        Servoseries.data = self.firstData
        Servoseries.marker  = HIMarker()
        Servoseries.marker.enabled = false
        Servoseries.marker.radius = 2.6
        Servoseries.lineWidth = 2
        Servoseries.color = HIColor(hexValue: "6b79e4")

        ServoOptions.series = [Servoseries]
        
        let ServochartView = HIChartView(frame: view.bounds)
        
        ServochartView.options = ServoOptions
       
        ServochartView.translatesAutoresizingMaskIntoConstraints = false

        self.ServoView.addSubview(ServochartView)
        ServochartView.leadingAnchor.constraint(equalTo: ServoView.leadingAnchor, constant: 0).isActive = true
        ServochartView.topAnchor.constraint(equalTo: ServoView.topAnchor, constant: 0).isActive = true
        ServochartView.trailingAnchor.constraint(equalTo: ServoView.trailingAnchor, constant: 0).isActive = true
        ServochartView.bottomAnchor.constraint(equalTo: ServoView.bottomAnchor, constant: 0).isActive = true
        
        
    //休止
        let T_OFFOptions = viewOptions()

        let T_OFFseries = HISeries()
        T_OFFseries.data = self.firstData
        T_OFFseries.marker  = HIMarker()
        T_OFFseries.marker.enabled = false
        T_OFFseries.marker.radius = 2.6
        T_OFFseries.lineWidth = 2
        T_OFFseries.color = HIColor(hexValue: "6b79e4")

        T_OFFOptions.series = [T_OFFseries]
        
        let T_OFFchartView = HIChartView(frame: view.bounds)
        
        T_OFFchartView.options = T_OFFOptions
       
        T_OFFchartView.translatesAutoresizingMaskIntoConstraints = false

        self.T_OFFView.addSubview(T_OFFchartView)
        T_OFFchartView.leadingAnchor.constraint(equalTo: T_OFFView.leadingAnchor, constant: 0).isActive = true
        T_OFFchartView.topAnchor.constraint(equalTo: T_OFFView.topAnchor, constant: 0).isActive = true
        T_OFFchartView.trailingAnchor.constraint(equalTo: T_OFFView.trailingAnchor, constant: 0).isActive = true
        T_OFFchartView.bottomAnchor.constraint(equalTo: T_OFFView.bottomAnchor, constant: 0).isActive = true

        
    //排渣
        let JDOptions = viewOptions()

        let JDseries = HISeries()
        JDseries.data = self.firstData
        JDseries.marker  = HIMarker()
        JDseries.marker.enabled = false
        JDseries.marker.radius = 2.6
        JDseries.lineWidth = 2
        JDseries.color = HIColor(hexValue: "6b79e4")

        JDOptions.series = [JDseries]
        
        let JDchartView = HIChartView(frame: view.bounds)
        
        JDchartView.options = JDOptions
       
        JDchartView.translatesAutoresizingMaskIntoConstraints = false

        self.JDView.addSubview(JDchartView)
        JDchartView.leadingAnchor.constraint(equalTo: JDView.leadingAnchor, constant: 0).isActive = true
        JDchartView.topAnchor.constraint(equalTo: JDView.topAnchor, constant: 0).isActive = true
        JDchartView.trailingAnchor.constraint(equalTo: JDView.trailingAnchor, constant: 0).isActive = true
        JDchartView.bottomAnchor.constraint(equalTo: JDView.bottomAnchor, constant: 0).isActive = true
        
        
        
        
        
        
        
        
//MARK: -慶鴻圖
        
        
    //工作座標Ｘ
        let CHWorkXOptions = viewOptions()

        let CHWorkXseries = HISeries()
        CHWorkXseries.data = self.firstData
        CHWorkXseries.marker  = HIMarker()
        CHWorkXseries.marker.enabled = false
        CHWorkXseries.marker.radius = 2.6
        CHWorkXseries.lineWidth = 2
        CHWorkXseries.color = HIColor(hexValue: "6b79e4")

        CHWorkXOptions.series = [CHWorkXseries]
        
        let CHWorkXchartView = HIChartView(frame: view.bounds)
        
        CHWorkXchartView.options = CHWorkXOptions
       
        CHWorkXchartView.translatesAutoresizingMaskIntoConstraints = false

        self.CHMechanical_coordinatesXView.addSubview(CHWorkXchartView)
        CHWorkXchartView.leadingAnchor.constraint(equalTo: CHWorking_coordinatesXView.leadingAnchor, constant: 0).isActive = true
        CHWorkXchartView.topAnchor.constraint(equalTo: CHWorking_coordinatesXView.topAnchor, constant: 0).isActive = true
        CHWorkXchartView.trailingAnchor.constraint(equalTo: CHWorking_coordinatesXView.trailingAnchor, constant: 0).isActive = true
        CHWorkXchartView.bottomAnchor.constraint(equalTo: CHWorking_coordinatesXView.bottomAnchor, constant: 0).isActive = true
        
        
        
        
    //工作座標Ｙ
        let CHWorkYOptions = viewOptions()

        let CHWorkYseries = HISeries()
        CHWorkYseries.data = self.firstData
        CHWorkYseries.marker  = HIMarker()
        CHWorkYseries.marker.enabled = false
        CHWorkYseries.marker.radius = 2.6
        CHWorkYseries.lineWidth = 2
        CHWorkYseries.color = HIColor(hexValue: "6b79e4")

        CHWorkYOptions.series = [CHWorkYseries]
        
        let CHWorkYchartView = HIChartView(frame: view.bounds)
        
        CHWorkYchartView.options = CHWorkYOptions
       
        CHWorkYchartView.translatesAutoresizingMaskIntoConstraints = false

        self.CHMechanical_coordinatesYView.addSubview(CHWorkYchartView)
        CHWorkYchartView.leadingAnchor.constraint(equalTo: CHWorking_coordinatesYView.leadingAnchor, constant: 0).isActive = true
        CHWorkYchartView.topAnchor.constraint(equalTo: CHWorking_coordinatesYView.topAnchor, constant: 0).isActive = true
        CHWorkYchartView.trailingAnchor.constraint(equalTo: CHWorking_coordinatesYView.trailingAnchor, constant: 0).isActive = true
        CHWorkYchartView.bottomAnchor.constraint(equalTo: CHWorking_coordinatesYView.bottomAnchor, constant: 0).isActive = true
        
        
        
        
    //工作座標Z
        let CHWorkZOptions = viewOptions()

        let CHWorkZseries = HISeries()
        CHWorkZseries.data = self.firstData
        CHWorkZseries.marker  = HIMarker()
        CHWorkZseries.marker.enabled = false
        CHWorkZseries.marker.radius = 2.6
        CHWorkZseries.lineWidth = 2
        CHWorkZseries.color = HIColor(hexValue: "6b79e4")

        CHWorkZOptions.series = [CHWorkZseries]
        
        let CHWorkZchartView = HIChartView(frame: view.bounds)
        
        CHWorkZchartView.options = CHWorkZOptions
       
        CHWorkZchartView.translatesAutoresizingMaskIntoConstraints = false

        self.CHMechanical_coordinatesZView.addSubview(CHWorkZchartView)
        CHWorkZchartView.leadingAnchor.constraint(equalTo: CHWorking_coordinatesZView.leadingAnchor, constant: 0).isActive = true
        CHWorkZchartView.topAnchor.constraint(equalTo: CHWorking_coordinatesZView.topAnchor, constant: 0).isActive = true
        CHWorkZchartView.trailingAnchor.constraint(equalTo: CHWorking_coordinatesZView.trailingAnchor, constant: 0).isActive = true
        CHWorkZchartView.bottomAnchor.constraint(equalTo: CHWorking_coordinatesZView.bottomAnchor, constant: 0).isActive = true
        
        
        
    //機械座標Ｘ
        let CHMechXOptions = viewOptions()

        let CHMechXseries = HISeries()
        CHMechXseries.data = self.firstData
        CHMechXseries.marker  = HIMarker()
        CHMechXseries.marker.enabled = false
        CHMechXseries.marker.radius = 2.6
        CHMechXseries.lineWidth = 2
        CHMechXseries.color = HIColor(hexValue: "6b79e4")

        CHMechXOptions.series = [CHMechXseries]

        let CHMechXchartView = HIChartView(frame: view.bounds)

        CHMechXchartView.options = CHMechXOptions

        CHMechXchartView.translatesAutoresizingMaskIntoConstraints = false

        self.CHMechanical_coordinatesXView.addSubview(CHMechXchartView)
        CHMechXchartView.leadingAnchor.constraint(equalTo: CHMechanical_coordinatesXView.leadingAnchor, constant: 0).isActive = true
        CHMechXchartView.topAnchor.constraint(equalTo: CHMechanical_coordinatesXView.topAnchor, constant: 0).isActive = true
        CHMechXchartView.trailingAnchor.constraint(equalTo: CHMechanical_coordinatesXView.trailingAnchor, constant: 0).isActive = true
        CHMechXchartView.bottomAnchor.constraint(equalTo: CHMechanical_coordinatesXView.bottomAnchor, constant: 0).isActive = true



    // 機械座標Y
        let CHMechYOptions = viewOptions()

        let CHMechYseries = HISeries()
        CHMechYseries.data = self.firstData
        CHMechYseries.marker  = HIMarker()
        CHMechYseries.marker.enabled = false
        CHMechYseries.marker.radius = 2.6
        CHMechYseries.lineWidth = 2
        CHMechYseries.color = HIColor(hexValue: "6b79e4")

        CHMechYOptions.series = [CHMechYseries]

        let CHMechYchartView = HIChartView(frame: view.bounds)

        CHMechYchartView.options = CHMechYOptions

        CHMechYchartView.translatesAutoresizingMaskIntoConstraints = false

        self.CHMechanical_coordinatesYView.addSubview(CHMechYchartView)
        CHMechYchartView.leadingAnchor.constraint(equalTo: CHMechanical_coordinatesYView.leadingAnchor, constant: 0).isActive = true
        CHMechYchartView.topAnchor.constraint(equalTo: CHMechanical_coordinatesYView.topAnchor, constant: 0).isActive = true
        CHMechYchartView.trailingAnchor.constraint(equalTo: CHMechanical_coordinatesYView.trailingAnchor, constant: 0).isActive = true
        CHMechYchartView.bottomAnchor.constraint(equalTo: CHMechanical_coordinatesYView.bottomAnchor, constant: 0).isActive = true




    //機械座標Z
        let CHMechZOptions = viewOptions()

        let CHMechZseries = HISeries()
        CHMechZseries.data = self.firstData
        CHMechZseries.marker  = HIMarker()
        CHMechZseries.marker.enabled = false
        CHMechZseries.marker.radius = 2.6
        CHMechZseries.lineWidth = 2
        CHMechZseries.color = HIColor(hexValue: "6b79e4")

        CHMechZOptions.series = [CHMechZseries]

        let CHMechZchartView = HIChartView(frame: view.bounds)

        CHMechZchartView.options = CHMechZOptions

        CHMechZchartView.translatesAutoresizingMaskIntoConstraints = false

        self.CHMechanical_coordinatesZView.addSubview(CHMechZchartView)
        CHMechZchartView.leadingAnchor.constraint(equalTo: CHMechanical_coordinatesZView.leadingAnchor, constant: 0).isActive = true
        CHMechZchartView.topAnchor.constraint(equalTo: CHMechanical_coordinatesZView.topAnchor, constant: 0).isActive = true
        CHMechZchartView.trailingAnchor.constraint(equalTo: CHMechanical_coordinatesZView.trailingAnchor, constant: 0).isActive = true
        CHMechZchartView.bottomAnchor.constraint(equalTo: CHMechanical_coordinatesZView.bottomAnchor, constant: 0).isActive = true
            
        
        
        
        
        
        
        
    //伺服
        let SVOOptions = viewOptions()

        let SVOseries = HISeries()
        SVOseries.data = self.firstData
        SVOseries.marker  = HIMarker()
        SVOseries.marker.enabled = false
        SVOseries.marker.radius = 2.6
        SVOseries.lineWidth = 2
        SVOseries.color = HIColor(hexValue: "6b79e4")

        SVOOptions.series = [SVOseries]
        
        let SVOchartView = HIChartView(frame: view.bounds)
        
        SVOchartView.options = SVOOptions
       
        SVOchartView.translatesAutoresizingMaskIntoConstraints = false

        self.CHSVOView.addSubview(SVOchartView)
        SVOchartView.leadingAnchor.constraint(equalTo: CHSVOView.leadingAnchor, constant: 0).isActive = true
        SVOchartView.topAnchor.constraint(equalTo: CHSVOView.topAnchor, constant: 0).isActive = true
        SVOchartView.trailingAnchor.constraint(equalTo: CHSVOView.trailingAnchor, constant: 0).isActive = true
        SVOchartView.bottomAnchor.constraint(equalTo: CHSVOView.bottomAnchor, constant: 0).isActive = true
        
        
        
        
    //休止
        let TOFOptions = viewOptions()

        let TOFseries = HISeries()
        TOFseries.data = self.firstData
        TOFseries.marker  = HIMarker()
        TOFseries.marker.enabled = false
        TOFseries.marker.radius = 2.6
        TOFseries.lineWidth = 2
        TOFseries.color = HIColor(hexValue: "6b79e4")

        TOFOptions.series = [TOFseries]
        
        let TOFchartView = HIChartView(frame: view.bounds)
        
        TOFchartView.options = TOFOptions
       
        TOFchartView.translatesAutoresizingMaskIntoConstraints = false

        self.CHTOFView.addSubview(TOFchartView)
        TOFchartView.leadingAnchor.constraint(equalTo: CHTOFView.leadingAnchor, constant: 0).isActive = true
        TOFchartView.topAnchor.constraint(equalTo: CHTOFView.topAnchor, constant: 0).isActive = true
        TOFchartView.trailingAnchor.constraint(equalTo: CHTOFView.trailingAnchor, constant: 0).isActive = true
        TOFchartView.bottomAnchor.constraint(equalTo: CHTOFView.bottomAnchor, constant: 0).isActive = true
        
        
        
    //排渣
        let JP_STEOptions = viewOptions()

        let JP_STEseries = HISeries()
        JP_STEseries.data = self.firstData
        JP_STEseries.marker  = HIMarker()
        JP_STEseries.marker.enabled = false
        JP_STEseries.marker.radius = 2.6
        JP_STEseries.lineWidth = 2
        JP_STEseries.color = HIColor(hexValue: "6b79e4")

        JP_STEOptions.series = [JP_STEseries]
        
        let JP_STEchartView = HIChartView(frame: view.bounds)
        
        JP_STEchartView.options = JP_STEOptions
       
        JP_STEchartView.translatesAutoresizingMaskIntoConstraints = false

        self.CHJP_STEView.addSubview(JP_STEchartView)
        JP_STEchartView.leadingAnchor.constraint(equalTo: CHJP_STEView.leadingAnchor, constant: 0).isActive = true
        JP_STEchartView.topAnchor.constraint(equalTo: CHJP_STEView.topAnchor, constant: 0).isActive = true
        JP_STEchartView.trailingAnchor.constraint(equalTo: CHJP_STEView.trailingAnchor, constant: 0).isActive = true
        JP_STEchartView.bottomAnchor.constraint(equalTo: CHJP_STEView.bottomAnchor, constant: 0).isActive = true
        
 //MARK: -OSCAR_Socket
        
        let socket = manager.defaultSocket
        socket.on(clientEvent: .connect) { (data, _) in
            print("Section_EDMＡＬＬsocket connected")
            print("\(data.debugDescription)")
  
        }
        
        socket.on("EDM_OSCARMAX"){ (data, _) in
            
            //print(data)
            guard let dataInfo = data.first else { return }
            
            if let response: Secction_OSCAR_EDMSocketData = try? SocketParser.convert(data: dataInfo) {
              //  print("\(response)")
                
                self.Working_coordinatesX.text = "\(response.Working_coordinatesX)"
                self.Working_coordinatesY.text = "\(response.Working_coordinatesY)"
                self.Working_coordinatesZ.text = "\(response.Working_coordinatesZ)"
                
                self.Mechanical_coordinatesX.text = "\(response.Mechanical_coordinatesX)"
                self.Mechanical_coordinatesY.text = "\(response.Mechanical_coordinatesY)"
                self.Mechanical_coordinatesZ.text = "\(response.Mechanical_coordinatesZ)"
                
                self.Servo.text = "\(response.Servo)"
                self.T_OFF.text = "\(response.T_OFF)"
                self.JD.text = "\(response.JD)"
                
                
            //新增工作Ｘ座標
                let WorkCoorXNewData = HIData()
                WorkCoorXNewData.y = NSNumber(value: Float(response.Working_coordinatesX) ?? 0)
                WorkXseries.addPoint(WorkCoorXNewData)
                WorkXseries.removePoint(0)
                       
                
            //新增工作Y座標
                let WorkCoorYNewData = HIData()
                WorkCoorYNewData.y = NSNumber(value: Float(response.Working_coordinatesY) ?? 0)
                WorkYseries.addPoint(WorkCoorYNewData)
                WorkYseries.removePoint(0)
                    
            //新增工作Z座標
                let WorkCoorZNewData = HIData()
                WorkCoorZNewData.y = NSNumber(value: Float(response.Working_coordinatesZ) ?? 0)
                WorkZseries.addPoint(WorkCoorZNewData)
                WorkZseries.removePoint(0)
                
            //新增機械Ｘ座標
                let mechCoorXNewData = HIData()
                mechCoorXNewData.y = NSNumber(value: Float(response.Mechanical_coordinatesX) ?? 0)
                MechXseries.addPoint(mechCoorXNewData)
                MechXseries.removePoint(0)
                
            //新增機械Ｙ座標
                let mechCoorYNewData = HIData()
                mechCoorYNewData.y = NSNumber(value: Float(response.Mechanical_coordinatesY) ?? 0)
                MechYseries.addPoint(mechCoorYNewData)
                MechYseries.removePoint(0)

                
            //新增機械Z座標
                let mechCoorZNewData = HIData()
                mechCoorZNewData.y = NSNumber(value: Float(response.Mechanical_coordinatesZ) ?? 0)
                MechZseries.addPoint(mechCoorZNewData)
                MechZseries.removePoint(0)
                
            //新增伺服
                let ServoNewData = HIData()
                ServoNewData.y = NSNumber(value: Float(response.Servo) ?? 0)
                Servoseries.addPoint(ServoNewData)
                Servoseries.removePoint(0)
                
            //新增休止
                let T_OFFNewData = HIData()
                T_OFFNewData.y = NSNumber(value: Float(response.T_OFF) ?? 0)
                T_OFFseries.addPoint(T_OFFNewData)
                T_OFFseries.removePoint(0)
                
            //新增休止
                let JDNewData = HIData()
                JDNewData.y = NSNumber(value: Float(response.JD) ?? 0)
                JDseries.addPoint(JDNewData)
                JDseries.removePoint(0)
                
            }
        }
        
        
//MARK: -慶洪CHIMER_Soket
        
        socket.on("EDM"){ (data, _) in
          //  print(data)
            guard let dataInfo = data.first else { return }
            
            if let response: Secction_CHIMER_SocketData = try? SocketParser.convert(data: dataInfo) {
                //print("慶鴻\(response)")
                
                self.CHWorking_coordinatesX.text = "\(response.Working_coordinatesX)"
                self.CHWorking_coordinatesY.text = "\(response.Working_coordinatesY)"
                self.CHWorking_coordinatesZ.text = "\(response.Working_coordinatesZ)"
                self.CHMechanical_coordinatesX.text = "\(response.Mechanical_coordinatesX)"
                self.CHMechanical_coordinatesY.text = "\(response.Mechanical_coordinatesY)"
                self.CHMechanical_coordinatesZ.text = "\(response.Mechanical_coordinatesZ)"
                self.CHSVO.text = "\(response.SVO)"
                self.CHTOF.text = "\(response.TOF)"
                self.CHJP_STE.text = "\(response.JP_STE)"
                
            //新增工作Ｘ座標
                let CHWorkCoorXNewData = HIData()
                CHWorkCoorXNewData.y = NSNumber(value: Float(response.Working_coordinatesX) ?? 0)
                CHWorkXseries.addPoint(CHWorkCoorXNewData)
                CHWorkXseries.removePoint(0)
                       
                
            //新增工作Y座標
                let CHWorkCoorYNewData = HIData()
                CHWorkCoorYNewData.y = NSNumber(value: Float(response.Working_coordinatesY) ?? 0)
                CHWorkYseries.addPoint(CHWorkCoorYNewData)
                CHWorkYseries.removePoint(0)
                    
            //新增工作Z座標
                let CHWorkCoorZNewData = HIData()
                CHWorkCoorZNewData.y = NSNumber(value: Float(response.Working_coordinatesZ) ?? 0)
                CHWorkZseries.addPoint(CHWorkCoorZNewData)
                CHWorkZseries.removePoint(0)
                
            //新增機械Ｘ座標
                let CHmechCoorXNewData = HIData()
                CHmechCoorXNewData.y = NSNumber(value: Float(response.Mechanical_coordinatesX) ?? 0)
                CHMechXseries.addPoint(CHmechCoorXNewData)
                CHMechXseries.removePoint(0)

            //新增機械Ｙ座標
                let CHmechCoorYNewData = HIData()
                CHmechCoorYNewData.y = NSNumber(value: Float(response.Mechanical_coordinatesY) ?? 0)
                CHMechYseries.addPoint(CHmechCoorYNewData)
                CHMechYseries.removePoint(0)


            //新增機械Z座標
                let CHmechCoorZNewData = HIData()
                CHmechCoorZNewData.y = NSNumber(value: Float(response.Mechanical_coordinatesZ) ?? 0)
                CHMechZseries.addPoint(CHmechCoorZNewData)
                CHMechZseries.removePoint(0)
                
                
            //新增伺服
                let SVONewData = HIData()
                SVONewData.y = NSNumber(value: Float(response.SVO) ?? 0)
                SVOseries.addPoint(SVONewData)
                SVOseries.removePoint(0)
                
                
//                var TOFStr = response.TOF
//                print("字串\(TOFStr)")
//                print("結果\(TOFStr.replacingOccurrences(of: " ", with: ""))")

            //新增休止
                let TOFNewData = HIData()
                TOFNewData.y = NSNumber(value: Float(response.TOF.replacingOccurrences(of: " ", with: "")) ?? 0)
                TOFseries.addPoint(TOFNewData)
                TOFseries.removePoint(0)
                
            //新增排渣
                let JP_STENewData = HIData()
                JP_STENewData.y = NSNumber(value: Float(response.JP_STE) ?? 0)
                JP_STEseries.addPoint(JP_STENewData)
                JP_STEseries.removePoint(0)
                
                
            }
        }
        
        socket.connect()

        
    }
    
    //用來簡化highcharts畫圖的程式
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


//用來轉換資料的架構
struct Secction_OSCAR_EDMSocketData: Codable {
    var Working_coordinatesX: String
    var Working_coordinatesY: String
    var Working_coordinatesZ: String
    var Mechanical_coordinatesX: String
    var Mechanical_coordinatesY: String
    var Mechanical_coordinatesZ: String
    var Servo: String
    var T_OFF: String
    var JD: String
}
struct Secction_CHIMER_SocketData: Codable {
    var TOF: String
    var SVO: String
    var JP_STE: String
    var Mechanical_coordinatesX: String
    var Mechanical_coordinatesY: String
    var Mechanical_coordinatesZ: String
    var Working_coordinatesX: String
    var Working_coordinatesY: String
    var Working_coordinatesZ: String
}
