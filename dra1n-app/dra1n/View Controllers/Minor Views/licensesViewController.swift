//
//  licensesViewController.swift
//  dra1n
//
//  Created by Amy While on 12/08/2020.
//

import UIKit
import SafariServices

class licenseCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    func colourSettings() {
        self.backgroundColor = .clear
        self.label.textColor = .dra1nLabel
    }
}

class licensesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let credits = [
        ["Macaw", "SwiftyMarkdown", "SwiftyOnboard"],
        ["https://github.com/exyte/Macaw/blob/master/LICENSE", "https://github.com/SimonFairbairn/SwiftyMarkdown/blob/master/LICENSE", "https://github.com/juanpablofernandez/SwiftyOnboard/blob/master/LICENSE"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        self.colourThings()
    }
    
    @objc func colourThings() {
        self.view.backgroundColor = .secondaryBackground
        self.tableView.backgroundColor = .secondaryBackground
        self.tableView.reloadData()
    }
    
    func setup() {
        //Make it transparent
        tableView.backgroundColor = .none
        //Removes cells that don't exist
        tableView.tableFooterView = UIView()
        //Disable the scroll indicators
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        //Setting up nessecary stuff
        tableView.dataSource = self
        tableView.delegate = self
        //Disable scrolling if it all fits
        tableView.alwaysBounceVertical = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(colourThings), name: NSNotification.Name(rawValue: "OledModeChange"), object: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.colourThings()
    }
    
}


extension licensesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: self.credits[1][indexPath.row]) {
            let safari: SFSafariViewController = SFSafariViewController(url: url)
            self.present(safari, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension licensesViewController : UITableViewDataSource {
  
    //This is just meant to be
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.credits[0].count
    }

    //This is what handles all the images and text etc, using the class mainScreenTableCells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "licenseCell", for: indexPath) as! licenseCell
        cell.label.text = self.credits[0][indexPath.row]
        cell.backgroundColor = .secondaryBackground
        cell.label.textColor = .dra1nLabel
        return cell
    }
}

