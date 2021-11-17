//
//  File.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-17.
//

import Foundation
import SwiftUI

extension CGPoint {
    func point(to: CGPoint, x: CGFloat) -> CGPoint {
        let a = (to.y - self.y) / (to.x - self.x)
        let y = self.y + (x - self.x) * a
        return CGPoint(x: x, y: y)
    }
    
    func line(to: CGPoint) -> CGFloat {
        dist(to: to)
    }
    
    func line(to: CGPoint, x: CGFloat) -> CGFloat {
        dist(to: point(to: to, x: x))
    }
    
    func quadCurve(to: CGPoint, control: CGPoint) -> CGFloat {
        var dist: CGFloat = 0
        let steps: CGFloat = 100
        
        for i in 0..<Int(steps) {
            let t0 = CGFloat(i) / steps
            let t1 = CGFloat(i+1) / steps
            let a = point(to: to, t: t0, control: control)
            let b = point(to: to, t: t1, control: control)
            
            dist += a.line(to: b)
        }
        return dist
    }
    
    func quadCurve(to: CGPoint, control: CGPoint, x: CGFloat) -> CGFloat {
        var dist: CGFloat = 0
        let steps: CGFloat = 100
        
        for i in 0..<Int(steps) {
            let t0 = CGFloat(i) / steps
            let t1 = CGFloat(i+1) / steps
            let a = point(to: to, t: t0, control: control)
            let b = point(to: to, t: t1, control: control)
            
            if a.x >= x {
                return dist
            } else if b.x > x {
                dist += a.line(to: b, x: x)
                return dist
            } else if b.x == x {
                dist += a.line(to: b)
                return dist
            }
            
            dist += a.line(to: b)
        }
        return dist
    }
    
    func point(to: CGPoint, t: CGFloat, control: CGPoint) -> CGPoint {
        let x = CGPoint.value(x: self.x, y: to.x, t: t, c: control.x)
        let y = CGPoint.value(x: self.y, y: to.y, t: t, c: control.y)
        
        return CGPoint(x: x, y: y)
    }
    
    func curve(to: CGPoint, control1: CGPoint, control2: CGPoint) -> CGFloat {
        var dist: CGFloat = 0
        let steps: CGFloat = 100
        
        for i in 0..<Int(steps) {
            let t0 = CGFloat(i) / steps
            let t1 = CGFloat(i+1) / steps
            
            let a = point(to: to, t: t0, control1: control1, control2: control2)
            let b = point(to: to, t: t1, control1: control1, control2: control2)
            
            dist += a.line(to: b)
        }
        
        return dist
    }
    
    func curve(to: CGPoint, control1: CGPoint, control2: CGPoint, x: CGFloat) -> CGFloat {
        var dist: CGFloat = 0
        let steps: CGFloat = 100
        
        for i in 0..<Int(steps) {
            let t0 = CGFloat(i) / steps
            let t1 = CGFloat(i+1) / steps
            
            let a = point(to: to, t: t0, control1: control1, control2: control2)
            let b = point(to: to, t: t1, control1: control1, control2: control2)
            
            if a.x >= x {
                return dist
            } else if b.x > x {
                dist += a.line(to: b, x: x)
                return dist
            } else if b.x == x {
                dist += a.line(to: b)
                return dist
            }
            
            dist += a.line(to: b)
        }
        
        return dist
    }
    
    func point(to: CGPoint, t: CGFloat, control1: CGPoint, control2: CGPoint) -> CGPoint {
        let x = CGPoint.value(x: self.x, y: to.x, t: t, c1: control1.x, c2: control2.x)
        let y = CGPoint.value(x: self.y, y: to.y, t: t, c1: control1.y, c2: control2.x)
        
        return CGPoint(x: x, y: y)
    }
    
    static func value(x: CGFloat, y: CGFloat, t: CGFloat, c: CGFloat) -> CGFloat {
        var value: CGFloat = 0.0
        // (1-t)^2 * p0 + 2 * (1-t) * t * c1 + t^2 * p1
        value += pow(1-t, 2) * x
        value += 2 * (1-t) * t * c
        value += pow(t, 2) * y
        return value
    }
    
    static func value(x: CGFloat, y: CGFloat, t: CGFloat, c1: CGFloat, c2: CGFloat) -> CGFloat {
        var value: CGFloat = 0.0
        // (1-t)^3 * p0 + 3 * (1-t)^2 * t * c1 + 3 * (1-t) * t^2 * c2 + t^3 * p1
        value += pow(1-t, 3) * x
        value += 3 * pow(1-t, 2) * t * c1
        value += 3 * (1-t) * pow(t, 2) * c2
        value += pow(t, 3) * y
        return value
    }
    
    static func getMidPoint(point1: CGPoint, point2: CGPoint) -> CGPoint {
        return CGPoint(
            x: point1.x + (point2.x - point1.x) / 2,
            y: point1.y + (point2.y - point1.y) / 2
        )
    }
    
    func dist(to: CGPoint) -> CGFloat {
        return sqrt((pow(self.x - to.x, 2) + pow(self.y - to.y, 2)))
    }
    
    static func midPointForPoints(p1:CGPoint, p2:CGPoint) -> CGPoint {
        return CGPoint(x:(p1.x + p2.x) / 2,y: (p1.y + p2.y) / 2)
    }
    
    static func controlPointForPoints(p1:CGPoint, p2:CGPoint) -> CGPoint {
        var controlPoint = CGPoint.midPointForPoints(p1:p1, p2:p2)
        let diffY = abs(p2.y - controlPoint.y)
        
        if (p1.y < p2.y){
            controlPoint.y += diffY
        } else if (p1.y > p2.y) {
            controlPoint.y -= diffY
        }
        return controlPoint
    }
}
