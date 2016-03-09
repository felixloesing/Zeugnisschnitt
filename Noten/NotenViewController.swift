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
        
        self.navigationController!.navigationBar.translucent = false
        self.tabBarController!.tabBar.translucent = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareTapped")
        
    }

    
    func shareTapped() {
        
        if notenAnzahl == 0 {
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
                
                
                let textToShare = "Mein Zeugnisdurchschnitt ist \(notenSchnitt.text!)."
                let objectsToShare = [textToShare, image]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                activityVC.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypeAssignToContact,UIActivityTypeOpenInIBooks, UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo]
                
                self.presentViewController(activityVC, animated: true, completion: nil)
        
            }
            
            
        }
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

}
