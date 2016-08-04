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

class EasyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var scoresTableView: UITableView!
    
    let textCellIdentifier = "Cell"
    
    var nombre = [String]()
    var pais = [String]()
    var puntaje = [Int]()
    
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        scoresTableView.delegate = self
        scoresTableView.dataSource = self
        
        let firebaseRef = FIRDatabase.database().reference().child("Puntajes").child("Facil")
        loadingIndicator.startAnimating()
        
        firebaseRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let stuff = snapshot.value as? [String: AnyObject] {
                
                
                self.nombre.append(stuff["Nombre"] as! String)
                self.pais.append(stuff["Pais"] as! String)
                self.puntaje.append(stuff["Puntaje"] as! Int)
                
                //                print("Nombre del jugador: \(self.nombre!)")
                //                print("Dificultad de juego: \(self.dificultad!)")
                //                print("Pais de jugador: \(self.pais!)")
                //                print("Puntaje de jugador \(self.puntaje!)")
                print("----------------------------------------")
                self.scoresTableView.reloadData()
                print(self.nombre.count)
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
        print(nombre.count)
        return nombre.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! MyCustomTableViewCell
     
        let row = indexPath.row

        cell.nombreDeJugador.text! = nombre[row]
        cell.nombreDeJugador.textColor = UIColor.whiteColor()
        cell.nombreDeJugador.font = UIFont(name: "VCR OSD Mono", size: 17)
        
        cell.paisDeJugador.text! = pais[row]
        cell.paisDeJugador.textColor = UIColor.whiteColor()
        cell.paisDeJugador.font = UIFont(name: "VCR OSD Mono", size: 17)

        
        //cell.puntajeDeJugador.text! = puntaje[row] as! String
        cell.backgroundColor = UIColor(red:0.17, green:0.16, blue:0.18, alpha:1.0)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(nombre[row])
    }
}



class MyCustomTableViewCell: UITableViewCell {
    @IBOutlet weak var nombreDeJugador: UILabel!
    
    @IBOutlet weak var paisDeJugador: UILabel!
    
    @IBOutlet weak var puntajeDeJugador: UILabel!
    

}
