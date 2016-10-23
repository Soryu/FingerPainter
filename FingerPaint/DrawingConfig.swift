import Foundation
import UIKit

protocol DrawingConfig {
    var lineWidth: CGFloat { get }
    var strokeColor: UIColor { get }
}

struct TestDrawingConfig: DrawingConfig {

    let lineWidth: CGFloat
    let strokeColor: UIColor

    init(lineWidth: CGFloat, strokeColor: UIColor) {
        self.lineWidth   = lineWidth
        self.strokeColor = strokeColor
    }
    
}
