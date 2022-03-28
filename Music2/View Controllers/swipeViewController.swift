//
//  swipeViewController.swift
//  Music2
//
//  Created by Amogh Kalyan on 3/27/22.
//

import Foundation
import UIKit

class SwipeViewController: UIViewController {
    
    @IBOutlet var card: UIView!
    @IBOutlet var thumbImageView: UIImageView!
    var dividend: CGFloat!
    
    override func viewDidLoad() {
        
        // 0.61 is 35 degrees which is the highest extent of rotation needed
        // divdee the width of the screen by 2, and then that number by 0.61 to find out how far the x point needs to be in order to be rotated
        dividend = (view.frame.width / 2) / 0.61
    }
    
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        // card is set onto the view of screen, point is where the card is on the screen
        let card = sender.view!
        let point = sender.translation(in: view)
        
        // xFromCenter is a point that is used to understand how far the x point of the card is from the center of the screen
        let xFromCenter = card.center.x - view.center.x
        let scale = min(100 / abs(xFromCenter), 1)
        
        
        
        // center of card is set to wherever the user drags it, making it able to move
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / dividend).scaledBy(x: scale, y: scale)
        
        if xFromCenter > 0 {
            thumbImageView.image = UIImage(named: "thumbsup")
            thumbImageView.tintColor = UIColor.green
        }
        
        else {
            thumbImageView.image = UIImage(named: "thumbsdown")
            thumbImageView.tintColor = UIColor.systemRed
        }
        
        //
        thumbImageView.alpha = abs(xFromCenter) / view.center.x
        
        
        // if the user has let go of the card
        if sender.state == UIGestureRecognizer.State.ended {
            
            // if card has moved 75 points to the left
            if card.center.x < 75 {
                // take screen off to the left
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                })
                
                performSegue(withIdentifier: "afterSelection", sender: self)
                return
            }
            
            // if card has moved 75 points to the right
            else if card.center.x > (view.frame.width - 75) {
                // take screen off to the right
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                })
                performSegue(withIdentifier: "afterSelection", sender: self)
                return
            }
            
            // if user has not gone 75 points in either direction
            UIView.animate(withDuration: 0.2, animations: {
                // return card to center of view
                card.center = self.view.center
                self.thumbImageView.alpha = 0
                self.card.alpha = 1
                self.card.transform = CGAffineTransform.identity
            })
        }
    }
    
    
    
    
    
}
