//
//  Profiles.swift
//  Landmarks
//
//  Created by Yingqiu Lee on 5/13/21.
//

import SwiftUI

struct ProfileHost: View {
    /**
     SwiftUI provides storage in the environment for values you can access using the @Environment property wrapper. Access the editMode value to read or write the edit scope.
     */
    @Environment(\.editMode) var editMode
    
    @EnvironmentObject var modelData: ModelData
    
    @State private var draftProfile = Profile.default
    
    var body: some View {
        VStack {
            HStack {
                if editMode?.wrappedValue == .active {
                    Button("Cancel") {
                        draftProfile = modelData.profile
                        editMode?.animation().wrappedValue = .inactive
                    }
                }
                
                Spacer()
                EditButton()
            }
            
            
            if editMode?.wrappedValue == .inactive {
                ProfileSummary(profile: modelData.profile)
            } else {
                ProfileEditor(profile: $draftProfile)
                    .onAppear {
                        draftProfile = modelData.profile
                    }
                    .onDisappear {
                        modelData.profile = draftProfile
                    }
                    
            }
            
        }
        .padding()
    }
}

struct ProfileHost_Previews: PreviewProvider {
    static var previews: some View {
        // ProfileHost does not use an environmentObject, but
        // the child view ProfileSummary does. This is passed
        // onto the child view
        ProfileHost()
            .environmentObject(ModelData())
    }
}
