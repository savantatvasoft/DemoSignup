//
//  DonationCategory.swift
//  DemoSignup
//
//  Created by savan soni on 27/03/26.
//

import Foundation

struct DonationCategory: Identifiable {
    let id: String
    let title: String
    var isSelected: Bool
}


let donationCategories: [DonationCategory] = [
    DonationCategory(id: "all", title: "All", isSelected: true),
    DonationCategory(id: "mosque_donations", title: "Mosque Donations", isSelected: false),
    DonationCategory(id: "projects_donations", title: "Projects Donations", isSelected: false)
]
