import UIKit
import Painter

//enum state {
//    case pan(PanState)
//}

enum SegmentToGenerator: Int {
    case straight
    case curved
    case angularX
    case angularY
    
    func generator() -> PathGenerator {
        switch self {
        case .straight:
            return StraightPathGenerator()
        case .curved:
            return CurvedPathGenerator()
        case .angularX:
            return AngularPathGenerator(preferX: true)
        case .angularY:
            return AngularPathGenerator(preferX: false)
        }
    }
    
    static var count: Int {
        return 4
    }
    
    var title: String {
        switch self {
        case .straight:
            return "straight"
        case .curved:
            return "curved"
        case .angularX:
            return "ang x"
        case .angularY:
            return "ang y"
        }
    }
}

class ViewController: UIViewController {

    var config: DrawingConfig!
    var drawingLayer: CALayer!

    var pan: PanState?

    // UI
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config = TestDrawingConfig(lineWidth: 2.0, strokeColor: randomColor())
        drawingLayer = contentView.layer
        
        segmentControl.removeAllSegments()
        for i in 0..<SegmentToGenerator.count {
            guard let foo = SegmentToGenerator(rawValue: i) else { continue }
            segmentControl.insertSegment(withTitle: foo.title, at: segmentControl.numberOfSegments, animated: false)
        }
        segmentControl.selectedSegmentIndex = 0
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(panRecognized(_:)))
        contentView.addGestureRecognizer(recognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    dynamic func panRecognized(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: recognizer.view)
        
        switch recognizer.state {
        case .began:
            config = TestDrawingConfig(lineWidth: 2.0, strokeColor: randomColor())
            pan = PanState(start: location, pathGenerator: pathGeneratorForSettings(), config: config)
            pan?.draw(in: drawingLayer)
        case .changed:
            pan?.update(with: location)
            pan?.draw(in: drawingLayer)
        case .ended:
            pan?.finish()
            pan?.draw(in: drawingLayer)
            pan = nil
        case .failed, .cancelled:
            pan = nil
        default: break
        }
    }
    
    private func randomColor() -> UIColor {
        let hue = CGFloat(arc4random_uniform(100)) / 100
        return UIColor(hue: hue, saturation: 0.9, brightness: 0.9, alpha: 1.0)
    }
    
    private func pathGeneratorForSettings() -> PathGenerator {
        let index = segmentControl.selectedSegmentIndex
        if let foo = SegmentToGenerator(rawValue: index) {
            return foo.generator()
        }
        
        return StraightPathGenerator()
    }
}

