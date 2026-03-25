//
//  GooglePlacesManager.swift
//  DemoSignup
//
//  Created by savan soni on 25/03/26.
//

import Foundation
import GooglePlaces

// MARK: - Model
struct PlaceResult {
    let address: String
    let latitude: Double
    let longitude: Double
}

// MARK: - Manager
final class GooglePlacesManager {

    static let shared = GooglePlacesManager()
    private let client = GMSPlacesClient.shared()

    // 🔥 IMPORTANT: Session token (improves results + billing grouping)
    private var sessionToken: GMSAutocompleteSessionToken?

    private init() {}

    // MARK: - Start Session
    func startSession() {
        sessionToken = GMSAutocompleteSessionToken.init()
    }

    // MARK: - End Session
    func endSession() {
        sessionToken = nil
    }

    // MARK: - Fetch Predictions
    func fetchPlaces(query: String, completion: @escaping ([GMSAutocompletePrediction]) -> Void) {
        guard !query.isEmpty else {
            completion([])
            return
        }

        let filter = GMSAutocompleteFilter()
        // Fix: Explicitly provide the string representation Google expects
        filter.types = ["address"]

        client.findAutocompletePredictions(
            fromQuery: query,
            filter: filter,
            sessionToken: sessionToken
        ) { results, error in
            if let error = error {
                print("❌ Places Error:", error.localizedDescription)
                completion([])
                return
            }
            completion(results ?? [])
        }
    }

    // MARK: - Fetch Place Details (Address + LatLng)
    func fetchPlaceDetails(placeID: String,
                           completion: @escaping (PlaceResult?) -> Void) {

        let fields: GMSPlaceField = [
            .formattedAddress,
            .coordinate
        ]

        client.fetchPlace(
            fromPlaceID: placeID,
            placeFields: fields,
            sessionToken: sessionToken
        ) { [weak self] place, error in

            // 🔥 End session after selection
            self?.endSession()

            if let error = error {
                print("❌ Details Error:", error.localizedDescription)
                completion(nil)
                return
            }

            guard let place = place else {
                completion(nil)
                return
            }

            let result = PlaceResult(
                address: place.formattedAddress ?? "",
                latitude: place.coordinate.latitude,
                longitude: place.coordinate.longitude
            )

            completion(result)
        }
    }
}
