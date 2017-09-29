
import UIKit


class SlideViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    
    let contents = [
        "MakeItMobile",
        "Established 2017",
        "Web + Mobile software development",
        "Over 10 years of experience",
        "Make",
        "MakeIt",
        "MakeItMobile"
    ]
    private var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.titleLabel.textColor = UIColor.white
        
        // set gradient background
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [
            UIColor.purple.cgColor,
            UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        // z-index "below" self.view
        gradient.zPosition = -1
        self.view.layer.addSublayer(gradient)

        // one direction per UISwipeGestureRecognizer
        self.addGestureRecognizers( view: self.view)
    }
    
    func addGestureRecognizers( view: UIView) {
        let directions: [UISwipeGestureRecognizerDirection] = [ .up, .down, .left, .right]
        for d in directions {
            let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector( self.onSwipe(gesture:)))
            swipeRecognizer.direction = d
            view.addGestureRecognizer( swipeRecognizer)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated)
        
        self.titleLabel.text = self.contents[ self.counter]
        
        // add layers
        func generatePath( begin: CGPoint, end: CGPoint, ctrl1: CGPoint, ctrl2: CGPoint) -> CGPath {
            let shapePath = UIBezierPath()
            shapePath.move(to: begin)
            shapePath.addCurve(to: end, controlPoint1: ctrl1, controlPoint2: ctrl2)
            
            return shapePath.cgPath
        }
        
        // add 2nd layer
        var offsetX: CGFloat = 0
        let p2 = generatePath(
            begin: CGPoint(x: offsetX, y: 0),
            end: CGPoint(x: offsetX, y: self.view.frame.maxY),
            ctrl1: CGPoint(x: 0.0 + offsetX, y: 462.219284296036),
            ctrl2: CGPoint(x: 318.452373147011 + offsetX, y: 0.0)
        )
        let layer2 = CAShapeLayer()
        if let c = UIColor.blue.cgColor.copy(alpha: 0.50) {
            layer2.fillColor = c
        }
        layer2.path = p2
        layer2.zPosition = -1
        self.view.layer.addSublayer( layer2)
        
        // add 3rd layer
        offsetX = 35
        let p3 = generatePath(
            begin: CGPoint(x: 0, y: 0),
            end: CGPoint(x: 0, y: self.view.frame.maxY),
            ctrl1: CGPoint(x: 0.0 + offsetX, y: 462.219284296036),
            ctrl2: CGPoint(x: 318.452373147011 + offsetX, y: 0.0)
        )
        let layer3 = CAShapeLayer()
        if let c = UIColor.blue.cgColor.copy(alpha: 0.50) {
            layer3.fillColor = c
        }
        layer3.path = p3
        layer3.zPosition = -1
        self.view.layer.addSublayer( layer3)
        
        // add 4rd layer
        offsetX = offsetX + 25
        let p4 = generatePath(
            begin: CGPoint(x: 0, y: 0),
            end: CGPoint(x: 0, y: self.view.frame.maxY),
            ctrl1: CGPoint(x: 0.0 + offsetX, y: 462.219284296036),
            ctrl2: CGPoint(x: 318.452373147011 + offsetX, y: 0.0)
        )
        let layer4 = CAShapeLayer()
        layer4.zPosition = -1
        if let c = UIColor.red.cgColor.copy(alpha: 0.5) {
            layer4.fillColor = c
        }
        layer4.path = p4
        self.view.layer.addSublayer( layer4)
     
        // animate layer4
        let animateToPath = generatePath(
            begin: CGPoint(x: 0, y: 0),
            end: CGPoint(x: 0, y: self.view.frame.maxY),
            ctrl1: CGPoint(x: 0.0 + offsetX - 100, y: 462.219284296036),
            ctrl2: CGPoint(x: 318.452373147011 + offsetX, y: 0.0)
        )
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.duration = 3
        pathAnimation.fromValue = layer4.path
        pathAnimation.toValue = animateToPath
        pathAnimation.fillMode = kCAFillModeBoth
        pathAnimation.isRemovedOnCompletion = false
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        layer4.add( pathAnimation, forKey: pathAnimation.keyPath)
        
        // add circular shapes
        for i in 0..<3 {
            let r = self.view.frame.width * 0.20
            let skewedCircle = UIBezierPath()
            skewedCircle.move(to: CGPoint(x: self.view.frame.width-r, y: 0))
            skewedCircle.addQuadCurve(to: CGPoint(x: self.view.frame.width-r+(2*r), y: 0), controlPoint: CGPoint(x: (self.view.frame.width/2) * 2.15, y: self.view.frame.height * 0.15 * CGFloat( i)))
            let circle = CAShapeLayer()
            if let c = UIColor.purple.cgColor.copy( alpha: 1-(CGFloat( i) * 0.20)) {
                circle.fillColor = c
            }
            circle.path = skewedCircle.cgPath
            circle.zPosition = -1
            self.view.layer.addSublayer( circle)
        }
    }
    
    func onSwipe(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.down:
                counter = counter - 1
                counter = counter < 0 ? self.contents.count-1: counter
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.up:
                counter = counter + 1
                counter = counter > self.contents.count-1 ? 0: counter
                print("Swiped up")
            default:
                print( "Undetected swipe directed: \( swipeGesture.direction)")
                break
            }
        }
        
        self.titleLabel.text = self.contents[ self.counter]
    }
}
