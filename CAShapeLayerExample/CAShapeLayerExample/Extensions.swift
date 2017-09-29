import UIKit


extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat( Double.pi) / 180.0
    }
}


extension UIColor {
    static func fromRGB( red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        // #09203f → #537895
        return UIColor.blue
    }
}
