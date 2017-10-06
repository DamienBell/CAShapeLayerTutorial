import UIKit


class SwipeableViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private var shapes: [CAShapeLayer: [ CGPath]] = [:]
    private var index = 0

    private let contents = [
        "MakeItMobile",
        "Established 2017",
        "Web + Mobile software development",
        "iOS",
        "React.js",
        "Node.js",
        "Postgres",
        "ElasticSearch",
        "RabbitMQ",
        "Hire Us! hello@makeitmobile.co"
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated)
        
        func initialize( paths: [ CGPath]) {
            let shape = CAShapeLayer()
            let alpha = CGFloat( arc4random_uniform( UInt32( 25))) / 100.0
            shape.fillColor = UIColor.triadColor.cgColor.copy(alpha: alpha)
            shape.zPosition = -1
            shape.path = paths.first
            self.view.layer.addSublayer( shape)
            
            // save to our internal structure
            self.shapes[ shape] = paths
        }
        
        // 375 x 667, iPhone 6s
        let forWidth: CGFloat = 375
        let forHeight: CGFloat = 667
        
        // setup shapes
        (0..<15).forEach{ _ -> Void in
            // generate paths
            let paths = self.shuffle( paths:
                
                Array( 0..<self.contents.count).map{ _ -> CGPath in
                    return self.generatePath(
                        begin: CGPoint.zero,
                        end: CGPoint(x: ((150/forWidth)*self.view.frame.width), y: self.view.frame.maxY),
                        ctrl1: self.randomize( point: CGPoint(x: ((100/forWidth)*self.view.frame.width), y: ((80/forHeight)*self.view.frame.height)), maxX: self.view.frame.width*0.50),
                        ctrl2: self.randomize( point: CGPoint(x: ((15/forWidth)*self.view.frame.width), y: ((150/forHeight)*self.view.frame.height)))
                    )
                })
            
            initialize( paths: paths)
        }
        
        (0..<15).forEach{ _ -> Void in
            // generate paths
            let circlePaths = Array( 0..<self.contents.count).map{ _ -> CGPath in
                let r = self.view.frame.width * 0.20
                return self.generatePath(
                    begin: CGPoint(x: self.view.frame.width-r*3, y: 0),
                    end: CGPoint(x: self.view.frame.width-r+(2*r), y: self.view.frame.height*1.25),
                    ctrl1: self.randomize( point: CGPoint(x: self.view.frame.width * 1.15, y: self.view.frame.height * 0.15))
                )
            }
            
            initialize( paths: circlePaths)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set gradient background
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [
            UIColor.purple.cgColor,
            UIColor.fromRGB(red: 244, green: 88, blue: 53, alpha: 0.75).cgColor
        ]
        // top left to bottom right
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        // z-index "below" self.view
        gradient.zPosition = -1
        self.view.layer.addSublayer(gradient)

        // register swipe gestures
        self.addGestureRecognizers(view: self.view)
        self.titleLabel.textColor = UIColor.white
    }
    
    func onSwipe( gesture: UIGestureRecognizer) {
        self.index = self.index + 1
        if self.index > self.contents.count-1 {
            self.index = 0
        }
        
        self.titleLabel.text = self.contents[ self.index]
        for (shape, paths) in self.shapes {
            if paths.count > 0 {
                let fromIndex = (self.index-1) < 0 ? self.contents.count-1 : self.index-1
                let fromPath = paths[ fromIndex]
                let toPath = paths[ self.index]
                
                let animation = CABasicAnimation()
                animation.fromValue = fromPath
                animation.toValue = toPath
                animation.keyPath = "path"
                animation.duration = 3
                // explicit CAAnimations decouple the presentation from model
                // At the end of an animation, the presentation is updated to MATCH the model. This overrides that behavior.
                // http://samwize.com/2016/12/16/core-animation-guide/
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeForwards
                
                shape.add( animation, forKey: animation.keyPath)
            }
        }
    }
    
    func addGestureRecognizers( view: UIView) {
        let directions: [UISwipeGestureRecognizerDirection] = [ .up, .down, .left, .right]
        for d in directions {
            let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector( self.onSwipe(gesture:)))
            swipeRecognizer.direction = d
            view.addGestureRecognizer( swipeRecognizer)
        }
    }
    
    func generatePath( begin: CGPoint, end: CGPoint, ctrl1: CGPoint, ctrl2: CGPoint) -> CGPath {
        let shapePath = UIBezierPath()
        shapePath.move(to: begin)
        shapePath.addCurve(to: end, controlPoint1: ctrl1, controlPoint2: ctrl2)
        // HACK
        shapePath.addLine(to: CGPoint(x: 0, y: self.view.frame.maxY))
        
        return shapePath.cgPath
    }
    
    func generatePath( begin: CGPoint, end: CGPoint, ctrl1: CGPoint) -> CGPath {
        let shapePath = UIBezierPath()
        shapePath.move(to: begin)
        shapePath.addQuadCurve(to: end, controlPoint: ctrl1)
        shapePath.addLine(to: CGPoint(x: self.view.frame.maxX*0.75, y: 0))
        
        return shapePath.cgPath
    }
    
    func randomize( point: CGPoint, maxX: CGFloat = 50, maxY: CGFloat = 25) -> CGPoint {
        let xOffset = CGFloat( arc4random_uniform( UInt32( maxX)))
        let yOffset = CGFloat( arc4random_uniform( UInt32( maxY)))
        
        print("Randomized offsets \nx: \( xOffset) y: \( yOffset)")
        
        return CGPoint( x: point.x + xOffset, y: point.y + yOffset)
    }
    
    func shuffle( paths: [ CGPath]) -> [ CGPath] {
        return paths.map({_ -> CGPath in
            let index = Int( arc4random_uniform( UInt32( paths.count-1)))
            return paths[ index]
        })
    }
}
