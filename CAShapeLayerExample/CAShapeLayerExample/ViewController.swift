import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

