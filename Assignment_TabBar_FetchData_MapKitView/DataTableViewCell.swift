//
//  DataTableViewCell.swift
//  Assignment_TabBar_FetchData_MapKitView
//
//  Created by Mac on 17/01/24.
//

import UIKit

class DataTableViewCell: UITableViewCell {

    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
