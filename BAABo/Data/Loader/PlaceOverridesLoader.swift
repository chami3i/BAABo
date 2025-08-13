//
//  PlaceOverridesLoader.swift
//  BAABo
//
//  Created by chaem on 8/12/25.
//

import Foundation

enum PlaceOverridesLoader {
    static func load() -> [PlaceOverride] {
        guard
            let url = Bundle.main.url(forResource: "PlaceOverrides", withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else { return [] }

        return (try? JSONDecoder().decode([PlaceOverride].self, from: data)) ?? []
    }
}
