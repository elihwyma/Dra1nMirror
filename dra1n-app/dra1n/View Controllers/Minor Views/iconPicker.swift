//
//  iconPicker.swift
//  dra1n
//
//  Created by Amy While on 01/08/2020.
//

import UIKit

class iconPicker: UIViewController {
    
    let iconStatNames = ["Original", "3DBattery", "Dra1nWhite", "Rainbow", "RainbowForeground", "Dra1nPurple", "Dra1nGlyph"]
    let iconNames = ["\(NSLocalizedString("original", comment: ""))", "\(NSLocalizedString("3d", comment: ""))", "\(NSLocalizedString("white", comment: ""))", "\(NSLocalizedString("rainbow", comment: ""))", "\(NSLocalizedString("rainbow+", comment: ""))", "\(NSLocalizedString("purple", comment: ""))", "\(NSLocalizedString("glyph", comment: ""))"]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        self.colourControl()
    }
    
    func setup() {
        //Removes cells that don't exist
        tableView.tableFooterView = UIView()
        //Disable the scroll indicators
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        //Setting up nessecary stuff
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "appIconCell", bundle: nil), forCellReuseIdentifier: "appIconCell")
        
        self.tableView.backgroundColor = .clear
        self.tableView.sectionIndexBackgroundColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(colourControl), name: NSNotification.Name(rawValue: "OledModeChange"), object: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.colourControl()
    }
    
    @objc func colourControl() {
        self.view.backgroundColor = customBackground
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = customGray5
        self.tableView.reloadData()
    }
}


extension iconPicker : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            UIApplication.shared.setAlternateIconName(nil)
            self.tableView.reloadData()
            return
        }
        
        UIApplication.shared.setAlternateIconName(iconStatNames[indexPath.row]) { error in
            if let error = error {
                let alert = UIAlertController(title: "\(NSLocalizedString("failed", comment: ""))", message: "\(NSLocalizedString("error3", comment: "")) \(self.iconStatNames[indexPath.row]) \(NSLocalizedString("error4", comment: "")) \(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "\(NSLocalizedString("close", comment: ""))", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
    }
    
    
}

extension iconPicker : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForFooterInSection
                                section: Int) -> String? {
       return "\(NSLocalizedString("credit", comment: ""))"
    }
    
    //This is just meant to be
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iconStatNames.count
    }
    
    //This is what handles all the images and text etc, using the class mainScreenTableCells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "appIconCell", for: indexPath) as! appIconCell
        
        let currentImage = UIApplication.shared.alternateIconName
        if (currentImage == iconStatNames[indexPath.row]) {
            cell.iconName.text = "\(iconNames[indexPath.row]) ✓"
        } else { cell.iconName.text = iconNames[indexPath.row] }
        
        if (indexPath.row == 0 && UIApplication.shared.alternateIconName == nil) {
            cell.iconName.text = "\(iconNames[indexPath.row]) ✓"
        }
        
        cell.iconName.sizeToFit()
        cell.iconImage.image = UIImage(named: iconStatNames[indexPath.row])
        cell.colourThings()
     
        return cell
    }

}
