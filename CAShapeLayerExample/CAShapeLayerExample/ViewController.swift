import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var shapeLayer: CAShapeLayer?
    var bottomRight: CAShapeLayer?
    
    let data = [
        (
            title: "Winter is coming!",
            subtitle: "Under new management",
            description: "Now with 10% fewer flayings. Come for the magnificant wildlife: dire wolves, wogs, and the walking dead.",
            imageName: "blue-crystal"
        ),
        (
            title: "It's Always Sunny in Dorne",
            subtitle: "Nuts to Winterfell",
            description: "Take a break from White Walkers, ravens and prudish royality. Live out winter in style.",
            imageName: "ocean"
        ),
        (
            title: "Got Dragonglass?",
            subtitle: "We've got tons of it!",
            description: "Are you tired of metals tools? Long for the days when things were made of good ol' dependable rocks?",
            imageName: "dragonstone"
        ),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.black
        self.tableView.register( UINib(nibName: "StyledTableViewCell", bundle: nil), forCellReuseIdentifier: "StyledTableViewCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // bottom, right path + shape
        let p = UIBezierPath()
        p.move(to: CGPoint(x: 0, y: 0))
        p.addLine( to: CGPoint(x: (225/500)*225, y: 0))
        let ctrl1 = CGPoint(x: (50/500)*50, y: (175*500)*175)
        let ctrl2 = CGPoint(x: (350/500)*50, y: self.view.frame.height*0.80)
        p.addCurve(to: CGPoint(x: 0, y: self.view.frame.height), controlPoint1: ctrl1, controlPoint2: ctrl2)
        
        self.shapeLayer = CAShapeLayer()
        self.shapeLayer?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.shapeLayer?.fillColor = UIColor.blue.cgColor
        self.shapeLayer?.path = p.cgPath
        
        if let layer = self.shapeLayer {
            self.view.layer.addSublayer( layer)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generatePathFor(frame: CGRect, xOffset: CGFloat, yOffset: CGFloat) -> UIBezierPath {
        // find control points
        let controlP1 = CGPoint(x: 150 + xOffset, y: (view.frame.size.height/3) + -yOffset)
        let controlP2 = CGPoint(x: 150 + xOffset, y: (view.frame.size.height/3)*2 + -yOffset)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        // add control points
        bezierPath.addQuadCurve(to: CGPoint(x: 0, y: view.center.y), controlPoint: controlP1)
        bezierPath.addQuadCurve(to: CGPoint(x: 0, y: view.frame.size.height), controlPoint: controlP2)
        
        return bezierPath
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffset: CGPoint = scrollView.contentOffset
        print( "Scroll offset: \( scrollOffset)")
        
        // adjust path
        let adjustedBezierPath: UIBezierPath = self.generatePathFor(frame: self.view.frame, xOffset: scrollOffset.x, yOffset: scrollOffset.y)
        // adjust shape layer path based on scroll offset
        self.shapeLayer?.path = adjustedBezierPath.cgPath
        
        let p = UIBezierPath()
        p.move(to: CGPoint(x: self.view.frame.width, y: self.view.frame.height*0.25))
        p.addQuadCurve(to: CGPoint(x: 0, y: self.view.frame.height), controlPoint: CGPoint(x: self.view.frame.width*0.80, y: self.view.frame.size.height*0.90 + (scrollOffset.y)))
        p.addLine(to: CGPoint(x: self.view.frame.size.width, y: self.view.frame.size.height))
        self.bottomRight?.fillColor = UIColor.purple.cgColor
        self.bottomRight?.path = p.cgPath
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "StyledTableViewCell") as? StyledTableViewCell else { return UITableViewCell() }
        let item = self.data[ indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.subtitleLabel.text = item.subtitle
        cell.descriptionLabel.text = item.description
        cell.backgroundImage?.image = UIImage(named: item.imageName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/CGFloat(self.data.count)
    }
}

