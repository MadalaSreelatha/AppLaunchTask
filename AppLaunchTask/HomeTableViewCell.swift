//
//  HomeTableViewCell.swift
//  AppLaunchTask
//
//  Created by Pavan Kumar on 23/03/21.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstNameLbl : UILabel!
    @IBOutlet weak var emailLbl : UILabel!
    @IBOutlet weak var cardView : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 10.0
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cardView.layer.shadowRadius = 6.0
        cardView.layer.shadowOpacity = 0.7
    }
}
