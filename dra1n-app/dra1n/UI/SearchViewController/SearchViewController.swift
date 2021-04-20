//
//  searchViewController.swift
//  dra1n
//
//  Created by Amy While on 06/08/2020.
//

import UIKit

class SearchViewController: UIViewController {

    var shownTweaks = [DatabaseObject]()

    @objc func colourControl() {
        self.view.backgroundColor = .dra1nBackground
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.dra1nLabel]
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                self.colourControl()
            }
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
    
        generalSetup()
        self.showTheMatching()
    }

    func generalSetup() {
        self.searchBar.showsCancelButton = false
        self.searchBar.placeholder = "Tweak Name"
        self.searchBar.delegate = self
        
        //Disable the scroll indicators
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        //Setting up nessecary stuff
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.backgroundColor = .clear
        self.tableView.sectionIndexBackgroundColor = .clear
        
        self.tableView.register(UINib(nibName: "culpritCell", bundle: nil), forCellReuseIdentifier: "culpritCell")
        
        self.view.backgroundColor = .dra1nBackground
        self.colourControl()
        
        NotificationCenter.default.addObserver(self, selector: #selector(colourControl), name: NSNotification.Name(rawValue: "OledModeChange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showTheMatching), name: NSNotification.Name(rawValue: "DatabaseLoad"), object: nil)
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTheDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! infoViewController
                let bundleID = self.shownTweaks[indexPath.row]
                controller.dict = bundleID
            }
        }
    }
        
    @objc func showTheMatching() {
        self.shownTweaks.removeAll()
        
        let searchText = self.searchBar.text ?? ""
        
        if !Dra1nController.privacyPolicy {
            let le = DatabaseObject(image: UIImage(named: "tweakIcon"), goodImage: true, badImage: false, Bundleid: "Privacy Policy Disabled", flag: 0, warns: 0, ratio: 0)
            shownTweaks.append(le)
        } else {
            if (searchText == "") {
                for index in Dra1nApiParser.shared.randomIndexes {
                    shownTweaks.append(Dra1nApiParser.shared.database[index])
                }
            } else {
                for tweak in Dra1nApiParser.shared.database {
                    if (tweak.Bundleid ?? "Error").range(of: searchText, options: .caseInsensitive) != nil {
                        shownTweaks.append(tweak)
                    }
                }
            }
        }
    
        self.tableView.reloadData()
    }
}

extension SearchViewController: UISearchBarDelegate {
   
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.showTheMatching()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = nil
        self.resignFirstResponder()
        self.view.endEditing(true)
        self.showTheMatching()
    }
}


extension SearchViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shownTweaks[indexPath.row].Bundleid == "Privacy Policy Disabled" { return }
        performSegue(withIdentifier: "showTheDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchViewController : UITableViewDataSource {
  
    //This is just meant to be
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shownTweaks.count
    }

    //This is what handles all the images and text etc, using the class mainScreenTableCells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "culpritCell", for: indexPath) as! culpritCell
        cell.le = self.shownTweaks[indexPath.row]
        cell.index = indexPath.row
        
        let firstFont = UIFont.systemFont(ofSize: 14)
        let firstAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.dra1nLabel, NSAttributedString.Key.font: firstFont]
        let secondFont = UIFont.systemFont(ofSize: 11)
        let secondAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.dra1nLabel, NSAttributedString.Key.font: secondFont]
        
        let firstString = NSMutableAttributedString(string: "\(cell.le?.Bundleid ?? "Error")\n", attributes: firstAttributes)
        
        let secondString = NSAttributedString(string: "\(cell.le?.ratio ?? 0)% Flag Ratio", attributes: secondAttributes)
     
        firstString.append(secondString)

        cell.textView.attributedText = firstString
        cell.colourControl()

        return cell
    }
}

