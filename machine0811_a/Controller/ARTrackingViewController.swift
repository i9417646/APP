//
//  ARTrackingViewController.swift
//  machine0811_a
//
//  Created by CAX521 on 2021/11/5.
//

import UIKit
import ARKit
import SceneKit
import SceneKit.ModelIO

class ARTrackingViewController: UIViewController, ARSCNViewDelegate, UIGestureRecognizerDelegate {

    
    @IBOutlet weak var sceneView: ARSCNView!
    
    //顯示資料儲存
    let web: [String:String] = ["CNCA_01": "http://140.135.97.69:8080/#/CNC_Vcenter_p76",
                                "CNCA_02": "http://140.135.97.69:8080/#/CNC_YTM763",
                                "G_01": "http://140.135.97.69:8080/#/INJOnly"]
    var selectName: String? = ""
    //影像辨識出來的寬度(可用以作為資料放入的尺寸比例尺)
    var trackingImgWidth: CGFloat = 0
    //影像辨識出來的高度(可用以作為資料放入的尺寸比例尺)
    var trackingImgHeigh: CGFloat = 0
    //作為dotnode的暫存(可以用來暫存來指定他)
    var dotNodes = [SCNNode]()
    
    var productNode = SCNNode()
    
    //Store The Rotation Of The CurrentNode
    var currentAngleY: Float = 0.0

    //Not Really Necessary But Can Use If You Like
    var isRotating = false
    
    //旋轉角度暫存
    var YAngle: Float = 0.0
    var ZAngle: Float = 0.0
    var XAngle: Float = 0.0
    
    
    
    var originalRotation: SCNVector3? = nil
    
    var pictureNode = SCNNode()
    
    
    
