//
//  RestaurantListViewModel.swift
//  BAABo
//
//  Created by chaem on 8/12/25.
//

import CoreLocation
import SwiftUI

@MainActor
final class RestaurantListViewModel: ObservableObject {
    @Published var items: [Place] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let repo: PlaceRepository
    init(repo: PlaceRepository) { self.repo = repo }
    
    func load(center: CLLocationCoordinate2D, radius: Int, categoryKeyword: String) async {
        isLoading = true; defer { isLoading = false }
        do { items = try await repo.pickSix(center: center, radius: radius, categoryKeyword: categoryKeyword) }
        catch { self.error = error.localizedDescription }
    }
}
