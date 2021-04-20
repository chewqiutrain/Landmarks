//
//  LandmarkList.swift
//  Landmarks
//
//  Created by Yingqiu Lee on 4/18/21.
//

import SwiftUI

struct LandmarkList: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showFavoritesOnly = true
    
    // a `binding` acts as a reference to a mutable state
    
    var filteredLandmarks: [Landmark] {
        modelData.landmarks.filter { landmark in
            (!showFavoritesOnly || landmark.isFavorite)
        }
    }
    
    var body: some View {
        NavigationView {
            /** To combine static and dynamic views in a list OR to combine 2 or more different groups of dynamic views, use ForEach
             */
            List {
                
                /** Does it make sense that the toggle is part of the list?
                 Shouldn't the list contain only data?
                 */
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favourites only")
                }
                
                ForEach(filteredLandmarks) { landmark in
                    NavigationLink(destination: LandmarkDetail(landmark: landmark)) {
                            LandmarkRow(landmark: landmark)
                        
                    }
                }
            }
            .navigationTitle("Landmarks")
        }
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        let phoneList = ["iPhone 12"]
        ForEach(phoneList, id: \.self) { deviceName in
            LandmarkList()
                .environmentObject(ModelData())
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
        
    }
}
