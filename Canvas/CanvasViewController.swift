//
//  ViewController.swift
//  Canvas
//
//  Copyright © 2018 jmaciel. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    
    @IBOutlet weak var trayView: UIView!
    @IBOutlet weak var excitedImageView: UIImageView!
    
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!

    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trayDownOffset = 160
        trayUp = trayView.center // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset) // The position of the tray transposed down
    }
    
    @IBAction func didTrayPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        var velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            if velocity.y > 0 {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[], animations: { () -> Void in self.trayView.center = self.trayDown }, completion: nil)
            }
            else {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[], animations: { () -> Void in self.trayView.center = self.trayUp }, completion: nil)
            }
        }
    }

    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        print("translation \(translation)")
        
        if sender.state == .began {
            // trayOriginalCenter = trayView.center
            // you shouldn't change the tray view center in the didPanFace and it belongs to the didPanTray
            let imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGesture)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            view.addSubview(newlyCreatedFace)
            
            // Here we use the method didPan(sender:), which we defined in the previous step, as the action.
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
            
            // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(panGestureRecognizer)
        } else if sender.state == .changed {
            //            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y) // don't adjust the tray center
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: view)
        
        if gesture.state == .began {
            
            newlyCreatedFace = gesture.view as? UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
        } else if gesture.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if gesture.state == .ended {
            
        }
    }
    
    @objc func didPan(sender: UIPanGestureRecognizer) {
        //let location = sender.location(in: view)
        //let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            newlyCreatedFace = sender.view as? UIImageView // to get the face that we panned on.
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center // so we can offset by translation later.
        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
        }
    }
}
