//
//  onboardingViewController.swift
//  dra1n
//
//  Created by Amy While on 31/07/2020.
//
/*
import UIKit
import SwiftyOnboard

class onboardingViewController: UIViewController {
      
        var swiftyOnboard: SwiftyOnboard!
        var titleArray: [String] = ["Culprits", "Flags", "Monitoring"]
        var subTitleArray: [String] = ["Dra1n will culprit newly installed tweaks if baseline battery discharge increases.", "The culprit list consists of a system of colored flags that will indicate to the user if a tweak was known to drain battery.", "Dra1n is designed to run in the background without any maintenance from the user."]
        var imagesArray: [String] = ["culpritSetup", "flagSetup", "MonitorSetup"]
        
        var gradiant: CAGradientLayer = {
            //Gradiant for the background view
            let blue = UIColor(red: 69/255, green: 127/255, blue: 202/255, alpha: 1.0).cgColor
            let purple = UIColor(red: 166/255, green: 172/255, blue: 236/255, alpha: 1.0).cgColor
            let gradiant = CAGradientLayer()
            gradiant.colors = [purple, blue]
            gradiant.startPoint = CGPoint(x: 0.5, y: 0.18)
            return gradiant
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            gradient()
            
            swiftyOnboard = SwiftyOnboard(frame: view.frame, style: .light)
            view.addSubview(swiftyOnboard)
            swiftyOnboard.dataSource = self
            swiftyOnboard.delegate = self
        
            Dra1nDefaults.shared.set(key: "onboarding", object: true)
        }
        
        override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
        
        func gradient() {
            //Add the gradiant to the view:
            self.gradiant.frame = view.bounds
            view.layer.addSublayer(gradiant)
        }
        
        @objc func handleSkip() {
            swiftyOnboard?.goToPage(index: 2, animated: true)
        }
        
        @objc func handleContinue(sender: UIButton) {
            let index = sender.tag
            swiftyOnboard?.goToPage(index: index + 1, animated: true)
        }
    
        @objc func close(sender: UIButton) {
            performSegue(withIdentifier: "goHome", sender: nil)
        }
    }

    extension onboardingViewController: SwiftyOnboardDelegate, SwiftyOnboardDataSource {
        
        func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
            //Number of pages in the onboarding:
            return 3
        }
        
        func swiftyOnboardBackgroundColorFor(_ swiftyOnboard: SwiftyOnboard, atIndex index: Int) -> UIColor? {
            //Return the background color for the page at index:
            return UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.00)
        }
        
        func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
            let view = SwiftyOnboardPage()
            
            //Set the image on the page:
            view.imageView.image = UIImage(named: imagesArray[index])
            view.imageView.layer.masksToBounds = true
            view.imageView.layer.cornerRadius = 10
            
            //Set the font and color for the labels:
            view.title.font = UIFont(name: "Lato-Heavy", size: 24)
            view.subTitle.font = UIFont(name: "Lato-Regular", size: 16)
            
            //Set the text in the page:
            view.title.text = titleArray[index]
            view.title.textColor = .white
            view.subTitle.textColor = .white
            view.subTitle.text = subTitleArray[index]
            
            //Return the page for the given index:
            return view
        }
        
        func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
            let overlay = SwiftyOnboardOverlay()
            
            //Setup targets for the buttons on the overlay view:
            overlay.skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
            overlay.continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
            
            //Setup for the overlay buttons:
            overlay.continueButton.titleLabel?.font = UIFont(name: "Lato-Bold", size: 16)
            overlay.continueButton.setTitleColor(.white, for: .normal)
            overlay.skipButton.setTitleColor(.white, for: .normal)
            overlay.skipButton.titleLabel?.font = UIFont(name: "Lato-Heavy", size: 16)
            
            //Return the overlay view:
            return overlay
        }
        
        func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
            let currentPage = round(position)
            overlay.pageControl.currentPage = Int(currentPage)
            overlay.continueButton.tag = Int(position)
            
            if currentPage == 0.0 || currentPage == 1.0 {
                overlay.continueButton.setTitle("Continue", for: .normal)
                overlay.skipButton.setTitle("Skip", for: .normal)
                overlay.skipButton.isHidden = false
            } else {
                overlay.continueButton.setTitle("Get Started!", for: .normal)
                overlay.continueButton.addTarget(self, action: #selector(close), for: .touchUpInside)
                overlay.skipButton.isHidden = true
            }
        }
    }
*/
