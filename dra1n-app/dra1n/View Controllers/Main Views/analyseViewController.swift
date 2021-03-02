//
//  analyseViewController.swift
//  dra1n
//
//  Created by Amy While on 17/07/2020.
//

import UIKit

struct CulpritObject {
    var bundleid: String?
    var date: Date?
    var flag: Int?
    var image: UIImage?
    var hidden: Bool?
    
    init(bundleid: String? = nil,
         date: Date? = nil,
         flag: Int? = nil,
         image: UIImage? = nil,
         hidden: Bool? = nil) {
        self.bundleid = bundleid
        self.date = date
        self.flag = flag
        self.image = image
        self.hidden = hidden
    }
}

class analyseViewController: UIViewController {
    
    var counter = 0
    var shouldRefresh = false

    @IBOutlet weak var drainGraphView: drainGraphView!
    @IBOutlet weak var tableView: UITableView!
    
    var dictionary = [CulpritObject]()
    var shownDictionary = [DatabaseObject]()

    func setup() {
        //Removes cells that don't exist
        tableView.tableFooterView = UIView()
        //Disable the scroll indicators
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        //Setting up nessecary stuff
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "culpritCell", bundle: nil), forCellReuseIdentifier: "culpritCell")
        play(withDelay: 0)
        
        self.colourThings()
        drainGraphView.clipsToBounds = true
        drainGraphView.layer.cornerRadius = 10
        
        self.tableView.backgroundColor = .clear
        self.tableView.sectionIndexBackgroundColor = .clear

        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: NSNotification.Name(rawValue: "badDateFormat"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadStuff), name: NSNotification.Name(rawValue: "OledModeChange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(organiseTheData), name: NSNotification.Name(rawValue: "DatabaseLoad"), object: nil)
        NotificationCenter.default.addObserver(forName: .GraphRefresh, object: nil, queue: nil, using: { _ in
            self.shouldRefresh = true
        })
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.reloadStuff()
    }
    
    @objc func reloadTable() {
        self.tableView.reloadData()
        play(withDelay: 0)
    }
    
    @objc func reloadStuff() {
        play(withDelay: 0)
        self.colourThings()
    }
    
    func colourThings() {
        self.view.backgroundColor = customBackground
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        if (organiseTheData()) {
            self.tableView.reloadData()
        }
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if self.shouldRefresh {
            play(withDelay: 0)
            self.shouldRefresh = false
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
        

    private func play(withDelay: TimeInterval) {
        drainGraphView.backgroundColor = .clear
        drainGraphView.play()
    }
    
    @objc func organiseTheData() -> Bool {
        dictionary.removeAll()
        shownDictionary.removeAll()
        
        let array2 = CepheiController.shared.getObject(key: "CulpritLog") as? [[String : Any]] ?? [[String : Any]]()
        let reversed2 = Array(array2.reversed())
        for item in reversed2 {
            self.dictionary.append(CulpritObject(bundleid: (item["culrpit"] as? String ?? "Discharge Increase").replacingOccurrences(of: "\t", with: ""),
                                                 date: item["time"] as? Date ?? Date()))
        }
    
        if (!Dra1nController.shared.privacyPolicy || Dra1nApiParser.shared.database.count == 0) {
            for tweak in self.dictionary {
                self.shownDictionary.append(DatabaseObject(badImage: true, Bundleid: "Discharge Increase", flag: 1, hide: true, time: tweak.date ?? Date()))
            }
            
        } else {
            for tweak in self.dictionary {
                let index = Dra1nApiParser.shared.tweakNames.firstIndex(of: tweak.bundleid ?? "Error") ?? -1
                if (index == -1) {
                    self.shownDictionary.append(DatabaseObject(badImage: true, Bundleid: "Discharge Increase", flag: 5, hide: true, time: tweak.date ?? Date()))
                } else {
                    var le = Dra1nApiParser.shared.database[index]
                    le.time = tweak.date ?? Date()
                    self.shownDictionary.append(le)
                }
            }
        }
        
        return true
    }
    
    @IBAction func clearLogs(_ sender: Any) {
        let alert = UIAlertController(title: "\(NSLocalizedString("clearAllLogs", comment: ""))", message: "\(NSLocalizedString("clear?", comment: ""))", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "\(NSLocalizedString("clear", comment: ""))", style: .destructive, handler: { action in
            let blankDict = [[String : Any]]()
            CepheiController.shared.set(key: "CulpritLog", object: blankDict)
            
            _ = self.organiseTheData()
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    @IBAction func infoButton(_ sender: Any) {
        let alert = UIAlertController(title: "\(NSLocalizedString("culprits", comment: ""))", message: "\(NSLocalizedString("flagExplanation", comment: ""))", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTheDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! infoViewController
                let bundleID = self.shownDictionary[indexPath.row - 1]
                controller.dict = bundleID
            }
        }
    }
}


extension analyseViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        let le = self.shownDictionary[indexPath.row - 1]
        let cause = le.Bundleid ?? "Discharge Increase"
        
        if ((cause == "Discharge Increase") || (cause == "")) {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        performSegue(withIdentifier: "showTheDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension analyseViewController : UITableViewDataSource {
    
    //This is just meant to be
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.shownDictionary.count == 0) {
            return 0
        } else {
            return self.shownDictionary.count + 1
        }
    }
    
    //This is what handles all the images and text etc, using the class mainScreenTableCells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! headerCell
            cell.clearLog.layer.cornerRadius = 5
            cell.info.layer.cornerRadius = 5
            cell.backgroundColor = .clear
            return cell
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        
        if Dra1nController.shared.dayMonthFormat { dateFormatter.dateFormat = "HH:mm / MM-dd-yyyy" } else { dateFormatter.dateFormat = "HH:mm / dd-MM-yyyy" }
 
        let cell = tableView.dequeueReusableCell(withIdentifier: "culpritCell", for: indexPath) as! culpritCell
        let firstFont = UIFont.systemFont(ofSize: 14)
        let firstAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: firstFont]
        
        let secondFont = UIFont.systemFont(ofSize: 12)
        let secondAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: secondFont]
        
        cell.le = self.shownDictionary[indexPath.row - 1]

        let time = cell.le.time ?? Date()
        let convertedTime = dateFormatter.string(from: time)
        
        let firstString = NSMutableAttributedString(string: "\(cell.le.Bundleid ?? "Unknown Increase")\n", attributes: firstAttributes)
        let secondString = NSAttributedString(string: "\(convertedTime)", attributes: secondAttributes)
        
        firstString.append(secondString)
        
        cell.textView.attributedText = firstString
        cell.colourControl()
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        if (self.shownDictionary.count == 0) {
            return "\(NSLocalizedString("noCulprits", comment: ""))"
        } else if ((Dra1nApiParser.shared.database.count != 0) && (self.shownDictionary.count == 0)) {
            return "Parsing Data"
        } else {
            return ""
        }
    }

}
