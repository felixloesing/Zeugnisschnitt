//
//  ViewController.swift
//  Noten
//
//  Created by Felix Lösing on 24.02.15.
//  Copyright (c) 2015 Felix Lösing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var notenSchnitt: UILabel!
    @IBOutlet weak var anzahlLabel: UILabel!
    @IBOutlet weak var punkteSchnitt: UILabel!
    
    var punkteGesamt = 0.0
    var punkteAnzahl = 0
    var punkte = 0.0
    let Noten = [6.0, 5.33, 5.00, 4.67, 4.33, 4.00, 3.67, 3.33, 3.00, 2.67, 2.33, 2.00, 1.67, 1.33, 1.00, 0.67]
    var punkteString = ""
    var punkteArray = [Double]()
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.isTranslucent = false
        self.tabBarController!.tabBar.isTranslucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(ViewController.shareTapped))
        
        
        punkteGesamt = defaults.double(forKey: "punkteGesamt")
        punkteAnzahl = defaults.integer(forKey: "punkteAnzahl")
        punkte = defaults.double(forKey: "punkte")
        //punkteString = defaults.objectForKey("punkteString") as! String
        
        punkteArray = defaults.object(forKey: "punkteArray") as? [Double] ?? [Double]()
        
        var notenSchnittDoubleDef = defaults.double(forKey: "notenSchnittDouble")
        var punkteSchnittDoubleDef = defaults.double(forKey: "punkteSchnittDouble")
        
        for punkte in punkteArray {
            let punkteInt = Int(punkte)
            punkteString += String(punkteInt)+" "
        }
        
        
        
        if punkteAnzahl == 0 {
            punkteSchnittDoubleDef = 0.0
            notenSchnittDoubleDef = 0.0
        }
        
        if punkteSchnittDoubleDef == 0.0 {
            notenSchnitt.text = ""
            punkteSchnitt.text = ""
        } else {
            notenSchnitt.text = "\(notenSchnittDoubleDef)"
            punkteSchnitt.text = "\(punkteSchnittDoubleDef)"
        }
        
        label.text = punkteString
        //notenSchnitt.text = "\(notenSchnittDoubleDef)"
        anzahlLabel.text = "\(punkteAnzahl)"
        //punkteSchnitt.text = "\(punkteSchnittDoubleDef)"
        
    }
    
    func shareTapped() {
        
        if punkteAnzahl == 0 {
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
                
                
                let textToShare = "Mein Zeugnisdurchschnitt ist \(notenSchnitt.text!) (Punkte: \(punkteSchnitt.text!))."
                let objectsToShare = [textToShare, image!] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                activityVC.excludedActivityTypes = [UIActivityType.print, UIActivityType.assignToContact,UIActivityType.openInIBooks, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
                    
                self.present(activityVC, animated: true, completion: nil)
            
            }
            
        }
    }
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        punkteAnzahl += 1
        punkteGesamt += Noten[sender.tag]
        punkte += Double(sender.tag)
        punkteArray.append(Double(sender.tag))
        punkteString += String(sender.tag)+"  "
        label.text = punkteString
        var notenSchnittDouble = punkteGesamt / Double(punkteAnzahl)
        notenSchnittDouble=Double(round(100*notenSchnittDouble)/100)
        var punkteSchnittDouble = punkte / Double(punkteAnzahl)
        punkteSchnittDouble=Double(round(100*punkteSchnittDouble)/100)
        notenSchnitt.text = "\(notenSchnittDouble)"
        anzahlLabel.text = "\(punkteAnzahl)"
        punkteSchnitt.text = "\(punkteSchnittDouble)"
        
        
        defaults.set(punkteAnzahl, forKey: "punkteAnzahl")
        defaults.set(punkteGesamt, forKey: "punkteGesamt")
        defaults.set(punkte, forKey: "punkte")
        
        defaults.set(punkteString, forKey: "punkteString")
        
        let punkteArr = punkteArray
        
        defaults.set(punkteArr, forKey: "punkteArray")
        
        defaults.set(notenSchnittDouble, forKey: "notenSchnittDouble")
        defaults.set(punkteSchnittDouble, forKey: "punkteSchnittDouble")
        
    }
    @IBAction func allClear(_ sender: AnyObject) {
        label.text = ""
        notenSchnitt.text = ""
        punkteSchnitt.text = ""
        anzahlLabel.text = "0"
        punkteString = ""
        punkteGesamt = 0.0
        punkte = 0.0
        punkteAnzahl = 0
        punkteArray.removeAll()
        
        
        
        defaults.set(punkteAnzahl, forKey: "punkteAnzahl")
        defaults.set(punkteGesamt, forKey: "punkteGesamt")
        defaults.set(punkte, forKey: "punkte")
        
        defaults.set(punkteString, forKey: "punkteString")
        
        let punkteArr = punkteArray
        
        defaults.set(punkteArr, forKey: "punkteArray")
        
        
    }
    @IBAction func del(_ sender: AnyObject) {
        if punkteAnzahl > 0 {
        
        punkteAnzahl -= 1
        punkteGesamt -= Noten[Int(punkteArray.last!)]
        punkte -= punkteArray.last!
        punkteString = ""
            punkteArray.removeLast()
        for punkt in punkteArray {
            punkteString += String(Int(punkt))+" "
        }
        label.text = punkteString
        var notenSchnittDouble = punkteGesamt / Double(punkteAnzahl)
        notenSchnittDouble=Double(round(100*notenSchnittDouble)/100)
        var punkteSchnittDouble = punkte / Double(punkteAnzahl)
        punkteSchnittDouble=Double(round(100*punkteSchnittDouble)/100)
        notenSchnitt.text = "\(notenSchnittDouble)"
        anzahlLabel.text = "\(punkteAnzahl)"
        punkteSchnitt.text = "\(punkteSchnittDouble)"
            
            if punkteAnzahl == 1 {
                notenSchnitt.text = String(Noten[Int(punkteArray.first!)])
                punkteSchnitt.text = String(punkteArray.first!)
            } else if punkteAnzahl == 0 {
                notenSchnitt.text = ""
                punkteSchnitt.text = ""
            }
        
         
            defaults.set(punkteAnzahl, forKey: "punkteAnzahl")
            defaults.set(punkteGesamt, forKey: "punkteGesamt")
            defaults.set(punkte, forKey: "punkte")
            
            defaults.set(punkteString, forKey: "punkteString")
            
            let punkteArr = punkteArray
            
            defaults.set(punkteArr, forKey: "punkteArray")
            
            defaults.set(notenSchnittDouble, forKey: "notenSchnittDouble")
            defaults.set(punkteSchnittDouble, forKey: "punkteSchnittDouble")
            
        }
        
        
    }
}




