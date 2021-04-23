//
//  privacyPolicyViewController.swift
//  dra1n
//
//  Created by Amy While on 24/07/2020.
//

import UIKit
import SwiftyMarkdown

class PrivacyViewController: UIViewController {
    
    @IBOutlet weak var privacyPolicy: ColourAwareTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        decline.layer.cornerRadius = 10
        accept.layer.cornerRadius = 10
        
        getTheMarkdown()
        colourControl()
        
        NotificationCenter.default.addObserver(self, selector: #selector(colourControl), name: NSNotification.Name(rawValue: "OledModeChange"), object: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.colourControl()
    }
    
    @objc func colourControl() {
        self.view.backgroundColor = .secondaryBackground
    }
    
    @IBOutlet weak var decline: UIButton!
    @IBAction func decline(_ sender: Any) {
        Dra1nDefaults.set(key: "privacyPolicy", object: false)
        Dra1nDefaults.set(key: "NewHasAsked", object: true)
        if !Dra1nDefaults.getBool(key: "onboarding") {
           performSegue(withIdentifier: "showOnboarding", sender: nil)
        } else { self.dismiss(animated: true, completion: nil) }
    }
    
    @IBOutlet weak var accept: UIButton!
    @IBAction func accept(_ sender: Any) {
        Dra1nDefaults.set(key: "privacyPolicy", object: true)
        Dra1nDefaults.set(key: "NewHasAsked", object: true)
        if !Dra1nDefaults.getBool(key: "onboarding") {
           performSegue(withIdentifier: "showOnboarding", sender: nil)
        } else { self.dismiss(animated: true, completion: nil) }
    }
    
    func getTheMarkdown()  {
        DispatchQueue.global(qos: .utility).async {
            do {
                var request = URLRequest(url: URL(string: "https://\(endpoint()).dra1n.app/V1/policy")!)
                request.httpMethod = "GET"
                request.setValue(Dra1nController.installedVersion, forHTTPHeaderField: "tweakVersion")
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
                    if (data != nil) {
                        let content = String(decoding: data!, as: UTF8.self)
                        let md = SwiftyMarkdown(string: content)
                        
                        DispatchQueue.main.async {
                            if (content != "") {
                                self.privacyPolicy.attributedText = md.attributedString()
                            }
                        }
                    }
                }
                task.resume()
            }
        }
    }
}

