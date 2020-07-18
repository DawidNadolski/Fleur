//
//  PlantTableViewCell.swift
//  Fleur
//
//  Created by Dawid Nadolski on 15/07/2020.
//  Copyright © 2020 Dawid Nadolski. All rights reserved.
//

import UIKit

class PlantsTableViewCell: UITableViewCell {

    @IBOutlet weak var plantLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
