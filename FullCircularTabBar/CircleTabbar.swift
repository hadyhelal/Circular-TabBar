//
//  CircleTabbar.swift
//  DalilApp
//
//  Created by Hady on 8/8/23.
//  Copyright © 2023 Hady. All rights reserved.
//

import UIKit

@IBDesignable
class CircleTabbar: UITabBar {    
    
    static var window: UIWindow? {
        UIApplication.shared.windows.filter({$0.isKeyWindow}).first
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
     }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
//        guard let window = window else {
//            return super.sizeThatFits(size)
//        }
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = (window?.safeAreaInsets.bottom ?? 0.0) + 55
        return sizeThatFits
    }

    
    private var shapeLayer: CALayer?
    func addShape(circleCenter: CGFloat? = nil) {
        let center = circleCenter == nil ? self.frame.width / 2 : circleCenter
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath(centerWidth: center!)
       
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        
        shapeLayer.lineWidth = 1.0
        
        //The below 4 lines are for shadow above the bar. you can skip them if you do not want a shadow
        shapeLayer.shadowOffset = CGSize(width:0, height:0)
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowColor = UIColor.gray.cgColor
        shapeLayer.shadowOpacity = 0.3
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.addShape()
    }
    
    func createPath(centerWidth: CGFloat) -> CGPath {
        let height: CGFloat = 37.0
        let path = UIBezierPath()
        //let centerWidth = self.frame.width / 2
        path.move(to: CGPoint(x: 0, y: 0)) // start top left
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0)) // the beginning of the trough

        path.addCurve(to: CGPoint(x: centerWidth, y: height),
        controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height))

        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
        controlPoint1: CGPoint(x: centerWidth + 35, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))

        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()

        return path.cgPath
    }

    func createPathCircle(centerWidth: CGFloat) -> CGPath {

        let radius: CGFloat = 40.0
                
            let path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: [.topLeft, .topRight],
                cornerRadii: CGSize(width: CircleTabbarController.radius, height: 0.0))
        

       // let centerWidth = self.frame.width / 2
        path.move(to: CGPoint(x: 0, y: 0))
       path.addLine(to: CGPoint(x: (centerWidth - radius * 2), y: 0))
        path.addArc(withCenter: CGPoint(x: centerWidth, y: 0), radius: radius, startAngle: CGFloat(180).degreesToRadians, endAngle: CGFloat(0).degreesToRadians, clockwise: false)
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
//        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
//        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path.cgPath
    }
    
}

extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}
