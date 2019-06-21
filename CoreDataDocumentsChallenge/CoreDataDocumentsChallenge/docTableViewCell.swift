//
//  docTableViewCell.swift
//  CoreDataDocumentsChallenge
//
//  Created by John Williams III on 6/16/19.
//  Copyright © 2019 John Williams III. All rights reserved.
//

import UIKit

class docTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(doc: Document){
        self.nameLabel.text = doc.docName
        self.sizeLabel.text = doc.docDescription
        //self.dateLabel.date = doc.docDate
        
    }
    
}
