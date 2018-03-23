//
//  ViewController.swift
//  IOS-Swift-ARKitHitPingPongBall
//
//  Created by Pooya Hatami on 2018-03-21.
//  Copyright © 2018 Pooya Hatami. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var ball = SCNNode()
    var box = SCNNode()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        //sceneView.allowsCameraControl = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/MainScene.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let wait:SCNAction = SCNAction.wait(duration: 3)
        let runAfter:SCNAction = SCNAction.run { _ in
            
            self.addSceneContent()
        }
        let seq:SCNAction = SCNAction.sequence([wait, runAfter])
        sceneView.scene.rootNode.runAction(seq)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap( sender: UITapGestureRecognizer){
        
       // guard let sceneView = sender.view as? ARSCNView else {return}
        let touchLocation = sender.location(in: sceneView)
        let hitTestResult = sceneView.hitTest(touchLocation, options: [:])
        if !hitTestResult.isEmpty {
            for hitResult in hitTestResult {
                
                //print(hitResult.node.name)
                
                if (hitResult.node == ball) {
                    
                    ball.physicsBody?.applyForce(SCNVector3(0,2,0), asImpulse: true)
                    
                } else if hitResult.node == box {
                    
                    ball.position = SCNVector3(0, 5 , 1 )
                    
                }
            }
        }
        
    }
    
    
    func addSceneContent(){
        let dummyNode = self.sceneView.scene.rootNode.childNode(withName: "DummyNode", recursively: false)
        dummyNode?.position = SCNVector3(0 , -5 , -5)
        
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if ( node.name == "ball" ) {
                print("Found Ball")
                
                ball = node
                ball.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "ballPatternTexture01")
                ball.physicsBody = SCNPhysicsBody(type: .dynamic , shape: SCNPhysicsShape(node: ball, options: nil))
                ball.physicsBody?.isAffectedByGravity = true
                ball.physicsBody?.restitution = 1
                
            } else if ( node.name == "box") {
                
                print("Found Box")
                
                box = node
                box.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "PPTableGreen01")
                let boxGeometory = box.geometry
                let boxShape: SCNPhysicsShape = SCNPhysicsShape(geometry: boxGeometory!, options: nil)
                box.physicsBody = SCNPhysicsBody(type: .static , shape: boxShape)
                box.physicsBody?.restitution = 1
            }
        }
        
        
        let light = SCNLight()
        light.type = SCNLight.LightType.omni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 1.5 , y: 1.5 , z: 1.5)
        self.sceneView.scene.rootNode.addChildNode(lightNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
       
        // self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints, SCNDebugOptions.showPhysicsShapes ]
        
       // configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
