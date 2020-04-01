//
//  Extensions.swift
//  MGCalendar
//
//  Created by nawal amallou on 01/04/2020.
//  Copyright © 2020 nawal amallou. All rights reserved.
//

import UIKit


extension UIView{
    
    var xPos : CGFloat {
        get {
            return frame.origin.x
        }
    }
    
    var yPos : CGFloat {
        get {
            return frame.origin.y
        }
    }
    
    var height: CGFloat {
        get {
            return frame.height
        }
    }
    
    var width: CGFloat {
        get {
            return frame.width
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
    
    func applyGradient(colors: [UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors.map{ return $0.cgColor }
        gradient.locations = [0.0, 1.0]
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func addShadow(color: UIColor,opacity: Float,radius: CGFloat){
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
//        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        layer.shadowOffset = CGSize(width: 5, height: -5)
        layer.shadowRadius = radius
    }
    
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
