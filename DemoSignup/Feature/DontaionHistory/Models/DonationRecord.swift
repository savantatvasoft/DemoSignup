//
//  DonationRecord.swift
//  DemoSignup
//
//  Created by savan soni on 27/03/26.
//

import Foundation

struct DonationRecord: Identifiable {
    let id = UUID()
    let name: String
    let category: String // e.g., "Mosque Donation"
    let amount: String   // e.g., "$ 250"
    let date: String     // For grouping headers
    let image: String    // Image name or URL
    let isAutoDonation: Bool
}
