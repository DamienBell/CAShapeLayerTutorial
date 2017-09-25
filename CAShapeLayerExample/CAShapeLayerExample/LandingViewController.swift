import UIKit

class LandingViewController: UIViewController {
    
    @IBOutlet weak var x1Label: UILabel!
    @IBOutlet weak var y1Label: UILabel!
    @IBOutlet weak var x1Slider: UISlider!
    @IBOutlet weak var y1Slider: UISlider!
    
    @IBOutlet weak var x2Slider: UISlider!
    @IBOutlet weak var y2Slider: UISlider!
    @IBOutlet weak var x2Label: UILabel!
    @IBOutlet weak var y2Label: UILabel!
    
    var shape: CAShapeLayer?
    
    enum Controls: Int {
        case x1
        case y1
        case x2
        case y2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let oneThirdOfHeight = self.view.frame.height * 1/3
        
        self.x1Slider.tag = Controls.x1.rawValue
        self.y1Slider.tag = Controls.y1.rawValue
        self.x2Slider.tag = Controls.x2.rawValue
        self.y2Slider.tag = Controls.y2.rawValue
        
        self.view.backgroundColor = UIColor.black
        self.x1Slider.addTarget( self, action: #selector( self.onSliderChange), for: UIControlEvents.valueChanged)
        self.y1Slider.addTarget( self, action: #selector( self.onSliderChange), for: UIControlEvents.valueChanged)
        self.x2Slider.addTarget( self, action: #selector( self.onSliderChange), for: UIControlEvents.valueChanged)
        self.y2Slider.addTarget( self, action: #selector( self.onSliderChange), for: UIControlEvents.valueChanged)
        
        self.shape = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))

        let x1 = self.view.frame.midX
        let y1 = oneThirdOfHeight * self.view.frame.height
        
        let x2 = self.view.frame.midX
        let y2 = oneThirdOfHeight * self.view.frame.height
        
        path.addCurve(to: CGPoint( x: self.view.frame.minX, y: self.view.frame.maxY), controlPoint1: CGPoint(x: x1, y: y1), controlPoint2: CGPoint(x: x2, y: y2))
        self.shape?.fillColor = UIColor.blue.cgColor
        self.shape?.path = path.cgPath
        if let shape = self.shape {
            self.view.layer.addSublayer( shape)
        }
    }
    
    func onSliderChange( sender: UISlider, forEvent event: UIEvent) {
        let x1 = CGFloat(self.x1Slider.value) * self.view.frame.width
        let y1 = CGFloat(self.y1Slider.value) * self.view.frame.height
        
        let x2 = CGFloat(self.x2Slider.value) * self.view.frame.width
        let y2 = CGFloat(self.y2Slider.value) * self.view.frame.height
        
        print( "(x1, y1): (\( 0), \( 0))  (x2, y2): (\( self.view.frame.minX), \( self.view.frame.maxY)) control1: (\( x1), \( y1)) control2: ( \( x2) \( y2))")
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addCurve(to: CGPoint(x: self.view.frame.minX, y: self.view.frame.maxY), controlPoint1: CGPoint(x: x1, y: y1), controlPoint2: CGPoint(x: x2, y: y2))

        self.shape?.fillColor = UIColor.blue.cgColor
        self.shape?.path = path.cgPath
    }
    
    func generateQuadCurve( xValue: CGFloat, yValue: CGFloat) -> (CGPoint) {
        let x = self.view.frame.width*xValue
        let y = self.view.frame.height*yValue
        
        return CGPoint(x: x, y: y)
    }
}
