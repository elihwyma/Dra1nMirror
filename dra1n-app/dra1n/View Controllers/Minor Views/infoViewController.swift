//
//  infoViewController.swift
//  dra1n
//
//  Created by Amy While on 06/08/2020.
//

import UIKit

class infoViewController: UIViewController {

    var dict: DatabaseObject!
        
    var tableData: [[String]] = [
        ["Loading", "Loading"],
        ["Loading", "Loading"],
        ["info.circle", "magnifyingglass"],
        ["Loading", "Loading"]
    ]
    
    @objc func colourControl() {
        self.view.backgroundColor = .dra1nBackground
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.dra1nLabel]
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = .secondaryBackground
        self.tableView.reloadData()
    }
  
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        colourControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableData[0] = ["Loading", "Loading"]
        self.tableData[1] = ["Loading", "Loading"]
        self.tableData[3] = ["Loading", "Loading"]
        
        self.imageView.image = UIImage(named: "tweakIcon")
        self.loadDict()
    }
  
    func loadDict() {
        let Bundleid = dict.Bundleid ?? "Error"
        let index = Dra1nApiParser.shared.tweakNames.firstIndex(of: Bundleid) ?? 0
        let le = Dra1nApiParser.shared.database[index]
                
        if (le.badImage == false || le.badImage == nil) && (le.goodImage == false || le.goodImage == nil) && le.image == nil {
            ParcilityParser.shared.setImage(bundleID: le.Bundleid ?? "Error", completion: { (index, success) -> Void in
                if (success && ((Dra1nApiParser.shared.database[index].Bundleid ?? "Error") == Bundleid)) {
                    DispatchQueue.main.async {
                       self.imageView.image = Dra1nApiParser.shared.database[index].image ?? UIImage(named: "tweakIcon")
                    }
                }
            })
        } else if le.goodImage == true && le.image != nil && (le.badImage == false || le.badImage == nil) {
            self.imageView.image = le.image
        } else {
            self.imageView.image = UIImage(named: "tweakIcon")
        }
        
        switch (le.flag ?? 0) {
        case 2: self.tableData[1][1] = ("This tweak may cause moderate battery drain"); break
        case 3: self.tableData[1][1] = ("This tweak may cause severe battery drain"); break
        case 5: self.tableData[1][1] = ("This tweak may cause battery drain"); break
        default: self.tableData[1][1] = ("Error"); break
        }
        self.tableData[0][1] = "Statistics"
        self.tableData[3][1] = ("\(le.warns ?? 0)")
        
        if le.author == nil && le.name == nil {
            DispatchQueue.global(qos: .utility).async {
                ParcilityParser.shared.grabStruct(bundleID: le.Bundleid ?? "Error", completion: { (index, success) -> Void in
                    if (success) {
                        self.tableData[0][0] = ("Info")
                        if let author = Dra1nApiParser.shared.database[index].author, let name = Dra1nApiParser.shared.database[index].name {
                            self.tableData[1][0] = "This tweak's author is \(author)"
                            self.tableData[3][0] = name
                        }
                        else {
                            self.tableData[1][0] = "Parcility has no data for this tweak"
                            self.tableData[3][0] = "Error"
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                })
            }
        } else {
            self.tableData[0][0] = ("Info")
            if let author = le.author, let name = le.name {
                self.tableData[1][0] = "This tweak's author is \(author)"
                self.tableData[3][0] = name
            }
            else {
                self.tableData[1][0] = "Parcility has no data for this tweak"
                self.tableData[3][0] = "Error"
            }
        }
        self.tableView.reloadData()
    }
    
    func setup() {
        //Make it transparent
        tableView.backgroundColor = .none
        //Removes cells that don't exist
        tableView.tableFooterView = UIView()
        //Disable the seperator lines, make it look nice :)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        //Disable the scroll indicators
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        //Setting up nessecary stuff
        tableView.dataSource = self
        tableView.delegate = self
        //Disable scrolling if it all fits
        tableView.alwaysBounceVertical = false
        
        tableView.register(UINib(nibName: "MainCell", bundle: nil), forCellReuseIdentifier: "Dra1n.MainCell")
        
        self.title = self.dict.Bundleid ?? ""
        
        self.imageView.layer.cornerRadius = 15
        self.imageView.layer.masksToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(colourControl), name: NSNotification.Name(rawValue: "OledModeChange"), object: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.colourControl()
    }
    
}

extension infoViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Make it invisible when you press it
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension infoViewController : UITableViewDataSource {
    
    //Number of things to show
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData[0].count
    }
    //This is just meant to be
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //Changing this doesn't work, but removing it makes the gaps massive :confused:
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    //This is what handles all the images and text etc, using the class mainScreenTableCells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Dra1n.MainCell", for: indexPath) as! MainCell
    
        cell.title.text = tableData[0][indexPath.section]
        cell.descriptionText.text = tableData[1][indexPath.section]
        cell.specificValue.text = tableData[3][indexPath.section]
        cell.icon = tableData[2][indexPath.section]
 
        switch (tableData[3][indexPath.section]) {
            case "\(NSLocalizedString("great", comment: ""))": cell.specificValue.textColor = .systemGreen; break
            case "\(NSLocalizedString("good", comment: ""))": cell.specificValue.textColor = .systemOrange; break
            case "\(NSLocalizedString("poor", comment: ""))": cell.specificValue.textColor = .systemRed; break
            default: break
        }
    
        cell.allTheAdjustments()
            
        return cell
    }
}
