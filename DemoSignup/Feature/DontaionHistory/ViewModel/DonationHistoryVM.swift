//
//  DonationHistoryVM.swift
//  DemoSignup
//
//  Created by savan soni on 27/03/26.
//

import Foundation

class DonationHistoryVM {
    // Master data
    private let allRecords: [DonationRecord] = [
        DonationRecord(name: "Aqib Hasan", category: "Mosque Donation", amount: "$ 250", date: "23 Aug 2020", image: "user_avatar", isAutoDonation: true),
        DonationRecord(name: "Aqib Hasan", category: "Madarsa Project in Dubai", amount: "$ 1000", date: "23 Aug 2020", image: "user_avatar", isAutoDonation: false),
        DonationRecord(name: "Aqib Hasan", category: "Madarsa Project in Dubai", amount: "$ 1000", date: "23 Aug 2020", image: "user_avatar", isAutoDonation: false),
        DonationRecord(name: "Aqib Hasan", category: "Mosque Donation", amount: "$ 250", date: "22 Aug 2020", image: "user_avatar", isAutoDonation: false)
    ]
    
    var sectionDates: [String] = []
    var groupedRecords: [String: [DonationRecord]] = [:]
    
    init() {
        updateData(for: "all")
    }
    
    func updateData(for categoryId: String) {
        let filtered: [DonationRecord]
        if categoryId == "all" {
            filtered = allRecords
        } else {
            // Filter logic: matching category title (case insensitive)
            filtered = allRecords.filter { $0.category.lowercased().contains(categoryId.replacingOccurrences(of: "_donations", with: "").lowercased()) }
        }
        
        // Grouping
        groupedRecords = Dictionary(grouping: filtered, by: { $0.date })
        sectionDates = groupedRecords.keys.sorted(by: >)
    }
}
