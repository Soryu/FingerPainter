import UIKit
import Painter

struct PanState: DrawingState {
    
    let kRadius: CGFloat = 5
    
    let config: DrawingConfig
    let pathGenerator: PathGenerator
    let start: CGPoint
    var end: CGPoint
    var finished: Bool
    var _layer: CAShapeLayer! // could be CALayer composed of multiple shapes?
    
    var layer: CALayer {
        return _layer
    }
    
    var path: UIBezierPath {
        let path = UIBezierPath()
        
        path.addArc(withCenter: start, radius: kRadius, startAngle: 0, endAngle: 2 * CGFloat(M_PI), clockwise: true)

        let linePath = pathGenerator.path(from: start, to: end)
        path.append(linePath)
        
        if finished {
            path.move(to: CGPoint(x: end.x + kRadius, y: end.y))
            path.addArc(withCenter: end, radius: kRadius, startAngle: 0, endAngle: 2 * CGFloat(M_PI), clockwise: true)
        }
        
        return path
    }
    
    init(start: CGPoint, pathGenerator: PathGenerator, config: DrawingConfig) {
        self.start = start
        self.config = config
        self.pathGenerator = pathGenerator

        end = start
        finished = false
        _layer = CAShapeLayer()
        _layer.lineWidth = config.lineWidth
        _layer.strokeColor = config.strokeColor.cgColor
        _layer.fillColor = UIColor.clear.cgColor // implicit, this is a stroke operation
    }
    
    mutating func update(with location: CGPoint) {
        self.end = location
    }
    
    mutating func finish() {
        assert(!finished)
        
        finished = true
    }
    
    func draw(in parentLayer: CALayer) {
        _layer.frame = parentLayer.bounds
        _layer.path = path.cgPath
        parentLayer.addSublayer(_layer)
    }
    
}
