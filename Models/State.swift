//
//  State.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/30/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import Foundation
import RealmSwift

class State: Object {
    
    dynamic var state:String
    init(gameState: String) {
        state = gameState
    }
}