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
    static var random: UIColor {
        return UIColor(red: CGFloat.random(), green: CGFloat.random(), blue: CGFloat.random(), alpha: 1.0)
    }
    
    static var triadColor: UIColor {
        let colors = [
            UIColor(argb: 0x900c3f),
            UIColor(argb: 0xc70039),
            UIColor(argb: 0xF9005B),
            UIColor(argb: 0xF20018),
            UIColor(argb: 0xEBB9DF),
            UIColor(argb: 0xDED9E2),
            UIColor(argb: 0x80A1D4)

        ]
        
        // random triad color
        return colors[ Int( arc4random_uniform( UInt32( colors.count)))]
    }
    
    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }
    
    // let's suppose alpha is the first component (ARGB)
    convenience init(argb: Int) {
        self.init(
            red: (argb >> 16) & 0xFF,
            green: (argb >> 8) & 0xFF,
            blue: argb & 0xFF,
            a: (argb >> 24) & 0xFF
        )
    }
}
