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
        // 1. Basic Corner Radius for the white content
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        contentView.layer.maskedCorners = []
        
        // 2. Base Shadow Settings
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 8
        self.layer.masksToBounds = false
        
        let cardWidth = self.bounds.width - 32
        let cardFrame = CGRect(x: 16, y: 0, width: cardWidth, height: self.bounds.height)
        
        // 3. Shadow Logic: Two-Pronged Approach
        if totalRows == 1 {
            // CASE 1: Only one cell in section
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            self.layer.shadowOpacity = 0.05
            self.layer.shadowPath = UIBezierPath(roundedRect: cardFrame, cornerRadius: 20).cgPath
            separatorLayer.isHidden = true
            
        } else {
            // CASE 2: More than one cell in section
            if indexPath.row == 0 {
                // FIRST CELL: Top corners + Top/Side shadows only
                contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

                self.layer.shadowOpacity = 0.01
                self.layer.shadowColor = UIColor.black.cgColor
                self.layer.shadowOffset = CGSize(width: 0, height: -4) // 👈 TOP shadow
                self.layer.shadowRadius = 1
                self.layer.masksToBounds = false

                let cardWidth = self.bounds.width - 32

                // 👇 SHIFT SHADOW AREA UP (hide bottom shadow)
                let topFrame = CGRect(
                    x: 16,
                    y: -10, // 👈 move UP
                    width: cardWidth,
                    height: self.bounds.height
                )

                self.layer.shadowPath = UIBezierPath(
                    roundedRect: topFrame,
                    cornerRadius: 20
                ).cgPath

                separatorLayer.isHidden = false
                
            } else if indexPath.row == totalRows - 1 {
                // LAST CELL: Bottom corners + Bottom/Side shadows only
                contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                self.layer.shadowOpacity = 0.05
                // Extend path UP so top shadow of this cell is hidden
                let bottomFrame = CGRect(x: 16, y: -20, width: cardWidth, height: self.bounds.height + 20)
                self.layer.shadowPath = UIBezierPath(roundedRect: bottomFrame, cornerRadius: 20).cgPath
                separatorLayer.isHidden = true
                
            } else {
                // MIDDLE CELLS: No corners, NO SHADOW
                contentView.layer.maskedCorners = []
                self.layer.shadowOpacity = 0 // Explicitly hide shadow
                separatorLayer.isHidden = false
            }
        }

        self.backgroundColor = .clear
        contentView.backgroundColor = .white
        self.selectionStyle = .none
    }
    
    @IBAction func onPressDonation(_ sender: Any) {
        // handle action
    }
}
