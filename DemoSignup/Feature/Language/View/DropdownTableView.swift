//
//  DropdownTableView.swift
//  DemoSignup
//
//  Created by MACM72 on 23/03/26.
//

import UIKit

class DropdownTableView: UIView {

    private var dropdownWindow: UIWindow?
    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let arrowImageView = UIImageView()

    var items: [String] = [] {
        didSet { selectedItem = items.first }
    }

    var selectedItem: String? {
        didSet { titleLabel.text = selectedItem?.uppercased(with: Locale.current) }
    }

    var onSelect: ((String) -> Void)?

    private let rowHeight: CGFloat = 40
    private let cornerRadius: CGFloat = 18

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        backgroundColor = .clear
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor

        headerView.backgroundColor = UIColor(named: "AppYellow") ?? .orange
        headerView.layer.cornerRadius = cornerRadius
        headerView.layer.cornerCurve = .continuous
        headerView.layer.masksToBounds = true
        headerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerView)

        let arrowConfig = UIImage.SymbolConfiguration(pointSize: 9, weight: .regular)
        arrowImageView.image = UIImage(systemName: "chevron.down", withConfiguration: arrowConfig)
        arrowImageView.tintColor = .black
        arrowImageView.contentMode = .center
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(arrowImageView)

        titleLabel.font = UIFont(name: UIConfig.fontName, size: UIConfig.fontSize)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            arrowImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -2),
            arrowImageView.topAnchor.constraint(equalTo: headerView.topAnchor),
            arrowImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleDropdown))
        headerView.addGestureRecognizer(tap)
    }

    @objc private func toggleDropdown() {
        dropdownWindow != nil ? dismissDropdown() : showDropdown()
    }

    private func showDropdown() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }

        let frameOnScreen = convert(bounds, to: nil)
        let window = UIWindow(windowScene: scene)
        window.windowLevel = .alert + 1
        window.backgroundColor = .clear

        let vc = DropdownPopupVC()
        vc.items = items.filter { $0 != selectedItem }
        vc.anchorFrame = frameOnScreen
        vc.rowHeight = rowHeight
        vc.cornerRadius = cornerRadius
        vc.selectedTitle = selectedItem?.uppercased(with: Locale.current) ?? ""

        vc.onSelect = { [weak self] selected in
            self?.selectedItem = selected
            self?.onSelect?(selected)
            self?.dismissDropdown()
        }
        vc.onDismiss = { [weak self] in self?.dismissDropdown() }

        window.rootViewController = vc
        window.makeKeyAndVisible()
        dropdownWindow = window

        UIView.animate(withDuration: 0.2) {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }

    private func dismissDropdown() {
        dropdownWindow?.isHidden = true
        dropdownWindow = nil
        UIView.animate(withDuration: 0.2) {
            self.arrowImageView.transform = .identity
        }
    }
}

class DropdownPopupVC: UIViewController {

    var items: [String] = []
    var anchorFrame: CGRect = .zero
    var rowHeight: CGFloat = 40
    var cornerRadius: CGFloat = 20
    var selectedTitle: String = ""
    var onSelect: ((String) -> Void)?
    var onDismiss: (() -> Void)?

    private let wrapperView = UIView()
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        setupWrapper()
    }

    private func setupWrapper() {
        let h  = anchorFrame.height
        let th = CGFloat(items.count) * rowHeight

        // Shadow container
        let shadowContainer = UIView(frame: CGRect(x: anchorFrame.minX,
                                                   y: anchorFrame.minY,
                                                   width: anchorFrame.width,
                                                   height: h))
        shadowContainer.backgroundColor = .clear
        shadowContainer.layer.shadowColor = UIColor.black.cgColor
        shadowContainer.layer.shadowOpacity = 0.2
        shadowContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        shadowContainer.layer.shadowRadius = 8
        shadowContainer.layer.masksToBounds = false

        view.addSubview(shadowContainer)

        // Rounded wrapper inside shadow container
        wrapperView.frame = shadowContainer.bounds
        wrapperView.backgroundColor = UIColor(named: "AppYellow") ?? .orange
        wrapperView.layer.cornerRadius = cornerRadius
        wrapperView.layer.cornerCurve = .continuous
        wrapperView.layer.masksToBounds = true // clip content
        shadowContainer.addSubview(wrapperView)

        // MARK: - HEADER
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.addSubview(header)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            header.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: h)
        ])

        header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleFromHeader)))

        let arrowImageView = UIImageView()
        let arrowConfig = UIImage.SymbolConfiguration(pointSize: 9, weight: .regular)
        arrowImageView.image = UIImage(systemName: "chevron.up", withConfiguration: arrowConfig)
        arrowImageView.tintColor = .black
        arrowImageView.contentMode = .center
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.setContentHuggingPriority(.required, for: .horizontal)
        arrowImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        header.addSubview(arrowImageView)

        let titleLabel = UILabel()
        titleLabel.text = selectedTitle
        titleLabel.font = UIFont(name: UIConfig.fontName, size: UIConfig.fontSize)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            arrowImageView.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -10),
            arrowImageView.topAnchor.constraint(equalTo: header.topAnchor),
            arrowImageView.bottomAnchor.constraint(equalTo: header.bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: header.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: header.bottomAnchor),
        ])

        wrapperView.layoutIfNeeded()

        // MARK: - TableView
        tableView.frame = CGRect(x: 0, y: h, width: anchorFrame.width, height: th)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = rowHeight
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.tableHeaderView = UIView(frame: .zero)
        tableView.tableFooterView = UIView(frame: .zero)
        if #available(iOS 15.0, *) { tableView.sectionHeaderTopPadding = 0 }
        wrapperView.addSubview(tableView)

        // Animate dropdown
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            shadowContainer.frame.size.height = h + th
            self.wrapperView.frame.size.height = h + th
        }
    }
    

    @objc private func toggleFromHeader() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
            self.wrapperView.frame.size.height = self.anchorFrame.height
        } completion: { _ in self.onDismiss?() }
    }

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        if !wrapperView.frame.contains(gesture.location(in: view)) { onDismiss?() }
    }
}


extension DropdownPopupVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.selectionStyle = .none

        let item = items[indexPath.row]
        let label = UILabel()
        label.text = item.uppercased(with: Locale.current)
        label.font = UIFont(name: UIConfig.fontName, size: UIConfig.fontSize)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 0
        label.layer.masksToBounds = true
        
        let isSelected = item.uppercased(with: Locale.current) == selectedTitle.uppercased(with: Locale.current)
        if isSelected {
            label.backgroundColor = UIColor(named: "AppYellow") ?? .systemOrange
            label.textColor = .black
        } else {
            label.backgroundColor = .white
            label.textColor = .black
        }

        cell.contentView.addSubview(label)

        // MARK: - Constraints with Padding
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: 0),
            label.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 0),
            label.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 0),
        ])

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10 // Adjust this for more or less space at the bottom
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelect?(items[indexPath.row])
    }
}
