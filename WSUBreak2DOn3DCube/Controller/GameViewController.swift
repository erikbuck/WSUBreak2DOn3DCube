//
//  GameViewController.swift
//  WSUVid3
//
//  Created by Erik Buck on 10/2/19.
//  Copyright © 2019 WSU. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit


class GameViewController: UIViewController, SCNSceneRendererDelegate {
   var skscene : BreakScene?

   func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
      skscene?.update(time)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // create a new scene
      let scene = SCNScene(named: "art.scnassets/cube.scn")!
      
      // create and add a camera to the scene
      let cameraNode = SCNNode()
      cameraNode.camera = SCNCamera()
      scene.rootNode.addChildNode(cameraNode)
      
      // place the camera
      cameraNode.position = SCNVector3(x: 0, y: 0, z: 7)
      
      // create and add a light to the scene
      let lightNode = SCNNode()
      lightNode.light = SCNLight()
      lightNode.light!.type = .omni
      lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
      scene.rootNode.addChildNode(lightNode)
      
      // create and add an ambient light to the scene
      let ambientLightNode = SCNNode()
      ambientLightNode.light = SCNLight()
      ambientLightNode.light!.type = .ambient
      ambientLightNode.light!.color = UIColor.lightGray
      scene.rootNode.addChildNode(ambientLightNode)
      
      // retrieve the cube node
      let cube = scene.rootNode.childNode(withName: "Cube", recursively: true)!
      
      // Animate cube
      cube.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 1, y: 1, z: 1,
                                                                duration: 4)))
      
      // Load SKScene to use as texture in SCNScene
      skscene = BreakScene(fileNamed: "BreakScene")
      skscene!.setup()
      skscene!.scaleMode = .aspectFill
      skscene!.isPaused = false

      // Use skscene as material on cube
      let material = cube.geometry!.firstMaterial!
      material.diffuse.contents = skscene
      
      // retrieve the SCNView
      let scnView = self.view as! SCNView
      
      scnView.scene = scene
      scnView.showsStatistics = true
      scnView.backgroundColor = UIColor.black
      scnView.delegate = self
      
   }
   
   override var shouldAutorotate: Bool {
      return true
   }
   
   override var prefersStatusBarHidden: Bool {
      return true
   }
   
   override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
      if UIDevice.current.userInterfaceIdiom == .phone {
         return .allButUpsideDown
      } else {
         return .all
      }
   }
   
   @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
      // 1
      let translation = gesture.translation(in: view)
      let newPosition = CGPoint(
         x: translation.x,
         y: translation.y
      )
      skscene?.touchMoved(toPoint: newPosition)
   }
   
}
