//
//  InfoCenter.swift
//  TravelZ
//
//  Created by Justin on 12/17/15.
//  Copyright © 2015 Justin. All rights reserved.
//

import UIKit

class InfoCenter
{

    var playerLost: Bool?
    
    init()
    {
        
    }
    
    func hasPlayerLost() -> Bool
    {
        if (playerLost == nil)
        {
            return false
        }
        else if (playerLost == true)
        {
            return true
        }
        else
        {
            return false
        }
    }
  

}
