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
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.isTranslucent = false
        self.tabBarController!.tabBar.isTranslucent = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(NotenViewController.shareTapped))
        
        notenAnzahl = defaults.integer(forKey: "NotenAnzahl")
        notenGesamt = defaults.integer(forKey: "NotenGesamt")
        
        notenArray = defaults.object(forKey: "NotenArray") as? [Int] ?? [Int]()
        
        
        notenString = ""
        
        for note in notenArray {
            notenString += String(note)+" "
        }
        var notenSchnittDouble = 0.0
        if notenAnzahl != 0 {
            notenSchnittDouble = Double(notenGesamt) / Double(notenAnzahl)
            notenSchnittDouble=Double(round(100*notenSchnittDouble)/100)
        }
        
        //notenAnzahl = notenAnzahlDef
        
        label.text = notenString
        anzahl.text = "\(notenAnzahl)"
        if notenSchnittDouble == 0.0 {
            notenSchnitt.text = ""
        } else {
            notenSchnitt.text = "\(notenSchnittDouble)"
        }
        
        
    }

    
    @objc func shareTapped() {
        
        
        if notenString == "" {
            let alert = UIAlertController(title: "Fehler", message: "Bitte trage erst Noten ein, um diese zu teilen.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
        
        let screen = UIScreen.main
        
            if let window = UIApplication.shared.keyWindow {
                UIGraphicsBeginImageContextWithOptions(screen.bounds.size, false, 0);
                window.drawHierarchy(in: window.bounds, afterScreenUpdates: false)
                let image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                
                let textToShare = "Mein Zeugnisdurchschnitt ist \(notenSchnitt.text!)."
                let objectsToShare = [textToShare, image!] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                activityVC.excludedActivityTypes = [UIActivityType.print, UIActivityType.assignToContact,UIActivityType.openInIBooks, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
                
                self.present(activityVC, animated: true, completion: nil)
        
            }
            
            
        }
    }
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        notenAnzahl += 1
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
        
        defaults.set(notenAnzahl, forKey: "NotenAnzahl")
        defaults.set(notenGesamt, forKey: "NotenGesamt")
        
        let notenArr = notenArray
        
        defaults.set(notenArr, forKey: "NotenArray")
    }
    
    @IBAction func allClear(_ sender: AnyObject) {
        notenString = ""
        notenArray.removeAll()
        notenAnzahl = 0
        notenGesamt = 0
        notenSchnitt.text = ""
        anzahl.text = "0"
        label.text = ""
        
        defaults.set(notenAnzahl, forKey: "NotenAnzahl")
        defaults.set(notenGesamt, forKey: "NotenGesamt")
        
        let notenArr = notenArray
        
        defaults.set(notenArr, forKey: "NotenArray")
    }

    
    @IBAction func del(_ sender: AnyObject) {
        
        notenAnzahl = defaults.integer(forKey: "NotenAnzahl")
        notenGesamt = defaults.integer(forKey: "NotenGesamt")
        
        notenArray = defaults.object(forKey: "NotenArray") as? [Int] ?? [Int]()
        
        if notenAnzahl > 0 {
        
            notenAnzahl -= 1
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
            
            defaults.set(notenAnzahl, forKey: "NotenAnzahl")
            defaults.set(notenGesamt, forKey: "NotenGesamt")
            
            let notenArr = notenArray
            
            defaults.set(notenArr, forKey: "NotenArray")

        }
    }

}
