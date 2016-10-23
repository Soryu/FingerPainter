import Foundation
import CoreGraphics

public protocol PathGenerator {
    func path(from start: CGPoint, to end: CGPoint) -> UIBezierPath
}

public struct StraightPathGenerator: PathGenerator {
    
    public init() {}
    
    public func path(from start: CGPoint, to end: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
}


public struct AngularPathGenerator: PathGenerator {
    
    let preferX: Bool
    
    public init(preferX: Bool) {
        self.preferX = preferX
    }
    
    public func path(from start: CGPoint, to end: CGPoint) -> UIBezierPath {
        
        var middle: CGPoint?
        
        if preferX && start.y != end.y {
            middle = CGPoint(x: end.x, y: start.y)
        } else if !preferX && start.x != end.x {
            middle = CGPoint(x: start.x, y: end.y)
        }
        
        let path = UIBezierPath()
        path.move(to: start)
        if let middle = middle {
            path.addLine(to: middle)
        }
        path.addLine(to: end)
        return path
    }
    
}

public struct ArcedPathGenerator: PathGenerator {
    public func path(from start: CGPoint, to end: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: start)
        
        // TODO: this is quite complicated!
        
//        path.addArc(withCenter: center,
//                    radius: radius,
//                    startAngle: <#T##CGFloat#>,
//                    endAngle: <#T##CGFloat#>,
//                    clockwise: true)
        return path
    }
}

public struct CurvedPathGenerator: PathGenerator {
    
    public init() {}
    
    public func path(from start: CGPoint, to end: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: start)
        
        let control = CGPoint(x: start.x, y: end.y)
        path.addQuadCurve(to: end, controlPoint: control)
        return path
    }
}



