//
//  File.swift
//  machine0811_a
//
//  Created by julie on 2021/8/18.
//

import Foundation
import UIKit



//各機台數據
enum machineCategory: String {
    case CNC
    case EW
    case EDM
    case WorkStation
    case LE
}

struct machine {
    let group: machineCategory
    let names: [String]
    let machingheader: String
    let machineImage: [String]
    let logoImage: [String]
}

extension machine {
    static var data: [Self] {
        [
            machine(group: .CNC, names: [
                "CNC_01",
                "CNCA_01",
                "CNCA_02",
                "CNCFA_01"
            ],machingheader: "CNC銑床",machineImage: [
                "CNC01",
                "CNC01",
                "CNC01",
                "CNC01"
            ],
            logoImage: [
                "nil",
                "victor_logo",
                "Delta_logo",
                "hartford"
            ]
            ),
            machine(group: .EW, names: [
            "EW_01",
            "EWA_01",
            "EWA_02"

            ],machingheader: "EW線切割機",machineImage: [
            "ew01",
            "ew01",
            "ew01"
            ],
            logoImage: [
                "nil",
                "AccuteX_logo",
                "AccuteX_logo"
            ]),
            machine(group: .EDM, names: [
            "EDM_01",
            "EDMA_01",
            "EDMA_02",
            "EDMA_03"
            ],machingheader: "EDM放電加工機",machineImage: [
            "EDM01",
            "EDM01",
            "EDM01",
            "EDM01"
            ],
            logoImage: [
                "nil",
                "Excetek_logo",
                "ScarMax",
                "CHMER_logo"
            ]),
            machine(group: .WorkStation, names: [
            "G_01",
            "DESKA_01",
            "EQUATOR_01",
            "WASHA_01"
            ],machingheader: "其他",machineImage: [
            "injection01",
            "desk01",
            "equator01",
            "wash01"
            ],
            logoImage: [
                "ENGEL_logo",
                "Fanuc_logo",
                "Renishaw_logo",
                "Willing_logo"
            ]),
            machine(group: .LE, names: [
            "LEA_01"
            ],machingheader: "LE雷雕",machineImage: [
            "le01",
            ],
            logoImage: [
                "Keyence_logo"
            ])
        ]
    }
}


//post 資料型別
struct machineData: Codable {
    var orderNumber: String
    var tasks: String
    var ImgUrl: URL
    var estimatedTime: Double
    var fifoEndTime: String
    var fifoStartTime: String
}


struct order: Decodable{
    //專案號碼
    var orderFormNumber: String
    //零件號碼
    var tasks: String
    //預估加工時間
    var estimatedTime: Double
    //預估加工開始時間
    var fifoStartTime: String
    //預估加工結束時間
    var fifoEndTime: String
    //機台群組
    var machineGroup: String
    //選擇的機台
    var fifoSelectedMachine: String
    
    
}


//post 資料型別
struct CreateUserBody: Encodable {
    var MachineName: String
}
struct CreateUserResponse: Decodable {
        var orderNumber: String
        var tasks: String
        var estimatedTime: Float
        var fifoStartTime: String
        var fifoEndTime: String
        var ImgUrl: String
}



//首頁機台資訊
struct fontpagemachineimge{
    var machineLogo: String
    var machineName: String
}

var fontpagemachine:[fontpagemachineimge] = [
    fontpagemachineimge(machineLogo: "keyence_logo",machineName: "le01"),
    fontpagemachineimge(machineLogo: "Renishaw_logo",machineName: "equator01"),
    fontpagemachineimge(machineLogo: "willing_logo",machineName: "wash01"),
    fontpagemachineimge(machineLogo: "Hartford_logo",machineName: "CNC01"),
    fontpagemachineimge(machineLogo: "Fanuc_logo",machineName: "desk01"),
    fontpagemachineimge(machineLogo: "victor_logo",machineName: "CNC01"),
    fontpagemachineimge(machineLogo: "Excetek_logo",machineName: "EDM01"),
    fontpagemachineimge(machineLogo: "ENGEL_logo",machineName: "injection01"),
    fontpagemachineimge(machineLogo: "Multiplas_logo",machineName: "injection01"),
    fontpagemachineimge(machineLogo: "ScarMax_logo",machineName: "EDM01"),
    fontpagemachineimge(machineLogo: "AccuteX_logo",machineName: "ew01"),
    fontpagemachineimge(machineLogo: "AccuteX_logo",machineName: "ew01"),
    fontpagemachineimge(machineLogo: "Delta_logo",machineName: "desk01"),
    fontpagemachineimge(machineLogo: "CHMER_logo",machineName: "EDM01"),
    fontpagemachineimge(machineLogo: "Delta_logo",machineName: "CNC01"),
    fontpagemachineimge(machineLogo: "Fcs_logo",machineName: "injection01"),
    fontpagemachineimge(machineLogo: "victor_logo",machineName: "injection01"),
]


