//
//  GameViewController.swift
//  53 Hurts
//
//  Created by Zachary Collins on 1/3/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import MultipeerConnectivity

class GameViewController: UIViewController {

    @IBOutlet weak var nearbyUsersTableView: UITableView!
    
    let multipeerController = MultipeerController()
    var nearbyPeers: [MCPeerID] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Setup UITable
        nearbyUsersTableView.delegate   = self
        nearbyUsersTableView.dataSource = self
        
        // Setup MultipeerController
        multipeerController.delegate = self
        multipeerController.advertise(enabled: true)
        multipeerController.browse(enabled: true)
        
        // Setup Scene
        if let view = self.view as! SKView? {
            let scene = GameScene(size: CGSize(width:750, height: 1334))
            scene.scaleMode = .aspectFill
            scene.multipeerController = multipeerController
            
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS            = true
            view.showsNodeCount      = true
        }
    }
    
    
    override var shouldAutorotate: Bool {
        return false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Actions
    @IBAction func connectButtonClicked(_ sender: Any) {
        multipeerController.createSession()
    }
    @IBAction func leftButtonClicked(_ sender: Any) {
    }
    @IBAction func upButtonClicked(_ sender: Any) {
    }
    @IBAction func rightButtonClicked(_ sender: Any) {
    }
    @IBAction func downButtonClicked(_ sender: Any) {
    }
    
}

// Table View Extension
extension GameViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyPeers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = nearbyPeers[indexPath.row].displayName
        let cell = UITableViewCell()
        cell.textLabel?.text = name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MultipeerControllerDelegate Extension
extension GameViewController: MultipeerControllerDelegate{
    func peerFound(nearbyPeers: [MCPeerID]){
        self.nearbyPeers =  nearbyPeers
        nearbyUsersTableView.reloadData()
        print( "peer found" )
    }
    func peerLost( nearbyPeers: [MCPeerID]){
        self.nearbyPeers =  nearbyPeers
        nearbyUsersTableView.reloadData()
        print("peer lost")
    }
    func recieveData(){
        print("data recieved")
    }
}

