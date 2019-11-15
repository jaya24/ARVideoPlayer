//
//  ViewController.swift
//  ARthingy
//
//  Created by Ata Atasoy on 9.10.2019.
//  Copyright © 2019 Ata Atasoy. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "AR_Resources", bundle: Bundle.main){
            
            configuration.trackingImages = trackedImages
            
            configuration.maximumNumberOfTrackedImages = 3
        }
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let imageAnchor = anchor as? ARImageAnchor,
            let name = imageAnchor.referenceImage.name,
            let fileURLString = Bundle.main.path(forResource: name, ofType: "mov") else {
                return
        }
        
        let videoItem = AVPlayerItem(url: URL(fileURLWithPath: fileURLString))
        let player = AVPlayer(playerItem: videoItem)
        let videoNode = SKVideoNode(avPlayer: player)
        
        player.play()
        //Looping the video
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { (notification) in
            player.seek(to: CMTime.zero)
            player.play()
            print("Looping Video")
        }
        
        
        let videoScene = SKScene(size: CGSize(width: 640, height: 640))
        
        videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
        
        // inverting video so that it does not look upside-down
        videoNode.yScale = -1.0
        
        videoScene.addChild(videoNode)
        // create a plan that has the same real world height and width as our detected image
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
       
        
        plane.firstMaterial?.diffuse.contents = videoScene
        
        let planeNode = SCNNode(geometry: plane)
        // since the created node will be vertical, rotate it along the x axis to have it be horizontal or parallel to our detected image
        planeNode.eulerAngles.x = -Float.pi / 2
        
        node.addChildNode(planeNode)
    }
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if node.isHidden == true {
            if let imageAnchor = anchor as? ARImageAnchor {
                sceneView.session.remove(anchor: imageAnchor)
            }
        }
    }
}
