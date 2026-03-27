//
//  DonationHistoryCell.swift
//  DemoSignup
//
//  Created by savan soni on 27/03/26.
//

import UIKit

class DonationHistoryCell: UITableViewCell {
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var autoDonationButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var userAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.clipsToBounds = true
        // Initialization code
    }
    
    func configure(with record: DonationRecord) {
            userName.text = record.name
        userAddress.text = record.category
            amount.text = record.amount
        userImage.image = UIImage(named: record.image) ?? UIImage(named: "User")
            autoDonationButton.isHidden = !record.isAutoDonation
        }


    @IBAction func onPressDonation(_ sender: Any) {
    }
    
}
