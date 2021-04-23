//
//  settingsController.swift
//  dra1n
//
//  Created by Amy While on 22/07/2020.
//

import UIKit

class SettingsViewController: UITableViewController {
        
    @IBOutlet weak var averageTimeLabel: UILabel!
    @IBOutlet weak var sensitivityLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initStuff()
        setSliderText()
        self.applyColourSettings()
        NotificationCenter.default.addObserver(self, selector: #selector(applyColourSettings), name: NSNotification.Name(rawValue: "OledModeChange"), object: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.applyColourSettings()
    }
 
    @objc func applyColourSettings() {
        
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                self.tableView.backgroundColor = .secondaryBackground
            } else {
                self.tableView.backgroundColor = .secondaryBackground
            }
        } else {
            self.tableView.backgroundColor = .secondaryBackground
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.dra1nLabel]
    }

    @IBOutlet weak var licensesButton: UIButton!
    func initStuff() {
        let averageTimeSliderCase = Float(Dra1nDefaults.getInt(key: "averageTimeSlider"))
        let drainSensitivityCase = Float(Dra1nDefaults.getInt(key: "DrainSensitivity"))
        let barCountCase = Float(Dra1nDefaults.getInt(key: "BarCount"))
        
        
        if (averageTimeSliderCase != 0.0) { averageTime.value = averageTimeSliderCase } else { averageTime.value = 4.0; Dra1nDefaults.set(key: "AverageTime", object: 21600) }
        if (drainSensitivityCase != 0.0) { sensitivity.value = drainSensitivityCase } else { sensitivity.value = 125.0; Dra1nDefaults.set(key: "DrainSensitivity", object: 125) }
        if (barCountCase != 0.0) { barCount.value = barCountCase } else { barCount.value = 5; Dra1nDefaults.set(key: "BarCount", object: 5) }
        
    }
    
    @objc func setSliderText() {
        self.averageTimeLabel.text = "\(Int(averageTime.value))H"
        self.sensitivityLabel.text = "\(Int(sensitivity.value))%"
        self.barCountLabel.text = "\(Int(barCount.value))"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Make it invisible when you press it
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func clearTheLogs(_ sender: Any) {
        
        let alert = UIAlertController(title: "\(NSLocalizedString("clearAllLogs", comment: ""))", message: "\(NSLocalizedString("areYouSureRespring", comment: ""))", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "\(NSLocalizedString("clear", comment: ""))", style: .destructive, handler: { action in
            
            Dra1nDefaults.set(key: "CulpritLog", object: [[String : Any]]())
            Dra1nDefaults.set(key: "DrainAvarageLog", object: [[String : Any]]())
            Dra1nDefaults.set(key: "DrainLog", object: [[String : Any]]())
            Dra1nDefaults.set(key: "UpdatedNewTweaks", object: [[String : Any]]())
            Dra1nDefaults.set(key: "increaseSinceLastCheck", object: false)
            
            Dra1nController.respring()
        }))
        alert.addAction(UIAlertAction(title: "\(NSLocalizedString("cancel", comment: ""))", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    @IBOutlet weak var averageTime: UISlider!
    @IBAction func averageTime(_ sender: Any) {
        let currentValue = averageTime.value
        let rounded = currentValue.rounded()
        averageTime.value = rounded
        setSliderText()
        
        Dra1nDefaults.set(key: "averageTimeSlider", object: Int(averageTime.value))
        Dra1nDefaults.set(key: "AverageTime", object: Int(averageTime.value * 3600))
    }
    
    @IBOutlet weak var sensitivity: UISlider!
    @IBAction func sensitivity(_ sender: Any) {
        let currentValue = sensitivity.value
        let rounded = currentValue.rounded()
        sensitivity.value = rounded
        setSliderText()

        Dra1nDefaults.set(key: "DrainSensitivity", object: Int(sensitivity.value))
    }
    

    @IBOutlet weak var barCountLabel: UILabel!
    @IBOutlet weak var barCount: UISlider!
    @IBAction func barCount(_ sender: Any) {
        let currentValue = barCount.value
        let rounded = currentValue.rounded()
        barCount.value = rounded
        setSliderText()

        Dra1nDefaults.set(key: "BarCount", object: Int(barCount.value))
        NotificationCenter.default.post(name: .GraphRefresh, object: nil)
    }
        
    @IBOutlet weak var restartSpringboard: UIButton!
    @IBAction func restartSpringboard(_ sender: Any) {
        let alert = UIAlertController(title: "\(NSLocalizedString("respring", comment: ""))", message: "\(NSLocalizedString("clear?", comment: ""))", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "\(NSLocalizedString("yes", comment: ""))", style: .destructive, handler: { action in
            Dra1nController.respring()
        }))
        alert.addAction(UIAlertAction(title: "\(NSLocalizedString("cancel", comment: ""))", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
     
    @IBOutlet weak var privacyPolicy: UIButton!
    @IBAction func privacyPolicy(_ sender: Any) {
        performSegue(withIdentifier: "fromSettingsPolicy", sender: nil)
    }
    
    @IBOutlet weak var exportData: UIButton!
    @IBAction func exportData(_ sender: Any) {
        let drainAverageLog = Dra1nDefaults.getObject(key: "DrainAvarageLog") as? [[String : Any]] ?? [[String : Any]]()
        let secondary = Dra1nDefaults.getObject(key: "CulpritLog") as? [[String : Any]] ?? [[String : Any]]()
        let tweakList = Dra1nDefaults.getObject(key: "TweakList") as? [String] ?? [String]()
        var fixedTweakList = [String]()
        
        for item in tweakList {
            if (!item.contains("gsc.")) {
                let noTPlease = item.replacingOccurrences(of: "\t", with: "")
                fixedTweakList.append(noTPlease)
            }
        }
        
        let report = ["Drain Average Log: \(drainAverageLog), Culprit Tweaks: \(secondary), Tweak List: \(fixedTweakList)"]
        let ac = UIActivityViewController(activityItems: report, applicationActivities: nil)
        ac.excludedActivityTypes = [.airDrop]
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        
        
        present(ac, animated: true)
    }
        
    @IBOutlet weak var appIcon: UIButton!
}

extension NSNotification.Name {
    static let GraphRefresh = Notification.Name("GraphRefresh")
}
