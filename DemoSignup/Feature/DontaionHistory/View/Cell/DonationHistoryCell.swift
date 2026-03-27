//
//  DonationHistoryCell.swift
//  DemoSignup
//
//  Created by savan soni on 27/03/26.
//

import UIKit

class DonationHistoryCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var autoDonationButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var userAddress: UILabel!
    
    // Programmatic separator layer
    private let separatorLayer = CALayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Image Styling
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.clipsToBounds = true
        containerView.backgroundColor = .white
        
        // Setup Separator Appearance
        separatorLayer.backgroundColor = UIColor.systemGray5.cgColor
        contentView.layer.addSublayer(separatorLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let horizontalPadding: CGFloat = 10
        let lineHeight: CGFloat = 1
        
        separatorLayer.frame = CGRect(
            x: horizontalPadding,
            y: contentView.frame.height - lineHeight,
            width: contentView.frame.width - (horizontalPadding * 2),
            height: lineHeight
        )
    }
    
    // MARK: - Configure Data
    func configure(with record: DonationRecord) {
        userName.text = record.name
        userAddress.text = record.category
        amount.text = record.amount
        userImage.image = UIImage(named: record.image) ?? UIImage(named: "User")
        autoDonationButton.isHidden = !record.isAutoDonation
    }
    
    func applyCardStyle(at indexPath: IndexPath, totalRows: Int) {
    
        contentView.layer.cornerRadius = 12
        contentView.layer.maskedCorners = []
        
        // 2. Section Rounding Logic & Separator Visibility
        if totalRows == 1 {
            // Single cell in section: round all corners, hide separator
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            separatorLayer.isHidden = true
        } else if indexPath.row == 0 {
            // Top cell: round top corners, show separator
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            separatorLayer.isHidden = false
        } else if indexPath.row == totalRows - 1 {
            // Bottom cell: round bottom corners, HIDE separator
            contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            separatorLayer.isHidden = true
        } else {
            // Middle cell: no rounding, show separator
            contentView.layer.maskedCorners = []
            separatorLayer.isHidden = false
        }
        
        // 3. UI Cleanup
        self.backgroundColor = .clear
        contentView.backgroundColor = .white
        self.selectionStyle = .none
    }
    
    @IBAction func onPressDonation(_ sender: Any) {
        // handle action
    }
}
