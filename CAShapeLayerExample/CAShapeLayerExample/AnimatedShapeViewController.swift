import UIKit


class AnimatedShapeViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    let contents = [
        "MakeItMobile",
        "Established 2017",
        "Web + Mobile software development",
        "iOS",
        "React.js",
        "Node.js",
        "Postgres",
        "You get the idea...",
        "Hire Us! hello@makeitmobile.co"
    ]
    private var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set gradient background
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [
            UIColor.purple.cgColor,
            UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 0.75).cgColor
        ]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        // z-index "below" self.view
        gradient.zPosition = -1
        self.view.layer.addSublayer(gradient)
        
        self.titleLabel.textColor = UIColor.white
        self.refreshButton.addTarget( self, action: #selector( self.onRefreshSelected(sender:)), for: UIControlEvents.touchUpInside)
        self.addGestureRecognizers(view: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated)
        
        addShapes()

        // DEBUG
        // visually display paths as CAShapeLayers
//        for (index, path) in generatedPaths.enumerated() {
//            
//            let withDelay = 2.0
//            DispatchQueue.main.asyncAfter(deadline: .now() + (withDelay*Double(index))) {
//                
//                let shape = CAShapeLayer()
//                shape.fillColor = UIColor.random.cgColor
//                shape.path = path
//                self.view.layer.addSublayer( shape)
//                
//                print( "Add layer #\( index)")
//            }
//        }
    }
    
    func onRefreshSelected( sender: UIButton) {
        // remove only CAShapeLayer instances
        for layer in ((self.view.layer.sublayers ?? [ CALayer]()).filter{ layer -> Bool in return layer is CAShapeLayer }) {
            layer.removeAllAnimations()
            layer.removeFromSuperlayer()
        }
        
        self.addShapes()
        self.titleLabel.text = self.contents.first
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
    
    func addGestureRecognizers( view: UIView) {
        let directions: [UISwipeGestureRecognizerDirection] = [ .up, .down, .left, .right]
        for d in directions {
            let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector( self.onSwipe(gesture:)))
            swipeRecognizer.direction = d
            view.addGestureRecognizer( swipeRecognizer)
        }
    }
    
    func addShapes() {
        func animateToView( view: UIView, generatedPaths: [ CGPath], numShapes: Int) {
            for i in 0..<numShapes {
                let shuffledPaths = generatedPaths.map({_ -> CGPath in
                    let index = Int( arc4random_uniform( UInt32( generatedPaths.count-1)))
                    return generatedPaths[ index]
                })
                var animations: [ CABasicAnimation] = []
                
                // generate [ CABasicAnimation]
                for path in shuffledPaths {
                    let animation = CABasicAnimation()
                    // sane defaults
                    animation.duration = 3
                    animation.fromValue = path
                    animation.toValue = path
                    animation.keyPath = "path"
                    
                    if let prevAnim = animations.last {
                        animation.beginTime = prevAnim.beginTime + prevAnim.duration
                        animation.fromValue = prevAnim.toValue
                    }
                    animations.append( animation)
                }
                // drop off first animation
                animations.removeFirst()
                
                // animation group
                let group = CAAnimationGroup()
                group.animations = animations
                group.delegate = self
                group.duration = group.animations?.reduce( 0, { ( accumulator, animation) in
                    return accumulator + animation.duration
                }) ?? 0
                
                // add CAShapeLayer to view
                let shape = CAShapeLayer()
                shape.zPosition = -1
                
                let alpha = CGFloat( arc4random_uniform( UInt32( 50))) / 100.0
                shape.fillColor = UIColor.triadColor.cgColor.copy(alpha: alpha)
                shape.add( group, forKey: "path+color transformations")
                self.view.layer.addSublayer( shape)
            }
        }
        
        let offset: CGFloat = 75
        // generate paths
        let rightSidedPaths = self.generateRandomPaths(begin: CGPoint.zero, end: CGPoint(x: 0, y: self.view.frame.maxY), ctrl1: CGPoint(x: 0.0, y: 462.219284296036 + offset), ctrl2: CGPoint(x: 318.452373147011, y: 0.0 + offset), count: 10)
        
        let circlePaths = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9].map{ index -> CGPath in
            
            let r = self.view.frame.width * 0.20
            return self.generatePath(
                begin: CGPoint(x: self.view.frame.width-r, y: 0),
                end: CGPoint(x: self.view.frame.width-r+(2*r), y: 0),
                ctrl1: CGPoint(x: (self.view.frame.width/2) * 2.15, y: self.view.frame.height * 0.15 * CGFloat( index))
            )
        }
        
        animateToView(view: self.view, generatedPaths: rightSidedPaths, numShapes: 3)
        animateToView(view: self.view, generatedPaths: circlePaths, numShapes: 3)
    }
    
    func generatePath( begin: CGPoint, end: CGPoint, ctrl1: CGPoint, ctrl2: CGPoint) -> CGPath {
        let shapePath = UIBezierPath()
        shapePath.move(to: begin)
        shapePath.addCurve(to: end, controlPoint1: ctrl1, controlPoint2: ctrl2)
        
        return shapePath.cgPath
    }
    
    func generatePath( begin: CGPoint, end: CGPoint, ctrl1: CGPoint) -> CGPath {
        let shapePath = UIBezierPath()
        shapePath.move(to: begin)
        shapePath.addQuadCurve(to: end, controlPoint: ctrl1)
        
        return shapePath.cgPath
    }
    
    
    func generateRandomPaths( begin: CGPoint, end: CGPoint, ctrl1: CGPoint, ctrl2: CGPoint, count: Int) -> [ CGPath] {
        var rawPaths: [ (begin: CGPoint, end: CGPoint, ctrl1: CGPoint, ctrl2: CGPoint)] = [ ( begin: begin, end: end, ctrl1: ctrl1, ctrl2: ctrl2)]
        for i in 0..<count {
            let rawPath = rawPaths[ i]
            
            let adjCtrl1 = rawPath.ctrl1
            let adjCtrl2 = self.applyRandom(point: rawPath.ctrl2)
            
            rawPaths.append( ( begin: begin, end: end, ctrl1: adjCtrl1, ctrl2: adjCtrl2))
        }
        
        rawPaths = rawPaths.map({ ( begin, end, ctrl1, ctrl2) -> ( begin: CGPoint, end: CGPoint, ctrl1: CGPoint, ctrl2: CGPoint) in
            return (begin, end, ctrl1, ctrl2)
        })
        
        return rawPaths.map({ (begin, end, ctrl1, ctrl2) -> CGPath in
            return self.generatePath(begin: begin, end: end, ctrl1: ctrl1, ctrl2: ctrl2)
        })
    }
    
    func applyRandom( point: CGPoint) -> CGPoint {
        let xOffset = CGFloat( arc4random_uniform( 25))
        let yOffset = CGFloat( arc4random_uniform( 15))
        
        print("xOffset: \( xOffset) yOffset: \( yOffset)")
        
        return CGPoint( x: point.x + xOffset, y: point.y + yOffset)
    }
}


extension AnimatedShapeViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("Finished? \( flag ? "Yes" : "No")")
    }
}




