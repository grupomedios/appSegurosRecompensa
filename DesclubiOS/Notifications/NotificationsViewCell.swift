//
//  NotificationsViewCell.swift
//  DesclubiOS
//
//  Created by Sergio Maturano on 2/1/17.
//  Copyright © 2017 Grupo Medios. All rights reserved.
//

import Foundation

class NotificationsViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescr: UILabel!
    @IBOutlet weak var lblDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCell(not: OSNotification) {
        
        if let heading = not.headings {
            lblTitle.text = heading.getText()
        }

        if let content = not.contents {
            lblDescr.text = content.getText()
        }
        
        lblDate.text = not.getDate()
    }
}