//接收專案資訊
struct Work: Decodable {
    var orderFormNumber: String
    var qcSchedule: String
    var ScheduleStatusName: String
    var ScheduleStatusColor: String
}


//專案資訊>>排成資訊
struct singleData: Decodable{
    var orderNumber: String
    var tasksCount: Int
    var AllScheduleCount: Int
    var AllWorkTime: Double
    var Data: [singalWork]

    
}



//預設單一專案製成
struct singalWork: Decodable{
    var tasks: String
    var estimatedTime: [Double]
    var processType: [String]
    var ImgUrl: String
    var ScheduleCount: Int
    var TotalWorkTime: Double

}

struct postKey: Encodable{
    var orderFormNumber: String
}


//gantti chart
struct gann: Decodable{
    var YAxisCategories: [String]
    var XrangeData: [tryX]
}


//gantii
struct Xdata: Decodable{
    var x: Int
    var y: Int
    var x2: Int
    var color:String
}




//排程管理
struct AllWorkSchedule: Decodable{
    var Status: String
    var PorjectData: [ String: String]
}


//排程管理中的專案資料
struct ProjectDataArray: Decodable{
    var orderNumber: String
    var Best: String
    var EDD: String
    var ACO: String
    var GA: String
    var GAACO: String
    var EDDTime: String
    var ACOTime: String
    var GATime: String
    var GAACOTime: String
    var ProcessQuantity: String
}


//單一專案四種排程結果key
struct postvalue: Encodable{
    var orderNumber: String
}

//單一專案四種排程結果
struct SingalSchedule: Decodable {
    var ScheduleValue: [ProjectDataArray]
    var tasks: [String]
    var EDDYAxisCategories: [String]
    var EDDXrangeData: [productName]
    var ACOYAxisCategories: [String]
    var ACOXrangeData: [productName]
    var GAYAxisCategories: [String]
    var GAXrangeData: [productName]
    var GAACOYAxisCategories: [String]
    var GAACOXrangeData: [productName]
    
}

//try
struct productName: Decodable{
    var x: Int
    var y: Int
    var x2: Int
    var color:String
    var tasks: String
   
}


//try
struct tryX: Decodable{
    var x: Int
    var y: Int
    var x2: Int
    var color:String
    var tasks: String
    var ImgUrl: String
}


struct colorpattern: Decodable{
    var path: String
    var width: Int
    var height: Int
}


//單一專案管理零件加工狀況(給post)
struct SingalPostKey: Encodable {
    var orderNumber: String
    var Best: String
    var State: String
}



//單一專案管理零件加工狀況(post回傳)
struct SingalScheduleTask: Decodable {
    var orderNumber: String
    var tasksCount: Int
    var AllScheduleCount: Int
    var AllWorkTime: Double
    var Data: [SignalSTData]
}

struct SignalSTData: Decodable {
    var tasks: String
    var estimatedTime: [Double]
    var processType: [String]
    var ImgUrl: String
    var ScheduleCount: Int
    var TotalWorkTime: Double
    var WorkerMachine: [String]
    var RealWorkTime: [String]
    var WorkerIdx: Int
    var TotalRealWorkTime: Double
}


