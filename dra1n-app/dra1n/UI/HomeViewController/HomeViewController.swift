//
//  dra1nViewController.swift
//  dra1n
//
//  Created by Amy While on 11/07/2020.
//

import UIKit
import OnBoardingKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bannerButton: UIButton!
    @IBOutlet weak var updateView: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var updateText: UILabel!
    @IBOutlet weak var updateImage: UIImageView!
    
    var timer = Timer()
    var offset = 0
    var bannerURL = ""
    
    //Global variables
    //I do love me a big ass array, it's not a constant so that new rows can be added at run time
    var tableData = [
        ["\(NSLocalizedString("discharge", comment: ""))", "\(NSLocalizedString("cycles", comment: ""))", "\(NSLocalizedString("timeLeft", comment: ""))", "\(NSLocalizedString("health", comment: ""))", "\(NSLocalizedString("temperature", comment: ""))", "Voltage", "Free Ram"],
        ["\(NSLocalizedString("drainingFromYourDevice", comment: ""))", "\(NSLocalizedString("timesBeenCharged", comment: ""))", "\(NSLocalizedString("estimateTillDeath", comment: ""))", "\(NSLocalizedString("overallHealth", comment: ""))", "\(NSLocalizedString("temperatureDesc", comment: ""))", "Output voltage of your battery", "Free Ram on your Device"],
        ["bolt.fill", "repeat", "clock", "heart.fill", "thermometer", "bolt.horizontal.fill", "rays"],
        ["0mA", "0", "0h 0m", "Good", "0", "0 mV", "0 mb"],
        ["discharge", "cycles", "time", "health", "temperature", "voltage", "ram"]
    ]
    
    @objc func colourThings() {
        self.view.backgroundColor = customBackground
        updateText.textColor = textColour
        blurView.backgroundColor = customGray5
        
        self.tableView.reloadData()
    }
    
    func pp() {
        if !(CepheiController.shared.getBool(key: "NewHasAsked")) {
            performSegue(withIdentifier: "showPrivacyPolicy", sender: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.pp()
        
        let welcomeController = OBWelcomeController(title: "Fat Ass Title here innit", detailText: "Omg wtf is Dra1n like what the fuck does it actually do", icon: UIImage(named: "Original"), contentLayout: 2)!
        welcomeController.view.tintColor = dra1nColour
        welcomeController.headerView.imageView.layer.cornerRadius = 15
        welcomeController.headerView.imageView.layer.masksToBounds = true
        
        if #available(iOS 13.0, *) {
            welcomeController.addBulletedListItem(withTitle: "Test 1", description: "Example Test 1", image: UIImage(systemName: "app"))
            welcomeController.addBulletedListItem(withTitle: "Battery", description: "Omg mega uwu battery", image: UIImage(systemName: "battery.100"))
        } else {
            // Fallback on earlier versions
        }
        welcomeController._shouldInlineButtontray = true
        self.tabBarController?.present(welcomeController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.showUpdateBanner(_:)), name: .updateBanner, object: nil)
        Dra1nApiParser.shared.setup()
        
        //General UI setup
        tableSetup()
 
        //Setting the timers and such
        setTheDra1n()
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(setTheDra1n), userInfo: nil, repeats: true)
    }
   
    @IBAction func bannerButton(_ sender: Any) {
        if let url = URL(string: self.bannerURL) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func showUpdateBanner(_ notification: NSNotification) {
        DispatchQueue.main.async {
            let icon = notification.userInfo?["icon"] as? String ?? "icloud.and.arrow.down"
            let text = notification.userInfo?["text"] as? String ?? "An update is available for Dra1n"
            self.bannerURL = notification.userInfo?["link"] as? String ?? "cydia://url/https://cydia.saurik.com/api/share#?package=com.amymega.dra1n"
 
            self.bannerButton.isEnabled = true
            self.updateView.isHidden = false
            self.blurView.isHidden = false
            
            if #available(iOS 13, *) {
                self.updateImage.image = UIImage(systemName: icon)
            } else {
                self.updateImage.image = UIImage(named: "info.circle")?.withRenderingMode(.alwaysTemplate)
            }
            
            self.updateText.text = text
            self.updateText.adjustsFontSizeToFitWidth = true
            
            if !UIAccessibility.isReduceTransparencyEnabled {
                
                for v in self.blurView.subviews{
                   if v is UIVisualEffectView{
                      v.removeFromSuperview()
                   }
                }
                            
                let blurEffect = UIBlurEffect(style: .regular)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                                
                blurEffectView.frame = self.blurView.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

                self.blurView.addSubview(blurEffectView)
                
            } else {
                self.blurView.backgroundColor = customGray5
            }
        }
    }
   
    @objc func setTheDra1n() {
        let currentDict = Dra1nController.shared.BatteryData()
                
        let dischargeCurrent = currentDict["dischargeCurrent"]!,
            cycles = currentDict["cycles"]!,
            currentCharge = currentDict["currentCapacity"]!,
            designCapacity = currentDict["designCapacity"]!,
            maxCapacity = currentDict["maxCapacity"]!,
            temperature = currentDict["temperature"]!,
            voltage = currentDict["voltage"]! ,
            ramUsage = currentDict["ram"]!
        
        let batteryHealth: String!
        let healthPercent: Double = (Double(maxCapacity) / Double(designCapacity)) * 100
        
        if (healthPercent >= 90) { batteryHealth = "\(NSLocalizedString("great", comment: ""))" } else if (healthPercent >= 85) { batteryHealth = "\(NSLocalizedString("good", comment: ""))" } else { batteryHealth = "\(NSLocalizedString("poor", comment: ""))" }
        
        let roundedCelsius: Double = Double(temperature) / Double(100)
        
        var discharge = 0
        var set = false
        
        let array = CepheiController.shared.getObject(key: "DrainAvarageLog") as? [[String : Any]] ?? [[String : Any]]()
        if (array.count == 0) {
            discharge = abs(dischargeCurrent)
        } else {
            for(index, _) in array.enumerated() {
                let dict = Array(array.suffix(index + 1))
                let item = dict[0]
                let dischargeAverage = abs(item["drain"] as? Int ?? abs(dischargeCurrent))
                if ((dischargeAverage >= 50) && (dischargeAverage <= 500)) {
                    discharge = dischargeAverage
                    set = true
                    break
                }
            }
            if (!set) {
               discharge = abs(dischargeCurrent)
            }
        }
        
        if ((UIDevice.current.batteryState == .full) || (maxCapacity <= currentCharge)) {
            tableData[0][0 + offset] = "\(NSLocalizedString("discharge", comment: ""))"
            tableData[1][0 + offset] = "\(NSLocalizedString("drainingFromYourDevice", comment: ""))"
            
        } else if (UIDevice.current.batteryState == .charging) {
            tableData[1][2 + offset] = "\(NSLocalizedString("timeTillCharged", comment: ""))"
            let powerToCharge = maxCapacity - currentCharge
            let timeLeft: Double = Double(powerToCharge) / Double(discharge)
            if timeLeft.isFinite {
                let hours: Double = Double(Int(timeLeft))
                let minutes: Double = (Double(timeLeft) - Double(Int(timeLeft))) * 60
                tableData[3][2 + offset] = "\(Int(hours))h, \(Int(minutes))m"
            }
    
            tableData[0][0 + offset] = "\(NSLocalizedString("charge", comment: ""))"
            tableData[1][0 + offset] = "\(NSLocalizedString("chargingYourDevice", comment: ""))"
        } else if (UIDevice.current.batteryState == .unplugged) {
            let timeLeft = Double(currentCharge) / Double(discharge)
            if timeLeft.isFinite {
                let hours: Double = Double(Int(timeLeft))
                let minutes: Double = (Double(timeLeft) - Double(Int(timeLeft))) * 60
                tableData[3][2 + offset] = "\(Int(hours))h, \(Int(minutes))m"
            }
            
            tableData[1][2 + offset] = "\(NSLocalizedString("estimateTillDeath", comment: ""))"
            tableData[0][0 + offset] = "\(NSLocalizedString("discharge", comment: ""))"
            tableData[1][0 + offset] = "\(NSLocalizedString("drainingFromYourDevice", comment: ""))"
        } else {
            tableData[1][2 + offset] = "\(NSLocalizedString("unknownState", comment: ""))"
            tableData[3][2 + offset] = "\(NSLocalizedString("unknown", comment: ""))"
        }
         
        
        if CepheiController.shared.getBool(key: "Fahrenheit") {
            let fahrenheit = (roundedCelsius * 9/5) + 32
            tableData[3][4 + offset] = String(format: "%.1f°F", fahrenheit)
        } else {
            tableData[3][4 + offset] = String(format: "%.1f℃", roundedCelsius)
        }
        
        tableData[3][0 + offset] = "\(dischargeCurrent) mA"
        tableData[3][1 + offset] = "\(cycles)"
        tableData[3][3 + offset] = batteryHealth
        tableData[1][3 + offset] = "Your current battery health is \(String(format: "%.2f", healthPercent))%"
        tableData[3][5 + offset] = "\(voltage) mV"
        tableData[3][6 + offset] = "\(ramUsage) MB"
       
        
        self.tableView.reloadData()
    }
    
    func tableSetup() {
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
        
        //Initially
        updateView.isHidden = true
        blurView.isHidden = true
        bannerButton.isEnabled = false
        
        UIDevice.current.isBatteryMonitoringEnabled = true

        tableView.register(UINib(nibName: "MainCell", bundle: nil), forCellReuseIdentifier: "Dra1n.MainCell")
        
        self.colourThings()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setTheDra1n), name: NSNotification.Name(rawValue: "temperatureFormatChange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(colourThings), name: NSNotification.Name(rawValue: "OledModeChange"), object: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.colourThings()
    }
}

extension HomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Make it invisible when you press it
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeViewController : UITableViewDataSource {
    
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
        
        cell.allTheAdjustments()
        return cell
    }
}



extension Notification.Name {
    static let updateBanner = Notification.Name("UpdateNotification")
}
