//
//  NotenViewController.swift
//  Noten
//
//  Created by Felix Lösing on 26.02.16.
//  Copyright © 2016 Felix Lösing. All rights reserved.
//

import UIKit

class NotenViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var notenSchnitt: UILabel!
    @IBOutlet weak var anzahl: UILabel!
    
    var notenString = ""
    var notenArray = [Int]()
    var notenAnzahl = 0
    var notenGesamt = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        
        self.navigationController!.navigationBar.translucent = false
        self.tabBarController!.tabBar.translucent = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        notenAnzahl++
        notenArray.append(sender.tag)
        notenGesamt += sender.tag
        
        notenString = ""
        
        for note in notenArray {
            notenString += String(note)+" "
        }
        var notenSchnittDouble: Double = Double(notenGesamt) / Double(notenAnzahl)
        notenSchnittDouble=Double(round(100*notenSchnittDouble)/100)
        
        
        label.text = notenString
        anzahl.text = "\(notenAnzahl)"
        notenSchnitt.text = "\(notenSchnittDouble)"
    }
    
    @IBAction func allClear(sender: AnyObject) {
        notenString = ""
        notenArray.removeAll()
        notenAnzahl = 0
        notenGesamt = 0
        notenSchnitt.text = ""
        anzahl.text = "0"
        label.text = ""
    }

    
    @IBAction func del(sender: AnyObject) {
        if notenAnzahl > 0 {
        
            notenAnzahl--
            notenGesamt -= notenArray.last!
            notenArray.removeLast()
            
            notenString = ""
            
            for note in notenArray {
                notenString += String(note)+" "
            }
            var notenSchnittDouble: Double = Double(notenGesamt) / Double(notenAnzahl)
            notenSchnittDouble=Double(round(100*notenSchnittDouble)/100)
            
            
            label.text = notenString
            anzahl.text = "\(notenAnzahl)"
            notenSchnitt.text = "\(notenSchnittDouble)"
            
            if notenAnzahl == 1 {
                notenSchnitt.text = "\(notenArray.first!)"
            } else if notenAnzahl == 0 {
                notenSchnitt.text = ""
            }

        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
