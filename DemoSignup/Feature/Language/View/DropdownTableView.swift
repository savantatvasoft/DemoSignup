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

        // Arrow using plain UIImage — no SymbolConfiguration that inflates size
        let arrowConfig = UIImage.SymbolConfiguration(pointSize: UIConfig.iconSize, weight: .regular)
        arrowImageView.image = UIImage(systemName: "chevron.down", withConfiguration: arrowConfig)
        arrowImageView.tintColor = .black
        arrowImageView.contentMode = .center
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        // Arrow MUST NOT compress or hug — fixed width 36, image centered inside
        arrowImageView.setContentHuggingPriority(.required, for: .horizontal)
        arrowImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        headerView.addSubview(arrowImageView)

        titleLabel.font = UIFont(name: UIConfig.fontName, size: UIConfig.fontSize)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        // Title MUST lose compression fight against arrow
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // Arrow: fixed 36pt wide, pinned right, full height
            arrowImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            arrowImageView.topAnchor.constraint(equalTo: headerView.topAnchor),
            arrowImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 36),

            // Title: pinned left with 16pt padding, right edge = arrow left edge
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
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
        let arrowConfig = UIImage.SymbolConfiguration(pointSize: UIConfig.iconSize, weight: .regular)

        wrapperView.backgroundColor = UIColor(named: "AppYellow") ?? .orange
        wrapperView.layer.cornerRadius = cornerRadius
        wrapperView.layer.cornerCurve  = .continuous
        wrapperView.layer.masksToBounds = true
        wrapperView.frame = CGRect(x: anchorFrame.minX, y: anchorFrame.minY,
                                   width: anchorFrame.width, height: h)
        view.addSubview(wrapperView)

        let header = UIView(frame: CGRect(x: 0, y: 0, width: anchorFrame.width, height: h))
        header.backgroundColor = .clear
        wrapperView.addSubview(header)
        header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleFromHeader)))

        // Arrow — 36pt wide container, image centered inside
        let arrow = UIImageView(frame: CGRect(x: anchorFrame.width - 36, y: 0, width: 36, height: h))
        arrow.image = UIImage(systemName: "chevron.up", withConfiguration: arrowConfig)
        arrow.tintColor = .black
        arrow.contentMode = .center
        header.addSubview(arrow)

        // Title — from x:16 to where arrow starts, full height
        let titleW = anchorFrame.width - 16 - 36
        let title  = UILabel(frame: CGRect(x: 16, y: 0, width: titleW, height: h))
        title.text          = selectedTitle
        title.font          = UIFont(name: UIConfig.fontName, size: UIConfig.fontSize)
        title.textColor     = .black
        title.numberOfLines = 1
        title.lineBreakMode = .byTruncatingTail
        header.addSubview(title)

        tableView.frame           = CGRect(x: 0, y: h, width: anchorFrame.width, height: th)
        tableView.delegate        = self
        tableView.dataSource      = self
        tableView.rowHeight       = rowHeight
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle  = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        if #available(iOS 15.0, *) { tableView.sectionHeaderTopPadding = 0 }
        wrapperView.addSubview(tableView)

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
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
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor             = .clear
        cell.contentView.backgroundColor = .clear
        cell.backgroundView              = nil
        cell.selectionStyle              = .none
        cell.layer.borderWidth           = 0
        cell.layer.borderColor           = UIColor.clear.cgColor

        let label: UILabel
        if let existing = cell.contentView.viewWithTag(101) as? UILabel {
            label = existing
        } else {
            let l = UILabel()
            l.tag           = 101
            l.font          = UIFont(name: UIConfig.fontName, size: UIConfig.fontSize)
            l.textColor     = .black
            l.numberOfLines = 1
            l.lineBreakMode = .byTruncatingTail
            l.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(l)
            NSLayoutConstraint.activate([
                l.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                l.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                l.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                l.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            ])
            label = l
        }
        label.text = items[indexPath.row].uppercased(with: Locale.current)

        let separator: UIView
        if let existing = cell.contentView.viewWithTag(102) {
            separator = existing
        } else {
            let s = UIView()
            s.tag             = 102
            s.backgroundColor = UIColor.black.withAlphaComponent(0.15)
            s.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(s)
            NSLayoutConstraint.activate([
                s.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                s.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                s.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                s.heightAnchor.constraint(equalToConstant: 0.5),
            ])
            separator = s
        }
        separator.isHidden = indexPath.row == items.count - 1

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelect?(items[indexPath.row])
    }
}
