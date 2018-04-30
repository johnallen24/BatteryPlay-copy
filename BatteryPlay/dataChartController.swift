//
//  dataChartController.swift
//  BatteryPlay
//
//  Created by John Allen on 2/8/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

import UIKit


class dataChartController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var batteryLevels : [Double] = []
    var times: [Double] = []
    
    let headerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dataTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var timeHeaderTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Time(s)"
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
//    var timeHeaderTextView: UILabel = {
//        let label = UILabel()
//        label.text = "Time(s)"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.boldSystemFont(ofSize: 20)
//        label.textAlignment = .center
//        return label
//    }()
    
    var batteryLevelHeaderTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Voltage(V)"
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
//    var batteryLevelHeaderTextView: UILabel = {
//        let label = UILabel()
//        label.text = "Battery Level(%)"
//        label.font = UIFont.boldSystemFont(ofSize: 20)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .center
//        return label
//    }()

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        
        
    
    }
    
    private func setupViews() {
        
        view.addSubview(dataTable)
        
        
        let headerStackView = UIStackView(arrangedSubviews: [timeHeaderTextView, batteryLevelHeaderTextView] )
        
       view.addSubview(headerStackView)
        
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        headerStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08).isActive = true
        headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        headerStackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        headerStackView.distribution = .fillEqually
        
        
        dataTable.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 0).isActive = true
        dataTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        dataTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        dataTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        dataTable.delegate = self
        dataTable.dataSource = self
        dataTable.register(datacell2.self, forCellReuseIdentifier: "cell")
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! datacell2
       
        cell.timeLabel.text = String(times[indexPath.row])
        cell.batteryLabel.text = String(batteryLevels[indexPath.row])
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: "heythere", sender: nil) 
    }
    
    
    
    
    
    
}

