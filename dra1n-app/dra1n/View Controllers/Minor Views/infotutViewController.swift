//
//  infotutViewController.swift
//  dra1n
//
//  Created by Domien Fovel on 12/04/2021.
//


import UIKit



class infotutViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
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
        tableView.register(UINib(nibName: "tutCell", bundle: nil), forCellReuseIdentifier: "tutCell")
        
    }
    
 
}

extension infotutViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



extension infotutViewController : UITableViewDataSource {
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 10;
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tutCell", for: indexPath) as! tutCell
    
        return cell
    }
}
