//
//  infotutViewController.swift
//  dra1n
//
//  Created by Domien Fovel on 12/04/2021.
//


import UIKit



class InfotutViewController: UIViewController {
    
    
    @objc func colourControl() {
        self.view.backgroundColor = customBackground
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : textColour]
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                self.colourControl()
            }
        }
    }
 
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        self.colourControl()
        
        NotificationCenter.default.addObserver(self, selector: #selector(colourControl), name: NSNotification.Name(rawValue: "OledModeChange"), object: nil)
      
        
    }
    

    
    func setup() {
        
        tableView.backgroundColor = .none

        tableView.tableFooterView = UIView()

        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false

        tableView.dataSource = self
        tableView.delegate = self
     
        tableView.alwaysBounceVertical = true
        tableView.register(UINib(nibName: "TutCell", bundle: nil), forCellReuseIdentifier: "Dra1n.TutCell")
        
    }
    
 
}

extension InfotutViewController : UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            self.performSegue(withIdentifier: "ShowVerse", sender: nil)
            let dic = ["url":"https://api.dra1n.app/v1/tutorial"]
            NotificationCenter.default.post(name: Notification.Name("loadTutorialURL"), object:nil , userInfo: dic)
        }
        
        if indexPath.section == 1 {
            self.performSegue(withIdentifier: "ShowVerse", sender: nil)
            let dic = ["url":"https://api.dra1n.app/v1/isecureos"]
            NotificationCenter.default.post(name: Notification.Name("loadTutorialURL"), object:nil , userInfo: dic)
        }

    }
    
    


    
 

    
    
   
}



extension InfotutViewController : UITableViewDataSource {
    

    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        1
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Dra1n.TutCell", for: indexPath) as! TutCell
        
        print("YEET",indexPath.section)
        if indexPath.section == 0 {
            
            let backgroundImage = UIImageView(frame: CGRect(x: 0, y: cell.bounds.minY, width: UIScreen.main.bounds.width, height: 200))

            backgroundImage.image = UIImage(named: "infothumbnail")
            backgroundImage.contentMode = .scaleAspectFill
            backgroundImage.center = cell.center
            
            if #available(iOS 13.0, *) {
                let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemMaterial)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = view.bounds
                blurEffectView.alpha = 0.9633443453
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                backgroundImage.addSubview(blurEffectView)
            }
            
            let overlapview = UIView()
            overlapview.frame = view.bounds
            overlapview.alpha = 0.2
            overlapview.backgroundColor = customBackground
            overlapview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backgroundImage.addSubview(overlapview)


            cell.clipsToBounds = true
            cell.insertSubview(backgroundImage, at: 0)
            
            
            
            cell.title.text = "Dra1n Tutorial"
            cell.descriptionText.text = "How to use Dra1n and what it does."
            
            if #available(iOS 13.0, *) {
                cell.dra1nImageView.image = UIImage(systemName: "play.circle.fill")

            }
            
           
            
           
        }
        
        
        if indexPath.section == 1 {
            
            let backgroundImage = UIImageView(frame: CGRect(x: 0, y: cell.bounds.minY, width: UIScreen.main.bounds.width, height: 200))

            backgroundImage.image = UIImage(named: "isecure")
            backgroundImage.contentMode = .scaleAspectFill
            backgroundImage.center = cell.center
            
            if #available(iOS 13.0, *) {
                let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemMaterial)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = view.bounds
                blurEffectView.alpha = 0.9633443453
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                backgroundImage.addSubview(blurEffectView)
              
     
            }
            
            let overlapview = UIView()
            overlapview.frame = view.bounds
            overlapview.alpha = 0.2
            overlapview.backgroundColor = customBackground
            overlapview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backgroundImage.addSubview(overlapview)


            cell.clipsToBounds = true
            cell.insertSubview(backgroundImage, at: 0)
            
            
            
            cell.title.text = "Jailbreak Safety"
            cell.descriptionText.text = "Keep your jailbreak safe from malware or hacking."
            
            if #available(iOS 13.0, *) {
                cell.dra1nImageView.image = UIImage(systemName: "play.circle.fill")

            }
            
           
            
           
        }
        
        
        
        if indexPath.section == 2 {
            
            
            
            
            cell.title.text = "More coming"
            cell.descriptionText.text = "We plan on updating this page shortly."
            
   
        
            
           
            
           
        }



        
        cell.allTheAdjustments()
        return cell
    }
}
