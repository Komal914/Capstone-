//
//  swipeViewController.swift
//  Music2
//
//  Created by Amogh Kalyan on 3/27/22.
//

import Foundation
import StoreKit
import UIKit
import Parse

class SwipeViewController: UIViewController {
    
    @IBOutlet var card: UIView!
    @IBOutlet var thumbImageView: UIImageView!
    var dividend: CGFloat!
    var ptr = 0
    
    
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var artistPictureView: UIImageView!
    
    var topGenresArr = [String]()
    
    var userGenres = [String]()
    var urlString = "https://api.music.apple.com/v1/catalog/"
    
    var finalURL = String()
    
    override func viewDidLoad() {
        
        // 0.61 is 35 degrees which is the highest extent of rotation needed
        // divide the width of the screen by 2, and then that number by 0.61 to find out how far the x point needs to be in order to be rotated
        genreLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        dividend = (view.frame.width / 2) / 0.61
        
        // store front
        let controller = SKCloudServiceController()
        controller.requestStorefrontCountryCode { countryCode, error in
            // Use the value in countryCode for subsequent API requests
            guard let countryCode = countryCode else {
                return
            }
        
            do {
                //print(countryCode)
                
                let developerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiIsImtpZCI6IjQ1OVlDU0NWN04ifQ.eyJpc3MiOiI0VlMzWEFQWFRWIiwiZXhwIjoxNjYzNTcyNzMzLCJpYXQiOjE2NDc4MDQ3MzN9.J-jb_NnC82o7oSlFvLt84mf7AkNJ3o8Fhhld4ADIDmgY6NfUBVprpD7y1yqX3pjtIUFI85RDxE2yKS12TFmVuA"
                
                self.urlString += countryCode + "/genres"
                
                let url = URL(string: self.urlString as String)!

                var request = URLRequest(url: url)
                request.setValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")

                let session = URLSession.shared
                let task = session.dataTask(with: request) {(data, response, error) in
                    guard let data = data else {
                        return
                    }

                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                        
                        let data = json?["data"] as! [[String:Any]]
                        
                        for i in data {
                            let temp = i
                            //print(temp)
                            let attributes = temp["attributes"] as! NSDictionary
                            let name = attributes["name"] as! String
                            self.topGenresArr.append(name)
                        }
                    }
                    
                    catch {
                        
                    }
                    
                    print(self.topGenresArr)
                    if self.topGenresArr[self.ptr] != "Music" {
                        self.genreLabel.text = self.topGenresArr[self.ptr]
                    }
                    
                    if self.ptr + 1 <= 10 {
                        self.ptr += 1
                    }
                    
                }
                task.resume()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateWelcome()
    }
    
    func animateWelcome() {
        UIView.animate(withDuration: 4.0, animations: {
            self.welcomeLabel.alpha = 1.0
        }, completion: {
            (Completed: Bool) -> Void in
            
            self.welcomeLabel.alpha = 1.0
            
            UIView.animate(withDuration: 2.0, animations: {
                self.welcomeLabel.alpha = 0.0
            }, completion: {
                (Completed: Bool) -> Void in
                
                self.welcomeLabel.text = "Welcome to Aria."
                UIView.animate(withDuration: 4.0, animations: {
                    self.welcomeLabel.alpha = 1.0
                }, completion: {
                    (Completed: Bool) -> Void in
                    
                    UIView.animate(withDuration: 6.0, animations: {
                        self.card.alpha = 1.0
                    })
                    self.card.alpha = 1.0
                    
                })
            })
        })
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
            thumbImageView.image = UIImage(systemName: "hand.thumbsup.fill")
            thumbImageView.tintColor = UIColor.green
        }
        
        else {
            thumbImageView.image = UIImage(systemName: "hand.thumbsdown.fill")
            thumbImageView.tintColor = UIColor.systemRed
        }
        
        thumbImageView.alpha = abs(xFromCenter) / view.center.x
        
        
        // if the user has let go of the card
        if sender.state == UIGestureRecognizer.State.ended {
            
            // if card has moved 75 points to the left
            if card.center.x < 75 {
                // take screen off to the left
                UIView.animate(withDuration: 0.3, animations: {
                    //card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    
                    //print(self.topGenresArr[self.ptr])
                    if self.topGenresArr[self.ptr] != "Music" {
                        self.genreLabel.text = self.topGenresArr[self.ptr]
                    }
                    
                    card.center = self.view.center
                    self.thumbImageView.alpha = 0
                    self.card.alpha = 1
                    self.card.transform = CGAffineTransform.identity
                })
                
                // go to next genre
                if self.ptr + 1 <= 10 {
                    self.ptr += 1
                }
                else {
                    performSegue(withIdentifier: "afterSelection", sender: self)
                    //print(userGenres)
                    
                    //Disliked Preferences ATTEMPT
//                    let dislikedGenres = PFObject(className:"likedGenres")
//                    dislikedGenres["username"] = PFUser.current()?.username
//                    dislikedGenres["genre"] = self.userGenres
//                    dislikedGenres.saveInBackground { (succeeded, error)  in
//                        if (succeeded) {
//                            // The object has been saved.
//                        } else {
//                            print("error on saving data: \(error?.localizedDescription)")
//                        }
//                    }
//
                }
                
                return
            }
            
            // if card has moved 75 points to the right
            else if card.center.x > (view.frame.width - 75) {
                // take screen off to the right
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    
                    if self.topGenresArr[self.ptr] != "Music" {
                        self.genreLabel.text = self.topGenresArr[self.ptr]
                    }
                    self.userGenres.append(self.topGenresArr[self.ptr])
                    
                    card.center = self.view.center
                    self.thumbImageView.alpha = 0
                    self.card.alpha = 1
                    self.card.transform = CGAffineTransform.identity
                })
                
                // go to next genre
                if self.ptr + 1 <= 10 {
                    self.ptr += 1
                }
                
                else {
                    performSegue(withIdentifier: "afterSelection", sender: self)
                    print(userGenres)
                    
                    //Preferences ATTEMPT
                    let likedGenres = PFObject(className:"likedGenres")
                    likedGenres["username"] = PFUser.current()?.username
                    likedGenres["genre"] = self.userGenres
                    likedGenres.saveInBackground { (succeeded, error)  in
                        if (succeeded) {
                            // The object has been saved.
                        } else {
                            print("error on saving data: \(String(describing: error?.localizedDescription))")
                        }
                    }

                }
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
