////
////  DropdownVC.swift
////  DemoSignup
////
////  Created by MACM72 on 23/03/26.
////
//
//import UIKit
//
//final class DropdownVC: UIViewController {
//
//    var items: [String] = []
//    var anchorFrame: CGRect = .zero
//    var rowHeight: CGFloat = 44
//    var cornerRadius: CGFloat = 20
//    var selectedTitle: String = ""
//
//    var onSelect: ((String) -> Void)?
//    var onDismiss: (() -> Void)?
//
//    private let wrapperView = UIView()
//    private let tableView = UITableView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .clear
//
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//
//        setupUI()
//    }
//
//    private func setupUI() {
//        let headerHeight = anchorFrame.height
//        let tableHeight = CGFloat(items.count) * rowHeight
//        let totalHeight = headerHeight + tableHeight
//
//        wrapperView.backgroundColor = .orange
//        wrapperView.layer.cornerRadius = cornerRadius
//        wrapperView.frame = CGRect(
//            x: anchorFrame.minX,
//            y: anchorFrame.minY,
//            width: anchorFrame.width,
//            height: headerHeight
//        )
//        view.addSubview(wrapperView)
//
//        setupHeader(height: headerHeight)
//        setupTable(headerHeight: headerHeight, tableHeight: tableHeight)
//
//        UIView.animate(withDuration: 0.25) {
//            self.wrapperView.frame.size.height = totalHeight
//        }
//    }
//
//    private func setupHeader(height: CGFloat) {
//        let header = UIView(frame: CGRect(x: 0, y: 0, width: anchorFrame.width, height: height))
//        header.backgroundColor = .orange
//        wrapperView.addSubview(header)
//
//        let arrow = UIImageView(image: UIImage(systemName: "chevron.up"))
//        arrow.tintColor = .black
//        arrow.frame = CGRect(x: anchorFrame.width - 36, y: (height - 20)/2, width: 20, height: 20)
//        header.addSubview(arrow)
//
//        let title = UILabel(frame: CGRect(x: 16, y: 0, width: anchorFrame.width - 60, height: height))
//        title.text = selectedTitle
//        title.font = UIFont(name: "Avenir Next", size: 16)?.withTraits(traits: .traitBold)
//        title.adjustsFontSizeToFitWidth = true
//        title.minimumScaleFactor = 0.6
//        header.addSubview(title)
//
//        let tap = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
//        header.addGestureRecognizer(tap)
//    }
//
//    private func setupTable(headerHeight: CGFloat, tableHeight: CGFloat) {
//        tableView.frame = CGRect(x: 0, y: headerHeight, width: anchorFrame.width, height: tableHeight)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(DropdownCell.self, forCellReuseIdentifier: "DropdownCell")
//        tableView.rowHeight = rowHeight
//        tableView.separatorStyle = .none
//        tableView.backgroundColor = .clear
//        tableView.isScrollEnabled = false
//        wrapperView.addSubview(tableView)
//    }
//
//    @objc private func headerTapped() {
//        UIView.animate(withDuration: 0.2) {
//            self.wrapperView.frame.size.height = self.anchorFrame.height
//        } completion: { _ in
//            self.onDismiss?()
//        }
//    }
//
//    @objc private func handleOutsideTap(_ gesture: UITapGestureRecognizer) {
//        if !wrapperView.frame.contains(gesture.location(in: view)) {
//            onDismiss?()
//        }
//    }
//}
//
//extension DropdownVC: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        items.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(
//            withIdentifier: "DropdownCell",
//            for: indexPath
//        ) as! DropdownCell
//
//        cell.configure(
//            title: items[indexPath.row],
//            isLast: indexPath.row == items.count - 1
//        )
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        onSelect?(items[indexPath.row])
//    }
//}
