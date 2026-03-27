//
//  DontaionHistoryVC.swift
//  DemoSignup
//
//  Created by savan soni on 27/03/26.
//


import UIKit

class DontaionHistoryVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    private var categories = donationCategories
    private let vm = DonationHistoryVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.applyCustomStyle(
            title: "Donation History",
            backgroundColor: .clear,
            textColor: .black,
            fontSize: 20,
            iconName: "chevron.left",
            alignment: .leading,
            imagePlacement: .leading,
         
        )
        setupCollectionView()
        setupTableView()
    }
}

extension DontaionHistoryVC {

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
    

        collectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0
        )
        
        collectionView.register(
            UINib(nibName: "DashboardTabsCell", bundle: nil),
            forCellWithReuseIdentifier: "DashboardTabsCell"
        )
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
            
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 16
        }
        
        let nib = UINib(nibName: "DonationHistoryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DonationHistoryCell")
    }
}

extension DontaionHistoryVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "DashboardTabsCell",
            for: indexPath
        ) as! DashboardTabsCell
        
        let category = categories[indexPath.row]
        cell.configure(title: category.title, isSelected: category.isSelected)
        
        return cell
    }
}

extension DontaionHistoryVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let previousIndex = categories.firstIndex(where: { $0.isSelected }) {
            categories[previousIndex].isSelected = false
        }

        categories[indexPath.row].isSelected = true

        collectionView.reloadData()

        collectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
    }
}


extension DontaionHistoryVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let category = categories[indexPath.row]
        let title = category.title
        let tempCell = Bundle.main.loadNibNamed("DashboardTabsCell", owner: nil)?.first as! DashboardTabsCell
        let width = tempCell.requiredWidth(for: title,isSelected: category.isSelected)
        
        return CGSize(width: width, height: collectionView.frame.height * 0.8)
    }
}

// MARK: - TableView Logic
extension DontaionHistoryVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.sectionDates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = vm.sectionDates[section]
        return vm.groupedRecords[date]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let container = UIView()
        container.backgroundColor = .clear
        
        let label = UILabel()
        label.text = vm.sectionDates[section]
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .darkGray
        
        container.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])
        
        return container
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DonationHistoryCell", for: indexPath) as! DonationHistoryCell
        cell.backgroundColor = .white
        cell.contentView.backgroundColor = .white
        
        let date = vm.sectionDates[indexPath.section]
        if let record = vm.groupedRecords[date]?[indexPath.row] {
            let totalRows = vm.groupedRecords[date]?.count ?? 0
            cell.applyCardStyle(at: indexPath, totalRows: totalRows)
            cell.configure(with: record)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
}
