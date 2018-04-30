//
//  Extensions.swift
//  BatteryPlay
//
//  Created by John Allen on 4/29/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

import UIKit
import CoreBluetooth

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}




