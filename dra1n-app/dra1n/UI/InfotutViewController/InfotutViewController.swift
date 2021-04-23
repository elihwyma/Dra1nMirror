//
//  infotutViewController.swift
//  dra1n
//
//  Created by Domien Fovel on 12/04/2021.
//


import UIKit



class InfotutViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }
    
    func setup() {
        self.view.backgroundColor = .dra1nBackground
        
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
    }
}



extension InfotutViewController : UITableViewDataSource {
    

    func numberOfSections(in tableView: UITableView) -> Int {
        10
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        1
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Dra1n.TutCell", for: indexPath) as! TutCell
        
        cell.allTheAdjustments()
        return cell
    }
}
