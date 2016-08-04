//
//  EasyViewController.swift
//  Space Fighter
//
//  Created by Gonzalo Caballero on 8/3/16.
//  Copyright © 2016 Gonzalo Caballero. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var scoresTableView: UITableView!
    
    let textCellIdentifier = "Cell"
    
    var nombre = [String]()
    var pais = [String]()
    var puntaje = [Int]()
    
    var players = [Player]()
    var sortedPlayers = [Player]()
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    struct Player {
        var nameOfPlayer : String
        var countryOfPlayer : String
        var scoreOfPlayer : Int
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        scoresTableView.delegate = self
        scoresTableView.dataSource = self
        
        let firebaseRef = FIRDatabase.database().reference().child("Puntajes").child("Dificil")
        loadingIndicator.startAnimating()
        
        firebaseRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let stuff = snapshot.value as? [String: AnyObject] {
                
                let nombreDejugador = stuff["Nombre"] as! String
                let paisDeJugador = stuff["Pais"] as! String
                let puntajeDeJugador = stuff["Puntaje"] as! Int
                
                let player = Player(nameOfPlayer: nombreDejugador, countryOfPlayer: paisDeJugador, scoreOfPlayer: puntajeDeJugador)
                
                self.players.append(player)
                
                self.sortedPlayers = self.players.sort({ (a, b) -> Bool in
                    return a.scoreOfPlayer > b.scoreOfPlayer
                })
                
                self.scoresTableView.reloadData()
                self.loadingIndicator.stopAnimating()
                
                
            }
        })
        
        scoresTableView.backgroundColor = UIColor(red:0.17, green:0.16, blue:0.18, alpha:1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedPlayers.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! HardTableViewCell
        
        let row = indexPath.row
        
        cell.nombreDeJugador.text! = sortedPlayers[row].nameOfPlayer
        cell.nombreDeJugador.textColor = UIColor.whiteColor()
        cell.nombreDeJugador.font = UIFont(name: "VCR OSD Mono", size: 17)
        
        cell.paisDeJugador.text! = sortedPlayers[row].countryOfPlayer
        cell.paisDeJugador.textColor = UIColor.whiteColor()
        cell.paisDeJugador.font = UIFont(name: "VCR OSD Mono", size: 17)
        
        cell.puntajeDeJugador.text! = "\(sortedPlayers[row].scoreOfPlayer)"
        cell.puntajeDeJugador.textColor = UIColor.whiteColor()
        cell.puntajeDeJugador.font = UIFont(name: "VCR OSD Mono", size: 17)
        
        
        cell.backgroundColor = UIColor(red:0.17, green:0.16, blue:0.18, alpha:1.0)
        
        return cell
    }
}



class HardTableViewCell: UITableViewCell {
    @IBOutlet weak var nombreDeJugador: UILabel!
    
    @IBOutlet weak var paisDeJugador: UILabel!
    
    @IBOutlet weak var puntajeDeJugador: UILabel!
    
    
}
