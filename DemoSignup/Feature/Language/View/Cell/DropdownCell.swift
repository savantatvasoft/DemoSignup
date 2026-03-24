////
////  DropdownCell.swift
////  DemoSignup
////
////  Created by MACM72 on 23/03/26.
////
//
//import UIKit
//
//final class DropdownCell: UITableViewCell {
//
//    private let label = UILabel()
//    private let separatorLine = UIView()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        backgroundColor = .clear
//        contentView.backgroundColor = .clear
//        selectionStyle = .none
//
//        label.font = UIFont(name: "Avenir Next", size: 16)?.withTraits(traits: .traitBold)
//        label.textColor = .black
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.6
//        label.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(label)
//
//        separatorLine.backgroundColor = UIColor.black.withAlphaComponent(0.15)
//        separatorLine.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(separatorLine)
//
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            label.heightAnchor.constraint(equalTo: contentView.heightAnchor),
//
//            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            separatorLine.heightAnchor.constraint(equalToConstant: 0.5)
//        ])
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//
//    func configure(title: String, isLast: Bool) {
//        label.text = title
//        separatorLine.isHidden = isLast
//    }
//}
