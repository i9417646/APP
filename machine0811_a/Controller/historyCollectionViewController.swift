//
//  historyCollectionViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2021/11/25.
//

import UIKit
//表格的Identifier名稱
private let reuseIdentifier = "Cell"

class historyCollectionViewController: UICollectionViewController {
    
    //File.swift中的本地數據
    let machineData = machine.data

    override func viewDidLoad() {
        super.viewDidLoad()

        print("1243")
   
        // Register cell classes
       // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

   
    }

  

    // MARK: UICollectionViewDataSource
    //機台有幾類
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return machineData.count
    }

    //一類有幾個
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return machineData[section].names.count
    }
    
    //表格資訊
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! historyCollectionViewCell
    
        cell.ImageView?.image = UIImage(named: machineData[indexPath.section].machineImage[indexPath.row])
        cell.machineName?.text = machineData[indexPath.section].names[indexPath.row]
        cell.logoImg?.image = UIImage(named: machineData[indexPath.section].logoImage[indexPath.row])
       
        return cell
    }
    //表格的表頭
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! HeaderCollectionReusableView
        reusableView.headerLabel.text = machineData[indexPath.section].machingheader
        return reusableView
    }

    
            
    //點選事件
    //跳頁(不使用segue)
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(indexPath.section)
//        print(indexPath.item)
        print(machineData[indexPath.section].names[indexPath.item])
        let chooseMachineName = machineData[indexPath.section].names[indexPath.item]
        if chooseMachineName == "G_01" {
            let vc = storyboard?.instantiateViewController(withIdentifier: "historyINJ")
            show(vc!, sender: self)
        }

    }
    
    
    
}
