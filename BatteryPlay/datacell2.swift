//
//  datacell2.swift
//  BatteryPlay
//
//  Created by John Allen on 2/8/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

import UIKit

class datacell2: UITableViewCell {

    let batteryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackview = UIStackView(arrangedSubviews: [timeLabel, batteryLabel])
        stackview.distribution = .fillEqually
        stackview.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackview)
        stackview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        stackview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        stackview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        stackview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
