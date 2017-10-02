import UIKit


class AnimatedShapeViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        self.titleLabel.textColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated)
        let offset: CGFloat = 75
        
        // generate paths
        let generatedPaths = self.generateRandomPaths(begin: CGPoint.zero, end: CGPoint(x: 0, y: self.view.frame.maxY), ctrl1: CGPoint(x: 0.0, y: 462.219284296036 + offset), ctrl2: CGPoint(x: 318.452373147011, y: 0.0 + offset), count: 10)
        var animations: [ CABasicAnimation] = []
        
        // generate [ CABasicAnimation]
        for path in generatedPaths {
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
        shape.fillColor = UIColor.blue.cgColor
        if let c = UIColor.blue.cgColor.copy(alpha: 0.5) {
            print("With alpha: \( c.alpha)")
            shape.fillColor = c
        }
        shape.add( group, forKey: "path+color transformations")
        self.view.layer.addSublayer( shape)

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
    
    func generatePath( begin: CGPoint, end: CGPoint, ctrl1: CGPoint, ctrl2: CGPoint) -> CGPath {
        let shapePath = UIBezierPath()
        shapePath.move(to: begin)
        shapePath.addCurve(to: end, controlPoint1: ctrl1, controlPoint2: ctrl2)
        
        return shapePath.cgPath
    }
    
    func generateRandomPaths( begin: CGPoint, end: CGPoint, ctrl1: CGPoint, ctrl2: CGPoint, count: Int) -> [ CGPath] {
        var rawPaths: [ (begin: CGPoint, end: CGPoint, ctrl1: CGPoint, ctrl2: CGPoint)] = [ ( begin: begin, end: end, ctrl1: ctrl1, ctrl2: ctrl2)]
        for i in 0..<count {
            let rawPath = rawPaths[ i]
            
            let adjCtrl1 = self.applyRandom(point: rawPath.ctrl1)
            let adjCtrl2 = self.applyRandom(point: rawPath.ctrl2)
            
            rawPaths.append( ( begin: begin, end: end, ctrl1: adjCtrl1, ctrl2: adjCtrl2))
        }
        
        rawPaths = rawPaths.map({ ( begin, end, ctrl1, ctrl2) -> ( begin: CGPoint, end: CGPoint, ctrl1: CGPoint, ctrl2: CGPoint) in
            return (begin, end, ctrl1, self.applyRandom( point: ctrl2))
        })
        
        return rawPaths.map({ (begin, end, ctrl1, ctrl2) -> CGPath in
            return self.generatePath(begin: begin, end: end, ctrl1: ctrl1, ctrl2: ctrl2)
        })
    }
    
    func applyRandom( point: CGPoint) -> CGPoint {
        let xOffset = CGFloat( arc4random_uniform( 50))
        let yOffset = CGFloat( arc4random_uniform( 50))
        return CGPoint( x: point.x + xOffset, y: point.y + yOffset)
    }
}


extension AnimatedShapeViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("Finished? \( flag ? "Yes" : "No")")
    }
}




