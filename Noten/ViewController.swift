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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.translucent = false
        self.tabBarController!.tabBar.translucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareTapped")
        
    }
    
    func shareTapped() {
        
        if punkteAnzahl == 0 {
            let alert = UIAlertController(title: "Fehler", message: "Bitte trage erst Noten ein, um diese zu teilen.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
        
            let screen = UIScreen.mainScreen()
            
            if let window = UIApplication.sharedApplication().keyWindow {
                UIGraphicsBeginImageContextWithOptions(screen.bounds.size, false, 0);
                window.drawViewHierarchyInRect(window.bounds, afterScreenUpdates: false)
                let image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                
                let textToShare = "Mein Zeugnisdurchschnitt ist \(notenSchnitt.text!) (Punkte: \(punkteSchnitt.text!))."
                let objectsToShare = [textToShare, image]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                activityVC.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypeAssignToContact,UIActivityTypeOpenInIBooks, UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo]
                    
                self.presentViewController(activityVC, animated: true, completion: nil)
            
            }
            
        }
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        punkteAnzahl++
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
    }
    @IBAction func allClear(sender: AnyObject) {
        label.text = ""
        notenSchnitt.text = ""
        punkteSchnitt.text = ""
        anzahlLabel.text = "0"
        punkteString = ""
        punkteGesamt = 0.0
        punkte = 0.0
        punkteAnzahl = 0
        punkteArray.removeAll()
    }
    @IBAction func del(sender: AnyObject) {
        if punkteAnzahl > 0 {
        
        punkteAnzahl--
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
        
            
        }
    }
}




