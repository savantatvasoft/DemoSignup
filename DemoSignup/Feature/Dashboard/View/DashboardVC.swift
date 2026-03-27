//
//  DashboardVC.swift
//  DemoSignup
//
//  Created by savan soni on 26/03/26.
//

import UIKit

class DashboardVC: UIViewController {
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomCardView: UIView!
    @IBOutlet weak var bottomLabel: UILabel!
    
    @IBOutlet weak var setView: UIView!
    
    var vm = DashboardVM()
    
    let items = ["Home", "Profile", "Settings", "About", "Help"]
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomCardView.layer.cornerRadius = 25
        bottomCardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomCardView.clipsToBounds = true
        
        setupUI()
        setupCollectionView()
        bindData()
    }
}

// MARK: - Setup
extension DashboardVC {
    
    private func setupUI() {
        blurView.layer.cornerRadius = 20
        blurView.clipsToBounds = true
        blurView.layer.cornerCurve = .continuous
        setView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSetViewTap))
        setView.addGestureRecognizer(tapGesture)
        setupAttributedLabel()
    }
    
    @objc private func handleSetViewTap() {
        
        performSegue(withIdentifier: "DontaionHistoryVCID", sender: self)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        let sideInset = (view.frame.width / 2) - 60
        
        collectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: sideInset,
            bottom: 0,
            right: sideInset
        )
        
        collectionView.register(
            UINib(nibName: "DashboardTabsCell", bundle: nil),
            forCellWithReuseIdentifier: "DashboardTabsCell"
        )
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 10
        }
    }
    
    private func bindData() {
        name.text = vm.userName
        address.text = vm.userAddress
    }
    
    func setupAttributedLabel() {
        let fullText = "Set Al Fateh Mosque as your default Mosque?"
        let boldPart = "Al Fateh Mosque"
        let regularFont = UIFont(name: "AvenirNext-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16)
        let boldFont = UIFont(name: "AvenirNext-Bold", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [
            .font: regularFont,
            .foregroundColor: UIColor.white
        ])
        let range = (fullText as NSString).range(of: boldPart)
        attributedString.addAttribute(.font, value: boldFont, range: range)
        bottomLabel.attributedText = attributedString
    }
}

extension DashboardVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "DashboardTabsCell",
            for: indexPath
        ) as! DashboardTabsCell
        
        let isSelected = indexPath.row == selectedIndex
        cell.configure(title: items[indexPath.row], isSelected: isSelected)
        
        return cell
    }
}

extension DashboardVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let previousIndex = selectedIndex
        selectedIndex = indexPath.row
        
        collectionView.reloadItems(at: [
            IndexPath(row: previousIndex, section: 0),
            indexPath
        ])
        
        collectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
    }
}

// MARK: Cell Size
extension DashboardVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 90, height: collectionView.frame.height * 0.8)
    }
}
