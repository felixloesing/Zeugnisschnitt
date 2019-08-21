//
//  ViewController.swift
//  Noten
//
//  Created by Felix Lösing on 24.02.15.
//  Copyright (c) 2015 Felix Lösing. All rights reserved.
//

import UIKit
import StoreKit

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
    
    var startUps = 0
    var promptForReview = false
    var reviewTimer : Timer?
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //prompt for review after a certain count of new app launches
        startUps = defaults.integer(forKey: "startUps")
        startUps = startUps+1
        if startUps == 3 || startUps == 6 || startUps == 9 || startUps == 28 {
            promptForReview = true
        }
        defaults.set(startUps, forKey: "startUps")
        print(startUps)
        
        
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
    
    @objc func shareTapped() {
        
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
                
                activityVC.excludedActivityTypes = [UIActivity.ActivityType.print, UIActivity.ActivityType.assignToContact,UIActivity.ActivityType.openInIBooks, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToVimeo]
                    
                self.present(activityVC, animated: true, completion: nil)
            
            }
            
        }
    }
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        
        //destroy old timer
        if reviewTimer != nil {
            reviewTimer?.invalidate()
            //reviewTimer = nil
        }
        
        
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
        
        //iOS Review Prompt after not clicking between 20 and 30 sec.
        if promptForReview == true {
            let shortestTime: UInt32 = 20
            let longestTime: UInt32 = 30
            let timeInterval = TimeInterval(exactly: arc4random_uniform(longestTime - shortestTime) + shortestTime)
            
            //if reviewTimer != nil {
                reviewTimer = Timer.scheduledTimer(timeInterval: timeInterval!, target: self, selector: #selector(requestReview), userInfo: nil, repeats: false)
            //}
        }
        
    }
    
    @objc func requestReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            // Fallback on earlier versions
        }
        print("prompted for review @startup=")
        print(startUps)
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




