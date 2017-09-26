
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
        
        // one direction per UISwipeGestureRecognizer
        addGestureRecognizers( view: self.view)
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
