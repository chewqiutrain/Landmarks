//
//  ModelData.swift
//  Landmarks
//
//  Created by Yingqiu Lee on 4/18/21.
//

import Foundation
import Combine

/**
    Observable: custom object for your data that can be bound to a view from storage in SwiftUI's environment
        SwiftUI will watch for any changes to observable objects that could affect a view, and displays the
        correct version of the view after a change.
 */
final class ModelData: ObservableObject {
    //an Observable object need to publish any changes to its data so that its subscribers can pick up the change
    @Published var landmarks: [Landmark] = load("landmarkData.json")
    
    // will never modift hike data after loading, so don't need to publish 
    var hikes: [Hike] = load("hikeData.json")
    
    var features: [Landmark] {
        landmarks.filter { $0.isFeatured }
    }
    
    
    var categories: [String: [Landmark]] {
        Dictionary(
            grouping: landmarks,
            by: { $0.category.rawValue }
        )
    }
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
