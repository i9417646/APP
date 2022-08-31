//
//  SectionMachineOnTimeViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2022/4/11.
//

import UIKit

class SectionMachineOnTimeViewController: UIViewController {

    @IBOutlet weak var CNCBT: UIButton!
    @IBOutlet weak var EWBT: UIButton!
    @IBOutlet weak var EDMBT: UIButton!
    @IBOutlet weak var OTHERSBT: UIButton!
    @IBOutlet weak var INJ: UIButton!
    
    
    //儲存UIBotton
    @IBOutlet var buttons: [UIButton]!
    //下面顯示機台群組的畫面是使用滑動的UIScrollView
    @IBOutlet weak var ScrollView: UIScrollView!
    
    //用來判斷選到的機台的參數
    var SelecedMechine: String = "CNC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.SelecedAction()
        
   
        
    }
    
    @IBAction func CNCSelect(_ sender: Any) {
        self.SelecedMechine = "CNC"
        print(SelecedMechine)
        let controller = storyboard!.instantiateViewController(withIdentifier: "CNCOnTimeAll")
        ScrollView.contentSize = controller.view.bounds.size
        ScrollView.addSubview(controller.view)
    }
    
    
    
    @IBAction func EWSelect(_ sender: Any) {
        self.SelecedMechine = "EW"
        print(SelecedMechine)
    }
    
    @IBAction func EDMSelect(_ sender: Any) {
        self.SelecedMechine = "EDM"
        print(SelecedMechine)
        let controller = storyboard!.instantiateViewController(withIdentifier: "SectionEDM")
        ScrollView.contentSize = controller.view.bounds.size
        ScrollView.addSubview(controller.view)
    }
    
    @IBAction func OTHERSSelect(_ sender: Any) {
        self.SelecedMechine = "OTHER"
        print(SelecedMechine)
    }
    
    @IBAction func INJSelect(_ sender: Any) {
        self.SelecedMechine = "INJ"
        let controller = storyboard!.instantiateViewController(withIdentifier: "SectionINJSB") as! SectionINJG01ViewController
        ScrollView.contentSize = controller.view.bounds.size
        ScrollView.addSubview(controller.view)
    }
    
    //點擊判斷選擇什麼
    @IBAction func buttonPressToggle(_ sender: UIButton) {
        for btn in self.buttons {
            if btn == sender {
                btn.backgroundColor =  UIColor(cgColor: CGColor(red: 234/234, green: 234/234, blue: 234/234, alpha: 1))
            } else {
                btn.backgroundColor = .none
            }
        }
    }
    
    //初次的選擇
    func SelecedAction() {
        if SelecedMechine == "CNC" {
            self.CNCBT.backgroundColor = UIColor(cgColor: CGColor(red: 234/234, green: 234/234, blue: 234/234, alpha: 1))
        }
    }

   

}
