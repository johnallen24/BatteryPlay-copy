//
//  DisplayView.swift
//  BatteryPlay
//
//  Created by John Allen on 2/2/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

import UIKit

//@IBDesignable
class DisplayView: UIView {
    
    var scale1: CGFloat = 0.6
    var scale2 : CGFloat = 0.48
    
    var label: UILabel = UILabel()
    
    override func draw(_ rect: CGRect) {
            
            
            let centerpoint = CGPoint(x: bounds.midX, y: bounds.midY + 50)
            
            
            let outerCircleRadius = min(bounds.size.width, bounds.size.height) / 2.0 * scale1;
            let outerCircleCenter = centerpoint
            let path = UIBezierPath(arcCenter: outerCircleCenter, radius: outerCircleRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
            path.lineWidth = 5
            colorWithHexString(hexString: "#03C03C").set()
            path.fill()
            path.stroke()
            
            
            let innerCircleRadius = min(bounds.size.width, bounds.size.height) / 2.0 * scale2;
            let innerCircleCenter = centerpoint
            let path2 = UIBezierPath(arcCenter: innerCircleCenter, radius: innerCircleRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
            path2.lineWidth = 5
            colorWithHexString(hexString: "#03C03C").set()
            path2.fill()
            path2.stroke()
            
            let rectSize = CGSize(width: 160, height: 120)
            let rectOrigin = CGPoint(x: (centerpoint.x - rectSize.width / 2 ), y: (centerpoint.y - rectSize.height / 2))
            let rectangle = CGRect(origin: rectOrigin, size: rectSize)
            label.frame = frame(forAlignmentRect: rectangle)
            
            label.backgroundColor = colorWithHexString(hexString: "#03C03C")
            // label.center = CGPointMake(160, 284)
            label.textAlignment = .center
            label.baselineAdjustment = .alignCenters
            label.text = "0"
            label.font = UIFont.boldSystemFont(ofSize: 80)
            label.adjustsFontSizeToFitWidth = true
            label.textColor = UIColor.white
            self.addSubview(label)
            
            let rect2Size = CGSize(width: 200, height: 50)
            let rect2Origin = CGPoint(x: centerpoint.x - rect2Size.width/2 , y: (centerpoint.y - (outerCircleRadius + 60)))
            let rectangle2 = CGRect(origin: rect2Origin, size: rect2Size)
            var topLabel = UILabel(frame: rectangle2)
            
            topLabel.textAlignment = .center
            topLabel.backgroundColor = colorWithHexString(hexString: "#E0E0E0")
            topLabel.font = UIFont.boldSystemFont(ofSize: 40.0)
            topLabel.text = "Voltage"
            self.addSubview(topLabel)
        
    }
    
    func colorWithHexString(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }

}
