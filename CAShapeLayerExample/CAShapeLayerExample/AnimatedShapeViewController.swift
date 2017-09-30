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
        let offsetX: CGFloat = 0
        let path = generatePath(
            begin: CGPoint(x: offsetX, y: 0),
            end: CGPoint(x: offsetX, y: self.view.frame.maxY),
            ctrl1: CGPoint(x: 0.0 + offsetX, y: 462.219284296036),
            ctrl2: CGPoint(x: 318.452373147011 + offsetX, y: 0.0)
        )
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor.red.cgColor
        self.view.layer.addSublayer( shape)
    }
    
    func generatePath( begin: CGPoint, end: CGPoint, ctrl1: CGPoint, ctrl2: CGPoint) -> CGPath {
        let shapePath = UIBezierPath()
        shapePath.move(to: begin)
        shapePath.addCurve(to: end, controlPoint1: ctrl1, controlPoint2: ctrl2)
        
        return shapePath.cgPath
    }
}
