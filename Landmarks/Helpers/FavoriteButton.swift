//
//  FavoriteButton.swift
//  Landmarks
//
//  Created by Yingqiu Lee on 4/20/21.
//

import SwiftUI

struct FavoriteButton: View {
    
    //https://developer.apple.com/forums/thread/120394
    
    /**
        Binding property is used to pass read/write data from one view to another. It is never the source of truth, only a reference to a source of truth that already exists.
     
        @State is used when the data is completely local to the view
        @BindableObject is used when the data in the model that the view needs to read/write to
     */
    
    @Binding var isSet: Bool
    
    var body: some View {
        Button(action: {
            isSet.toggle()
        }) {
            Image(systemName: isSet ? "star.fill" : "star")
                .foregroundColor(isSet ? Color.yellow : Color.gray)
        }
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        // .constant creates a binding with an immutable value
        FavoriteButton(isSet: .constant(true))
    }
}
