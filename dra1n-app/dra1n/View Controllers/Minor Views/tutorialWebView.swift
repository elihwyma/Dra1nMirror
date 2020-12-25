//
//  tutorialWebView.swift
//  dra1n
//
//  Created by Domien Fovel on 19/04/2021.
//


import UIKit
import WebKit

class tutorialWebView: UIViewController {
    
    @IBOutlet weak var wkwebview: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wkwebview.scrollView.delegate = self
        wkwebview.backgroundColor = .clear
        NotificationCenter.default.addObserver(self, selector: #selector(functionName), name: Notification.Name("loadTutorialURL"), object: nil)
    
    }
    
    func loadURL(url:String) {
    
    }
    
    @objc func functionName (notification: NSNotification){
        NSLog("YEEHAWW")
        let url = notification.userInfo!["url"] as? String ?? ""
        let web_url = URL(string: url)!
        let web_request = URLRequest(url: web_url)
        wkwebview.load(web_request)
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
          scrollView.pinchGestureRecognizer?.isEnabled = false
        }
    
}



extension tutorialWebView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}
