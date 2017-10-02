import UIKit


extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    func toRadians() -> CGFloat {
        return self * CGFloat( Double.pi) / 180.0
    }
}


extension UIColor {
    static func fromRGB( red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        // #09203f → #537895
        return UIColor.blue
    }
    
    static var random: UIColor {
        return UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.0)
    }
}
