//
//  File.swift
//
//
//  Created by Marcus Wittenstam on 2021-11-17.
//

import Foundation
import SwiftUI


extension Path {
    func trimmedPath(for percent: CGFloat) -> Path {
        // percent difference between points
        let boundsDistance: CGFloat = 0.001
        let completion: CGFloat = 1 - boundsDistance
        
        let pct = percent > 1 ? 0 : (percent < 0 ? 1 : percent)
        
        let start = pct > completion ? completion : pct - boundsDistance
        let end = pct > completion ? 1 : pct + boundsDistance
        return trimmedPath(from: start, to: end)
    }
    
    func point(for percent: CGFloat) -> CGPoint {
        let path = trimmedPath(for: percent)
        return CGPoint(x: path.boundingRect.midX, y: path.boundingRect.midY)
    }
    
    func point(to maxX: CGFloat) -> CGPoint {
        let total = length
        let sub = length(to: maxX)
        let percent = sub / total
        return point(for: percent)
    }
    
    var length: CGFloat {
        var ret: CGFloat = 0.0
        var start: CGPoint?
        var point = CGPoint.zero
        
        forEach { ele in
            switch ele {
            case .move(let to):
                if start == nil {
                    start = to
                }
                point = to
            case .line(let to):
                ret += point.line(to: to)
                point = to
            case .quadCurve(let to, let control):
                ret += point.quadCurve(to: to, control: control)
                point = to
            case .curve(let to, _, _):
//            case .curve(let to, let control1, let control2):
//                ret += point.curve(to: to, control1: control1, control2: control2)
//                point = to
                ret += point.line(to: to)
                point = to
            case .closeSubpath:
                if let to = start {
                    ret += point.line(to: to)
                    point = to
                }
                start = nil
            }
        }
        return ret
    }
    
    func length(to maxX: CGFloat) -> CGFloat {
        var ret: CGFloat = 0.0
        var start: CGPoint?
        var point = CGPoint.zero
        var finished = false
        
        forEach { ele in
            if finished {
                return
            }
            switch ele {
            case .move(let to):
                if to.x > maxX {
                    finished = true
                    return
                }
                if start == nil {
                    start = to
                }
                point = to
            case .line(let to):
                if to.x > maxX {
                    finished = true
                    ret += point.line(to: to, x: maxX)
                    return
                }
                ret += point.line(to: to)
                point = to
            case .quadCurve(let to, let control):
                if to.x > maxX {
                    finished = true
                    ret += point.quadCurve(to: to, control: control, x: maxX)
                    return
                }
                ret += point.quadCurve(to: to, control: control)
                point = to
            case .curve(let to, _, _):
//            case .curve(let to, let control1, let control2):
//                if to.x > maxX {
//                    finished = true
//                    ret += point.curve(to: to, control1: control1, control2: control2, x: maxX)
//                    return
//                }
//                ret += point.curve(to: to, control1: control1, control2: control2)
//                point = to
                if to.x > maxX {
                    finished = true
                    ret += point.line(to: to, x: maxX)
                    return
                }
                ret += point.line(to: to)
                point = to
            case .closeSubpath:
                fatalError("Can't include closeSubpath")
            }
        }
        return ret
    }
    
}
