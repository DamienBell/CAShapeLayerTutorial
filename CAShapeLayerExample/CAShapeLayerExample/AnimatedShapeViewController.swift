import UIKit

class AnimatedShapeViewController: UIViewController {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated)
        var offset: CGFloat = 0
        
        // paths
        let path = generatePath(
            begin: CGPoint(x: 0, y: 0),
            end: CGPoint(x: 0, y: self.view.frame.maxY),
            ctrl1: CGPoint(x: 0.0, y: 462.219284296036),
            ctrl2: CGPoint(x: 318.452373147011, y: 0.0)
        )
        
        offset = 50
        let toPath = generatePath(
            begin: CGPoint(x: 0, y: 0),
            end: CGPoint(x: 0, y: self.view.frame.maxY),
            ctrl1: CGPoint(x: 0.0 + offset, y: 462.219284296036),
            ctrl2: CGPoint(x: 318.452373147011 + offset, y: 0.0)
        )
        
        offset = offset + 25
        let toPath2 = generatePath(
            begin: CGPoint(x: 0, y: 0),
            end: CGPoint(x: 0, y: self.view.frame.maxY),
            ctrl1: CGPoint(x: 0.0, y: 462.219284296036 + offset),
            ctrl2: CGPoint(x: 318.452373147011, y: 0.0 + offset)
        )

        // animations
        let animation = CABasicAnimation( keyPath: "path")
        animation.fromValue = path
        animation.toValue = toPath
        animation.duration = 3
        animation.autoreverses = false
        
        let animation2 = CABasicAnimation( keyPath: "path")
        animation2.fromValue = toPath
        animation2.toValue = toPath2
        animation2.beginTime = animation.beginTime + animation.duration
        animation2.duration = 3
        animation2.autoreverses = false
        
        let animation3 = CABasicAnimation( keyPath: "fillColor")
        animation3.fromValue = UIColor.red.cgColor
        animation3.toValue = UIColor.purple.cgColor
        animation3.beginTime = animation2.beginTime
        animation3.duration = 3
        animation3.autoreverses = false

        let animation4 = CABasicAnimation( keyPath: "path")
        animation4.fromValue = toPath2
        animation4.toValue = path
        animation4.beginTime = animation3.beginTime + animation3.duration
        animation4.duration = 3
        animation2.autoreverses = false
        
        // shape
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor.red.cgColor
        shape.add( animation, forKey: animation.keyPath)

        // add animations to layer
        let group = CAAnimationGroup()
        group.repeatCount = Float.infinity
        group.delegate = self
        group.animations = [ animation, animation2, animation3, animation4]
        group.duration = group.animations?.reduce( 0, {
            accum, animation in
          return accum + animation.duration
        }) ?? 0
        shape.add( group, forKey: "path+color transformations")
        self.view.layer.addSublayer( shape)
    }
    
    func generatePath( begin: CGPoint, end: CGPoint, ctrl1: CGPoint, ctrl2: CGPoint) -> CGPath {
        let shapePath = UIBezierPath()
        shapePath.move(to: begin)
        shapePath.addCurve(to: end, controlPoint1: ctrl1, controlPoint2: ctrl2)
        
        return shapePath.cgPath
    }
}


extension AnimatedShapeViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("Finished? \( flag ? "Yes" : "No")")
    }
}




