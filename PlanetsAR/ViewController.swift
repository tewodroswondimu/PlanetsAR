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
        // Create an earth node
        let earthNode = planet(geometry: SCNSphere(radius: 0.2), diffuse: #imageLiteral(resourceName: "Earth Day"), specular:  #imageLiteral(resourceName: "Earth Specular"), emission: #imageLiteral(resourceName: "Earth Clouds"), normal: #imageLiteral(resourceName: "Earth Normal"), position: SCNVector3(1.2,0,0))
        
        // Create the other planet node
        let venusNode = planet(geometry: SCNSphere(radius: 0.1), diffuse: #imageLiteral(resourceName: "Venus_diffuse"), specular:  nil, emission: #imageLiteral(resourceName: "Venus_atmosphere"), normal: nil, position: SCNVector3(0.7,0,0))
        /*
        let mercuryNode = planet(geometry: SCNSphere(radius: 0.1), diffuse: #imageLiteral(resourceName: "Mercury_diffuse"), specular: nil, emission: nil, normal: nil, position: <#T##SCNVector3#>)
        let marsNode = planet(geometry: <#T##SCNGeometry#>, diffuse: #imageLiteral(resourceName: "Mars_diffuse"), specular: nil, emission: nil, normal: nil, position: <#T##SCNVector3#>)
        let jupiterNode = planet(geometry: <#T##SCNGeometry#>, diffuse: #imageLiteral(resourceName: "Jupiter_diffuse"), specular: nil, emission: nil, normal: nil, position: <#T##SCNVector3#>)
        let saturnNode = planet(geometry: <#T##SCNGeometry#>, diffuse: #imageLiteral(resourceName: "Saturn_diffuse"), specular: nil, emission: nil, normal: nil, position: <#T##SCNVector3#>)
        let uranusNode = planet(geometry: <#T##SCNGeometry#>, diffuse: #imageLiteral(resourceName: "Uranus_diffuse"), specular: nil, emission: nil, normal: nil, position: <#T##SCNVector3#>)
        let neptuneNode = planet(geometry: <#T##SCNGeometry#>, diffuse: #imageLiteral(resourceName: "Neptune_diffuse"), specular: nil, emission: nil, normal: nil, position: <#T##SCNVector3#>)*/
        
        let sunNode = SCNNode()
        sunNode.geometry = SCNSphere(radius: 0.35)
        
        sunNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Sun_diffuse")
        sunNode.position = SCNVector3(0, 0, -1)
        self.sceneView.scene.rootNode.addChildNode(sunNode)
        
        sunNode.addChildNode(earthNode)
        sunNode.addChildNode(venusNode)
    }
    
    func planet(geometry: SCNGeometry, diffuse: UIImage, specular: UIImage?, emission: UIImage?, normal: UIImage?, position: SCNVector3) -> SCNNode
    {
        let planetNode = SCNNode()
        
        planetNode.geometry = geometry;
        
        // Apply a texture of earth to the earth node
        // The texture for earth can be found at www.solarsystemscope.com/Textures
        // Once the image has been added to the Assets (New Image Set)
        // Set the asset to the diffuse
        planetNode.geometry?.firstMaterial?.diffuse.contents = diffuse;
        
        // To have the earth reflect light we need to use a specular map
        // The texture for the specular map can also be found at www.solarsystemscope.com/Textures
        // Specular is the color of light that's reflected from the node
        // When the texture is applied to the earth, only the oceans reflect light
        // Apply the asset to the specular
        planetNode.geometry?.firstMaterial?.specular.contents = specular
        
        // To place clouds over the earth you use an emission map
        // This adds color or content to a surface
        // Apply the asset to the emissions
        planetNode.geometry?.firstMaterial?.emission.contents = emission
        
        // To show the contours of the land we can add the earth normal
        // This can also be downloaded from the same website
        // Apply the asset to the normal
        planetNode.geometry?.firstMaterial?.normal.contents = normal
        
        // set the position of the planet relative to the sun
        planetNode.position = position
        
        return planetNode;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180 }
}
