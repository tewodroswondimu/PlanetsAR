//
//  ViewController.swift
//  PlanetsAR
//
//  Created by Tewodros Wondimu on 10/28/17.
//  Copyright © 2017 Tewodros Wondimu. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.session.run(configuration)
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let earthNode = SCNNode()
        earthNode.geometry = SCNSphere(radius: 0.2)
        // Apply a texture of earth to the earth node
        // The texture for earth can be found at www.solarsystemscope.com/Textures
        // Once the image has been added to the Assets (New Image Set)
        // Set the asset to the diffuse
        earthNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Earth Day");
        
        // To have the earth reflect light we need to use a specular map
        // The texture for the specular map can also be found at www.solarsystemscope.com/Textures
        // Specular is the color of light that's reflected from the node
        // When the texture is applied to the earth, only the oceans reflect light
        // Apply the asset to the specular
        earthNode.geometry?.firstMaterial?.specular.contents = #imageLiteral(resourceName: "Earth Specular")
        
        // To place clouds over the earth you use an emission map
        // This adds color or content to a surface
        // Apply the asset to the emissions
        earthNode.geometry?.firstMaterial?.emission.contents = #imageLiteral(resourceName: "Earth Clouds")
        
        // To show the contours of the land we can add the earth normal
        // This can also be downloaded from the same website
        // Apply the asset to the normal
        earthNode.geometry?.firstMaterial?.normal.contents = #imageLiteral(resourceName: "Earth Normal")
        
        earthNode.position = SCNVector3(0,0,-1)
        self.sceneView.scene.rootNode.addChildNode(earthNode)
        
        // animate the earth along it's x axis and set duration to 8s
        // SCNAction is similar to eulerangles an animation class that animates the change in structure or
        // display of a node, in this case it is animating the rotation
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 8)
        
        // to make the roation last forever
        let foreverAction = SCNAction.repeatForever(action)
        earthNode.runAction(foreverAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180 }
}
