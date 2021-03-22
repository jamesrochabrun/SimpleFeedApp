//
//  UIView+Extension.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/19/21.
//

import UIKit

struct Airbnb {
    static let gradientColors: [UIColor] = [#colorLiteral(red: 1, green: 0.3529411765, blue: 0.3725490196, alpha: 1),#colorLiteral(red: 0, green: 0.6509803922, blue: 0.6, alpha: 1)]
}

enum StrokeGradientDirection {
    
    case vertical
    case horizontal
}

extension UIView {
    
    func setupGradient(cornerRadius: CGFloat, colors: [UIColor] = Airbnb.gradientColors, lineWidth: CGFloat = 5, direction: StrokeGradientDirection = .horizontal, frame: CGRect? = nil) {
        
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        let gradient = CAGradientLayer()
        let frame = frame ?? self.frame
        gradient.frame = CGRect(origin: CGPoint.zero, size: frame.size)
        gradient.colors = colors.map({ (color) -> CGColor in
            color.cgColor
        })
        
        switch direction {
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 1, y: 1)
        case .vertical:
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 0, y: 1)
        }
        
        let shape = CAShapeLayer()
        shape.lineWidth = lineWidth
        shape.path = UIBezierPath(roundedRect: self.bounds.insetBy(dx: lineWidth / 2.0,
                                                                   dy: lineWidth / 2.0), cornerRadius: cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        self.layer.addSublayer(gradient)
    }
    
    func circle(_ frame: CGRect? = nil) {
        self.layer.cornerRadius = (frame ?? self.frame).width / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
    
    func addBorder(_ color: UIColor, width: CGFloat) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
}

