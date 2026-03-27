//
//  DashboardTabsCell.swift
//  DemoSignup
//
//  Created by savan soni on 26/03/26.
//

import UIKit

class DashboardTabsCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var text: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetUI()
    }
    
    func requiredWidth(for title: String, isSelected: Bool) -> CGFloat {
        text.text = title
        let labelWidth = text.intrinsicContentSize.width
        let padding: CGFloat = 40
        return labelWidth + padding
    }
    
    // MARK: - Setup
    private func setupUI() {
        containerView.layer.cornerRadius = 17
        containerView.layer.masksToBounds = true
        resetUI()
    }
    
    private func resetUI() {
        containerView.backgroundColor = .systemGray6
        text.textColor = .label
    }
    
    // MARK: - Configure
    func configure(title: String, isSelected: Bool) {
        text.text = title
        updateSelection(isSelected)
    }
    
    private func updateSelection(_ isSelected: Bool) {
        if isSelected {
            containerView.backgroundColor =  UIColor(named: "AppYellow")!
            text.textColor = .black
        } else {
            containerView.backgroundColor = .clear
            text.textColor = UIColor(named: "TextPlaceholder")!
        }
    }
}

