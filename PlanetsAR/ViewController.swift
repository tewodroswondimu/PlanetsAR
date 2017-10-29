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
        let earthNode = planet(name: "Earth", geometry: SCNSphere(radius: 0.6378), diffuse: #imageLiteral(resourceName: "Earth Day"), specular:  #imageLiteral(resourceName: "Earth Specular"), emission: #imageLiteral(resourceName: "Earth Clouds"), normal: #imageLiteral(resourceName: "Earth Normal"), position: SCNVector3(1.496,0,0), durationAroundSun: 3.652)
    
        // Create the other planet node
        let venusNode = planet(name: "Venus", geometry: SCNSphere(radius: 0.6051), diffuse: #imageLiteral(resourceName: "Venus_diffuse"), specular:  nil, emission: #imageLiteral(resourceName: "Venus_atmosphere"), normal: nil, position: SCNVector3(1.082,0,0), durationAroundSun: 2.246)
        let mercuryNode = planet(name: "Mercury", geometry: SCNSphere(radius: 0.2439), diffuse: #imageLiteral(resourceName: "Mercury_diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(0.579,0,0), durationAroundSun: 1.79)
        let marsNode = planet(name: "Mars", geometry: SCNSphere(radius: 0.3396), diffuse: #imageLiteral(resourceName: "Mars_diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(2.279, 0, 0), durationAroundSun: 6.869)
        let jupiterNode = planet(name: "Jupiter", geometry: SCNSphere(radius: 0.7149), diffuse: #imageLiteral(resourceName: "Jupiter_diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(7.783, 0, 0), durationAroundSun: 43.35)
        let saturnNode = planet(name: "Saturn", geometry: SCNSphere(radius: 0.6026), diffuse: #imageLiteral(resourceName: "Saturn_diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(14.270, 0, 0), durationAroundSun: 107.61)
        let uranusNode = planet(name: "Uranus", geometry: SCNSphere(radius: 0.2555), diffuse: #imageLiteral(resourceName: "Uranus_diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(28.710, 0, 0), durationAroundSun: 307.275)
        let neptuneNode = planet(name: "Neptune", geometry: SCNSphere(radius: 0.2476), diffuse: #imageLiteral(resourceName: "Neptune_diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(44.971, 0, 0), durationAroundSun: 602.380)
        
        print("The names of the planets are \(earthNode.name), \(venusNode.name), \(mercuryNode.name), , \(marsNode.name), \(jupiterNode.name), \(String(describing: saturnNode.name)), \(uranusNode.name) and \(neptuneNode.name)")
        
        let sunNode = SCNNode()
        sunNode.geometry = SCNSphere(radius: 0.40)
        
        sunNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Sun_diffuse")
        sunNode.position = SCNVector3(0, 0, -1)
        self.sceneView.scene.rootNode.addChildNode(sunNode)
        
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 8)
        let forever = SCNAction.repeatForever(action)
        sunNode.runAction(forever)
    }
    
    func planet(name: String, geometry: SCNGeometry, diffuse: UIImage, specular: UIImage?, emission: UIImage?, normal: UIImage?, position: SCNVector3, durationAroundSun: Double) -> SCNNode
    {
        // to enable the planets to rotate around the sun at a different pace than the sun we'll put in its parent node
        // Create a parent node that's located where the sun is
        let planetParentNode = SCNNode()
        // place the planet parent node exactly where the sun in
        planetParentNode.position = SCNVector3(0, 0, -1)
        
        let planetNode = SCNNode()
        let scale = 3.0
        
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
        planetNode.position = SCNVector3(position.x * Float(scale), position.y, position.z)
        
        // If the planet is earth, place a moon on it
        if (name == "Earth") {
            print("Earth Detected")
            _ = satellite(geometry: SCNSphere(radius: 0.05), diffuse: #imageLiteral(resourceName: "Moon_diffuse"), position: SCNVector3(0, 0, -0.93), planetNode: planetNode, planetParentNode: planetParentNode, durationAroundPlanet: 4)
        }
        
        // rotate the planet around themselves
        let planetRotateAction = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 8)
        let rotateForever = SCNAction.repeatForever(planetRotateAction)
        planetNode.runAction(rotateForever)
        
        // Rotate the newly created planet around the planet parent at the given duration
        let planetParentRotateAction = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: durationAroundSun * Double(scale))
        let forever = SCNAction.repeatForever(planetParentRotateAction)
        planetParentNode.runAction(forever)
        
        // Add the new planet to the planet parent node
        planetParentNode.addChildNode(planetNode)
        
        self.sceneView.scene.rootNode.addChildNode(planetParentNode)
        
        return planetNode;
    }
    
    func satellite(geometry: SCNSphere, diffuse: UIImage, position: SCNVector3, planetNode: SCNNode, planetParentNode: SCNNode, durationAroundPlanet: Double) {
        let satelliteParentNode = SCNNode()
        let satelliteNode = SCNNode()
        satelliteParentNode.position = planetNode.position
        satelliteNode.position = position
        satelliteNode.geometry = geometry
        satelliteNode.geometry?.firstMaterial?.diffuse.contents = diffuse
        // rotate the satellite around themselves
        let satelliteRotateAction = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: durationAroundPlanet/4)
        let rotateForever = SCNAction.repeatForever(satelliteRotateAction)
        satelliteNode.runAction(rotateForever)
        // Rotate the newly created planet around the planet parent at the given duration
        let satelliteParentRotateAction = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: durationAroundPlanet)
        let forever = SCNAction.repeatForever(satelliteParentRotateAction)
        satelliteParentNode.runAction(forever)
        satelliteParentNode.addChildNode(satelliteNode)
        planetParentNode.addChildNode(satelliteParentNode)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180 }
}