//射出幾歷史資料(post)
struct rejectionData: Decodable{
    var SPC_cycleTime: String
    var SPC_fillingTime: String
    var SPC_meteringTime: String
    var SPC_screwSpeed: String
    var SPC_maxPressure: String
    var SPC_suckBackPressure: String
    var SPC_meteringEndPos: String
    var SPC_minResidue: String
    var SPC_vpSwitchPressure: String
    var SPC_vpSwitchPos: String
    var SPC_finalResidue: String
    var Pressure_Curve: String
    var IJ_Pre: String
    var IJ_Vel_1st: String
    var IJ_Vel_2nd: String
    var IJ_Vel_3rd: String
    var IJ_Vel_4th: String
    var IJ_Vel_5th: String
    var IP_1: String
    var IP_2: String
    var IP_3: String
    var IP_4: String
    var IP_5: String
    var FB_P: String
    var FB_S: String
    var MEP: String
    var MEP_S: String
    var BP_1st: String
    var BP_2nd: String
    var SRS_1: String
    var SRS_2: String
    var SRP_1: String
    var SRP_2: String
    var V2P_T: String
    var Cooling_T: String
    var M_delay_T: String
    var PACK_P_1st: String
    var PACK_P_2nd: String
    var PACK_P_3rd: String
    var PACK_T_1st: String
    var PACK_T_2nd: String
    var PACK_T_3rd: String
    var Temp_set_Z0: String
    var Temp_set_Z1: String
    var Temp_set_Z2: String
    var Temp_set_Z3: String
    var receivedAt: String
    var shortshot: String
    var shortshot_percent: String
    var weight: String
    var ImgUrl: String
    
}

//射出幾歷史資料分析相關性(圓餅圖)(post請求)
struct injectionAnalysisBody: Encodable{
    var a: String
}

struct injectionAnalysisResponse: Decodable{
    var corr_Data: [Double]
    var corr_title: [String]
}



//射出幾歷史資料分析相關性整理後資料結構
struct circleDataStruct{
    var name: String
    var percent: Float
}



//射出幾即時資訊當日射出資料
struct injectiontheDayData: Decodable {
    var status: Bool
    var data: [injectiontheDayDataData]
}
struct injectiontheDayDataData: Decodable  {
    var SPC_maxPressure: String
    var SPC_fillingTime: String
    var PACK_T_1st: String
    var PACK_T_2nd: String
    var PACK_T_3rd: String
    var receivedAt: String
    var Pressure_Curve: String
}




//射出機當日筆數
struct TodayINJcount: Decodable {
    var status: Bool
    var count: Int
}



//測試
struct testData {
    var apple = 123
    var txt: Int = 567
}


//CNC歷史資訊頁面
struct CNCHistoryData: Codable {
    var projectNo: String?
    var projectEvent: String?
    var status: String?
    var partNo: String?
    var machineNo: String?
    var processType: String?
    var ncCode: String?
    var spindleSpeed: String?
    var feed: String?
    var tempX: String?
    var tempY: String?
    var tempZ: String?
    var tempS: String?
    var receivedAt: String?
    var fftx: String?
    var ffty: String?
    var fftz: String?
    var fftavgxx: String?
    var fftavgyy: String?
    var fftavgzz: String?
    var Ix: String?
    var Iy: String?
    var Iz: String?
    var Is: String?
    var MachineStatus: String?
    var receiveTime: String?
    var NCProgram: String?
    var ToolNumber: String?
    var MachineCoordinatesX: String?
    var MachineCoordinatesY: String?
    var MachineCoordinatesZ: String?
    var NOWTime: String?
    var Toolclassification: String?
    
}

//收集POST request
struct OnTimePOSTKey:Encodable {
    var sort: [sortPOSTKey]
    var size: Int
}


struct sortPOSTKey: Encodable {
    var timestamp: String
}




//EW線割即時資訊(API)
struct EWOnTimeAPI: Decodable {
    var hits: hitsPOST
}

struct hitsPOST:Decodable {
    var hits: [hitshitsPOST]
}

struct hitshitsPOST: Decodable {
    var _source: _sourcePOST
}

struct _sourcePOST: Decodable {
    var AOFF: String
    var AON: String
    var AlarmTotal: String
    var CWT: String
    var CmpTap: String
    var CutLen: String
    var Elapsed: String
    var F: String
    var FR: String
    var FT: String
    var Feedrate: String
    var ION: String
    var IP: String
    var Left: String
    var NO: String
    var Ncode: String
    var OFF: String
    var ON: String
    var OV: String
    var Offset: String
    var Progress: String
    var SG: String
    var SV: String
    var Tangle: String
    var TotalLen: String
    var Ucoor: String
    var Vcoor: String
    var Volts: String
    var WA: String
    var WF: String
    var WT: String
    var Xcoor: String
    var Ycoor: String
    var Zcoor: String
    var timestamp: String

}


