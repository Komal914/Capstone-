//
//  PlayerViewClass.swift
//  Music2
//
//  Created by Komal Kaur on 3/29/22.
//

import UIKit
import AVKit
import AVFoundation

class PlayerViewClass: UIView {
    
    override static var layerClass: AnyClass {
        
        return AVPlayerLayer.self;
        
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var player: AVPlayer? {
        
        get{
            return playerLayer.player;
            
            
        }
        set {
            playerLayer.player = newValue;
        }
        
    }
}
