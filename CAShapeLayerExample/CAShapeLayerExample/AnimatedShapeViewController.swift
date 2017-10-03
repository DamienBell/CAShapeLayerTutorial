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
        "ElasticSearch",
        "RabbitMQ",
        "Hire Us! hello@makeitmobile.co"
    ]
    var counter = 0
    var timer: Timer?
    
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
        
        self.titleLabel.textColor = UIColor.white
        self.refreshButton.addTarget( self, action: #selector( self.onRefreshSelected(sender:)), for: UIControlEvents.touchUpInside)
        self.addGestureRecognizers(view: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated)
        
        addShapes()
    }

    
    func onRefreshSelected( sender: UIButton) {
        // remove only CAShapeLayer instances
        for layer in ((self.view.layer.sublayers ?? [ CALayer]()).filter{ layer -> Bool in return layer is CAShapeLayer }) {
            layer.removeAllAnimations()
            layer.removeFromSuperlayer()
        }
        
        self.titleLabel.text = self.contents.first
        self.counter = 0
        self.timer?.invalidate()
        self.addShapes()
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
    
    func initAnimatedShapes( view: UIView, paths: [ CGPath], numShapes: Int) {
        for _ in 0..<numShapes {
            let shuffled = shuffle( paths: paths)
            var animations = Array(1..<shuffled.count-1).map{ index -> CABasicAnimation in
                let from = shuffled[ index-1]
                let to = shuffled[ index]
                
                return generateAnimation( from: from, to: to)
            }
            // chain animations by setting beginTime appropriately
            animations = chainAnimations( animations: animations)
            
            let group = animationsToGroup( animations: animations)
            
            // add CAShapeLayer to view
            let shape = generateShape()
            shape.add( group, forKey: "path+color transformations")
            self.view.layer.addSublayer( shape)
        }
    }
    
    func addShapes() {
        let offset: CGFloat = 25
        // generate paths
        let rightSidedPaths = self.generateRandomPaths(begin: CGPoint.zero, end: CGPoint(x: 0, y: self.view.frame.maxY), ctrl1: CGPoint(x: self.view.frame.maxX*0.05, y: 200), ctrl2: CGPoint(x: 100, y: 0.0), count: 10)
        let circlePaths = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9].map{ index -> CGPath in
            
            let r = self.view.frame.width * 0.20
            return self.generatePath(
                begin: CGPoint(x: self.view.frame.width-r, y: 0),
                end: CGPoint(x: self.view.frame.width-r+(2*r), y: 0),
                ctrl1: CGPoint(x: (self.view.frame.width/2) * 2.15, y: self.view.frame.height * 0.15 * CGFloat( index))
            )
        }
        
        self.initAnimatedShapes(view: self.view, paths: rightSidedPaths, numShapes: 20)
        self.initAnimatedShapes(view: self.view, paths: circlePaths, numShapes: 10)
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timer) in
            self.titleLabel.text = self.contents[ self.counter]
            self.counter = self.counter + 1
            
            if self.counter == self.contents.count {
                self.timer?.invalidate()
            }
        })
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
            self.timer?.fire()
        }
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
            let adjCtrl2 = self.randomize(point: rawPath.ctrl2)
            
            rawPaths.append( ( begin: begin, end: end, ctrl1: adjCtrl1, ctrl2: adjCtrl2))
        }
        
        rawPaths = rawPaths.map({ ( begin, end, ctrl1, ctrl2) -> ( begin: CGPoint, end: CGPoint, ctrl1: CGPoint, ctrl2: CGPoint) in
            return (begin, end, ctrl1, ctrl2)
        })
        
        return rawPaths.map({ (begin, end, ctrl1, ctrl2) -> CGPath in
            return self.generatePath(begin: begin, end: end, ctrl1: ctrl1, ctrl2: ctrl2)
        })
    }
    
    func randomize( point: CGPoint, maxX: Int = 25, maxY: Int = 15) -> CGPoint {
        let xOffset = CGFloat( arc4random_uniform( UInt32( maxX)))
        let yOffset = CGFloat( arc4random_uniform( UInt32( maxY)))
        
        print("xOffset: \( xOffset) yOffset: \( yOffset)")
        
        return CGPoint( x: point.x + xOffset, y: point.y + yOffset)
    }
    
    func generateShape() -> CAShapeLayer {
        let alpha = CGFloat( arc4random_uniform( UInt32( 50))) / 100.0
        
        let shape = CAShapeLayer()
        shape.fillColor = UIColor.triadColor.cgColor.copy(alpha: alpha)
        shape.zPosition = -1
        
        return shape
    }
    
    func generateAnimation( from: CGPath, to: CGPath, duration: CFTimeInterval = 3) -> CABasicAnimation {
        let animation = CABasicAnimation()
        // sane defaults
        animation.duration = duration
        animation.fromValue = from
        animation.toValue = to
        animation.keyPath = "path"
        
        return animation
    }
    
    func chainAnimations( animations: [ CABasicAnimation]) -> [ CABasicAnimation] {
        return Array(1..<animations.count-1).map{ index -> CABasicAnimation in
            let prev = animations[ index-1]
            let curr = animations[ index]
            
            curr.beginTime = prev.beginTime + prev.duration
            return curr
        }
    }
    
    func animationsToGroup( animations: [ CABasicAnimation]) -> CAAnimationGroup {
        // animation group
        let group = CAAnimationGroup()
        group.animations = animations
        group.delegate = self
        group.duration = group.animations?.reduce( 0, { ( accumulator, animation) in
            return accumulator + animation.duration
        }) ?? 0
        
        return group
    }
    
    func shuffle( paths: [ CGPath]) -> [ CGPath] {
        return paths.map({_ -> CGPath in
            let index = Int( arc4random_uniform( UInt32( paths.count-1)))
            return paths[ index]
        })
    }
}


extension AnimatedShapeViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("Finished? \( flag ? "Yes" : "No")")
    }
    
    func animationDidStart(_ anim: CAAnimation) {
    }
}




