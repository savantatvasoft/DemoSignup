//
//  RadioOptionView.swift
//  DemoSignup
//
//  Created by MACM72 on 23/03/26.
//

import Foundation
import UIKit

class RadioOptionView: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!


    var onTap: (() -> Void)?

    var isSelectedOption: Bool = false {
        didSet {
            updateUI()
        }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }

    private func loadNib() {
        let view = Bundle.main.loadNibNamed("RadioOptionView", owner: self, options: nil)?.first as! UIView

        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(view)

        setupUI()
        setupGesture()
    }

    // MARK: - Setup

    private func setupUI() {
        containerView.layer.cornerRadius = 7
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray4.cgColor
        updateUI()
    }

    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }

    @objc private func handleTap() {
        onTap?()
    }

    private func updateUI() {
        titleLabel.font = UIFont(name: UIConfig.fontName, size: 15)
        titleLabel.textColor = UIColor(named: "ActiveText")
        if isSelectedOption {
            iconImageView.image = UIImage(named: "Radio")
        } else {
            iconImageView.image = UIImage(named: "UnSelectedRadio")
            iconImageView.tintColor = .lightGray
        }
    }

    // MARK: - Public

    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        self.isSelectedOption = isSelected
    }
}