    /// A serial queue for thread safety when modifying SceneKit's scene graph.
    let updateQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).serialSCNQueue")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("runing")
        
        sceneView.delegate = self
        
        //顯示資訊(原點座標軸)
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        
        // Show statistics such as fps and timing information
        //在使用AR的狀態顯示欄，會顯示在下面
        sceneView.showsStatistics = true
        
        //給予環境光源
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //作為影像辨識圖片的位置(在Assets.xcassets的machine)
        guard let refImages = ARReferenceImage.referenceImages(inGroupNamed: "machine", bundle: Bundle.main) else {
                fatalError("Missing expected asset catalog resources.")
        }
        
        
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        //影像辨識是依據Assets.xcassets的machine
        configuration.trackingImages = refImages
        //最多辨識一張
        configuration.maximumNumberOfTrackedImages = 1
        
        // Run the view's session
        sceneView.session.run(configuration, options: ARSession.RunOptions(arrayLiteral: [.resetTracking, .removeExistingAnchors]))
        
        //點擊動作註冊
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        


        //點擊旋轉註冊
        let rotationGesture = UIRotationGestureRecognizer(target: self,action: #selector(rotation))
        self.sceneView.addGestureRecognizer(rotationGesture)
        //點擊旋轉註冊
        let rotationRight  = UISwipeGestureRecognizer(target: self, action: #selector(rotationRight(_:)))
        rotationRight.direction = .right
        self.sceneView.addGestureRecognizer(rotationRight)
        //點擊旋轉註冊
        let rotationLeft  = UISwipeGestureRecognizer(target: self, action: #selector(rotationLeft(_:)))
        rotationLeft.direction = .left
        self.sceneView.addGestureRecognizer(rotationLeft)

    }

    //畫面生命週期
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
  
//MARK: -addNode
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor){
        //確保有抓到圖案
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        
        //追蹤圖像檔名
        guard let ImageName = imageAnchor.referenceImage.name else { return }
        
        //將追蹤圖檔檔名回傳到外部變數做儲存
        self.selectName = ImageName
        
        
        print(web[ImageName]!)
        
        updateQueue.async {
            //追蹤照片長寬
            let imageWidth = imageAnchor.referenceImage.physicalSize.width
            let imageHeight = imageAnchor.referenceImage.physicalSize.height
            
            self.trackingImgWidth = imageWidth
            self.trackingImgHeigh = imageHeight
    //MARK: -追蹤照片節點
            
            //追蹤照片的節點
            let mainPlane = SCNPlane(width: imageWidth, height: imageHeight)
            //遮罩加動畫
            mainPlane.firstMaterial?.colorBufferWriteMask = .alpha
            //mainPlane.firstMaterial?.diffuse.contents = UIColor.red
            // Create a SceneKit root node with the plane geometry to attach to the scene graph
            // This node will hold the virtual UI in place
            let mainNode = SCNNode(geometry: mainPlane)
            mainNode.eulerAngles.x = -.pi / 2
            mainNode.renderingOrder = -1
            mainNode.opacity = 1
            
            // Add the plane visualization to the scene
            //加入基底視圖
            node.addChildNode(mainNode)
            
            

    //MARK: -選項View
            
            //加入平面選項
            let label = SCNPlane(width: imageWidth, height: imageHeight / 4)
            label.cornerRadius = 0.01
            label.firstMaterial?.diffuse.contents = UIColor.white
            
            self.highlightDetection(on: mainNode, width: imageWidth, height: imageHeight, completionHandler: {
                self.labelView(on: mainNode, position: SCNVector3(0 ,imageHeight / 2 - label.height / 2,-0.006), imageWidth: imageWidth / 3 * 2, imageHeight: imageHeight, title: "機台數據", name: "machineData")
                
                self.labelView(on: mainNode, position: SCNVector3(0, imageHeight / 2 - label.height - imageHeight / 7,-0.006), imageWidth: imageWidth / 3 * 2, imageHeight: imageHeight, title: "當前加工零件", name: "task3D")
            })
            
            
            self.pictureNode = mainNode
        }
        

       
      
    }
    
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        //點選到的view
        let sceneViewTappedOn = sender.view as! SCNView
        //點選到的座標(參數是UIView)
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        //在渲染器的場景中搜索與渲染圖像中的點相對應的對象
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        if hitTest.isEmpty {
            print("didn't touch anything")
        } else {
            //移除已先存的node
            for dot in dotNodes {
                dot.removeFromParentNode()
            }
            
            //清空預設值
            dotNodes = [SCNNode]()
            
            self.YAngle = 0.0
            self.XAngle = 0.0
            
            let results = hitTest.first!
            let node = results.node
            
            guard let label = node.name else { return }
          //  print(label)
            if label == "machineData"{
              //點選label變灰
                let MaskPlane = SCNPlane(width: trackingImgWidth / 3 * 2, height: trackingImgHeigh / 4)
                MaskPlane.cornerRadius = 0.01
                MaskPlane.firstMaterial?.diffuse.contents = UIColor.lightGray
                
                let MaskNode = SCNNode(geometry: MaskPlane)
                MaskNode.position = SCNVector3(0,0,0)
                MaskNode.opacity = 0.8
                node.addChildNode(MaskNode)
                dotNodes.append(MaskNode)
                
                //抓到的機台名稱
                print(self.selectName!)
               
                //網站視窗
                guard let webURL = web[selectName!] else { fatalError("不能抓到網站網址") }
                
                print(webURL)
                
                DispatchQueue.main.async {
                    let request = URLRequest(url: URL(string: webURL)!)
                    let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: 2000, height: 1400))
                    webView.loadRequest(request)
                    
                    let webViewPlane = SCNPlane(width: 0.2, height: 0.154)
                    let webViewNode = SCNNode(geometry: webViewPlane)
                    webViewNode.geometry?.firstMaterial?.diffuse.contents = webView
                    webViewNode.position = SCNVector3(0.13, -webViewPlane.height / 2 + 0.01,0)
                    webViewNode.opacity = 0
                    
                    node.addChildNode(webViewNode)
                    self.dotNodes.append(webViewNode)
                    
                    webViewNode.runAction(.sequence([
                        .wait(duration: 1.0),
                        .fadeOpacity(to: 1.0, duration: 1.5),
                       
                        ])
                    )
                }
                
                
            } else {
                //點選label變灰
                  let MaskPlane = SCNPlane(width: trackingImgWidth / 3 * 2, height: trackingImgHeigh / 4)
                  MaskPlane.cornerRadius = 0.01
                  MaskPlane.firstMaterial?.diffuse.contents = UIColor.lightGray
                  
                  let MaskNode = SCNNode(geometry: MaskPlane)
                    MaskNode.position = SCNVector3(0,0,0)
                  MaskNode.opacity = 0.8
                  node.addChildNode(MaskNode)
                  dotNodes.append(MaskNode)
                
          

                var modelUrl: String = ""
                if self.selectName == "CNCA_01" {
                    modelUrl = "art.scnassets/data1.obj"
  //                  modelUrl = "art.scnassets/task.scn"
                } else {
                    modelUrl = "art.scnassets/35060001mno01.scn"
                }
                
                
                
//                let modelScene = SCNScene(named: modelUrl)
//                let modelNode = modelScene?.rootNode.childNode(withName: "0", recursively: false)
//                modelNode?.position = SCNVector3(0.18,0,0)
//                modelNode?.scale = SCNVector3(0.001,0.001,0.001)
//
//
////                let myURL = NSURL(string: "http://140.135.97.72:8787/scntool/35060001mso04.scn")
////                modelNode?.geometry?.firstMaterial?.diffuse.contents = myURL
//
//
//                modelNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.lightGray
//                modelNode?.geometry?.firstMaterial?.lightingModel = .physicallyBased
//                modelNode?.geometry?.firstMaterial?.metalness.intensity = 1.0
//                modelNode?.geometry?.firstMaterial?.roughness.intensity = 0.0
//                modelNode?.simdPivot.columns.3.z = 0.25
//                modelNode?.AllCenter()
//                self.pictureNode.addChildNode(modelNode!)
//                dotNodes.append(modelNode!)
//
//
//
//
//
//                self.productNode = modelNode!

                
               // print("建立模型的時候\(self.productNode)")
//
                
                //加載路徑
//                let myURL = NSURL(string: "http://140.135.97.72:8787/scntool/35060001mso04.scn")
                let myURL = NSURL(string: "http://140.135.97.72:8787/scn/prt0003_color.scn")
//                let obURL = URL(string: "http://140.135.97.72:8787/scn/prt0003_color.obj")!


                guard let Url = myURL else { fatalError("連接不到零件網站") }
                
//                let asset = MDLAsset(url: obURL)
//                asset.loadTextures()
//                let objscene = SCNScene(mdlAsset: asset)
//                let objDataNode = objscene.rootNode.flattenedClone()
// //               let objDataNode = objscene.rootNode.childNode(withName: "0", recursively: true)
//                objDataNode.scale = SCNVector3(0.001,0.001,0.001)
//
//                //dataNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.lightGray
//
//                objDataNode.position = SCNVector3(0.2,-0.03,0)
//                objDataNode.geometry?.firstMaterial?.diffuse.contents = UIColor.lightGray
//                objDataNode.geometry?.firstMaterial?.lightingModel = .physicallyBased
//                objDataNode.geometry?.firstMaterial?.metalness.intensity = 1.0
//                objDataNode.geometry?.firstMaterial?.roughness.intensity = 0.0
//                objDataNode.AllCenter()
//
//                self.pictureNode.addChildNode(objDataNode)
//
//                dotNodes.append(objDataNode)
//
//                self.productNode = objDataNode
                
                
                
                //載入路徑
                guard let scene = try? SCNScene(url: Url as URL, options: nil) else { return }

                let dataNode = scene.rootNode.childNode(withName: "0", recursively: true)

                dataNode?.scale = SCNVector3(0.001,0.001,0.001)

                //dataNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.lightGray

                dataNode?.position = SCNVector3(0.2,-0.03,0)
                dataNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.lightGray
                dataNode?.geometry?.firstMaterial?.lightingModel = .physicallyBased
                dataNode?.geometry?.firstMaterial?.metalness.intensity = 1.0
                dataNode?.geometry?.firstMaterial?.roughness.intensity = 0.0
                dataNode?.AllCenter()

//                let materilURL = NSURL(string: "http://140.135.97.72:8787/scn/prt0003_color.mtl")
//                dataNode?.geometry?.firstMaterial?.diffuse.contents = materilURL

//                let taskRotation = Rotation(time: 8)
//                dataNode?.runAction(taskRotation)

//                guard let data3D = dataNode else { fatalError("不能載入模型") }
//                print(data3D)

 //               node.addChildNode(dataNode!)

                self.pictureNode.addChildNode(dataNode!)

                dotNodes.append(dataNode!)

                self.productNode = dataNode!
                
                
            }

        }
    }
    
    

    //向右旋轉動作
    @objc func rotationRight(_ gesture: UISwipeGestureRecognizer) {
        self.YAngle = self.YAngle + 30
        //取得零件節點
//        let product = self.pictureNode.childNodes
        let angle = CGFloat(self.YAngle * .pi / 180)
        let rotateAction =  SCNAction.rotateTo(x: 0, y: angle, z: 0, duration: 0.5)
        self.productNode.runAction(rotateAction)
        
    }
   //向左旋轉動作
    @objc func rotationLeft(_ gesture: UISwipeGestureRecognizer) {
        self.YAngle = self.YAngle - 30
        //取得零件節點
//        let product = self.pictureNode.childNodes
        let angle = CGFloat(self.YAngle * .pi / 180)
        let rotateAction =  SCNAction.rotateTo(x: 0, y: angle, z: 0, duration: 0.5)
        self.productNode.runAction(rotateAction)
    }
    
    //向上下旋轉動作
    @objc func rotation(_ gesture: UIRotationGestureRecognizer) {

        
        let location = gesture.location(in: self.sceneView)

        
        guard let node = nodeMethod(at: location)
        else {
            return
        }
       // print(node)

        switch gesture.state {
            case .began:
                originalRotation = node.eulerAngles
            case .changed:
                guard var originalRotation = originalRotation
                else {
                    return
                }
                
//                let rotateAction =  SCNAction.rotateTo(x: -gesture.rotation, y: -gesture.rotation, z: 0, duration: 0.5 )
//                self.productNode.runAction(rotateAction)
                
                
 //               originalRotation.y -= Float(gesture.rotation)
               originalRotation.x -= Float(gesture.rotation)
                node.eulerAngles = originalRotation
            default:
                originalRotation = nil
        }
    }
    
    

    
    
    private func nodeMethod(at position: CGPoint) -> SCNNode? {

        //取得零件節點
        let product = self.pictureNode.childNodes
        
       // print("product = \(product)")
        
        let n = self.sceneView.hitTest(position, options: nil).first(where: {
            $0.node !== product[1]
        })?.node

        return n
    }
    
    
    
    //加入正方形(測試用，目前沒使用)
    func addBox(on rootNode: SCNNode) {
        let boxNode = SCNNode(geometry: SCNBox(width: 0.005, height: 0.005, length: 0.005, chamferRadius: 0))
        boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        boxNode.position = SCNVector3(0,0,0)
        //self.sceneView.scene.rootNode.addChildNode(boxNode)
        rootNode.addChildNode(boxNode)
    }
    
    
    //文字Node
    func textNode(_ str: String, font: UIFont, maxWidth: Int? = nil, color: UIColor) -> SCNNode {
        let text = SCNText(string: str, extrusionDepth: 0)
        
        //當 SceneKit 擠出文本時，這些段會變成邊多邊形,使用flatness使其平滑
        text.flatness = 0.1
        text.font = font
        
        //改顏色
        let material = SCNMaterial()
        material.diffuse.contents = color
        text.materials = [material]
        
        if let maxWidth = maxWidth {
            //一個矩形，指定 SceneKit 應該在其中佈置文本的區域。
            text.containerFrame = CGRect(origin: .zero, size: CGSize(width: maxWidth, height: 500))
            
            //文字只被包在裡面
            text.isWrapped = true
        }
            let textNode = SCNNode(geometry: text)
            textNode.scale = SCNVector3(0.003, 0.003, 0.003)
            
            return textNode
    }
    
    
    //偵測到照片閃爍動畫
    func highlightDetection(on rootNode: SCNNode, width: CGFloat, height: CGFloat, completionHandler block: @escaping (() -> Void)) {
        let planeNode = SCNNode(geometry: SCNPlane(width: width, height: height))
        planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        planeNode.position.z += 0.001
        planeNode.opacity = 0
        rootNode.addChildNode(planeNode)
        planeNode.runAction(self.imageHighlightAction) {
            block()
        }
    }
    
    //閃爍消失動畫
    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
            ])
    }
    
    //加入標籤
    func labelView(on rootNode: SCNNode, position: SCNVector3, imageWidth: CGFloat, imageHeight: CGFloat, title: String, name: String ){
        let label = SCNPlane(width: imageWidth , height: imageHeight / 4)
        label.cornerRadius = 0.01
        label.firstMaterial?.diffuse.contents = UIColor.white
        
        let plane = SCNNode(geometry: label)
        plane.renderingOrder = -1
        plane.opacity = 1
        plane.position = position
        plane.name = name
        rootNode.addChildNode(plane)
        
        
        
        let text = SCNText(string: title, extrusionDepth: 0)
        //當 SceneKit 擠出文本時，這些段會變成邊多邊形,使用flatness使其平滑
        text.flatness = 0.1
        text.font = UIFont.systemFont(ofSize: 3, weight: UIFont.Weight.bold)
        //改顏色
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.black
        text.materials = [material]
        let textNode = SCNNode(geometry: text)
        textNode.scale = SCNVector3(0.002, 0.002, 0.002)
        textNode.pivoOnCenter()
        textNode.position = SCNVector3(0,0,0.0005)
        
        
        plane.runAction(.sequence([
            .fadeOpacity(to: 1.0, duration: 0.8),
            .moveBy(x: 0.07, y: 0, z: 0, duration: 0.8)
                           ])
                )
        plane.addChildNode(textNode)
    }
    
    //旋轉動作
    func Rotation(time: TimeInterval) -> SCNAction {
        let Rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: time)
        let foreverRotation = SCNAction.repeatForever(Rotation)
        return foreverRotation
    }
    
    
}


//定位原點改變(更改原先框架的對物體的定位位置)
extension SCNNode {
    var width: Float {
        return (boundingBox.max.x - boundingBox.min.x) * scale.x
    }
    var height: Float {
        return (boundingBox.max.y - boundingBox.min.y) * scale.y
    }
    
    func pivoOnTopLeft(){
        let (min, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation(min.x, (max.y - min.y) + min.y, 0)
    }
    
    func pivoOnTopCenter(){
        let (min, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation((max.x - min.x) / 2 + min.x, (max.y - min.y) + min.y, 0)
    }
    
    func pivoOnCenter(){
        let (min, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation((max.x - min.x) / 2 + min.x, (max.y - min.y) / 2 + min.y, 0)
    }
    
    func AllCenter(){
        let (min, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation((max.x - min.x) / 2 + min.x, (max.y - min.y) / 2 + min.y,  (max.z - min.z) / 2 + min.z)
    }
}
//旋轉角度單位改變
extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
