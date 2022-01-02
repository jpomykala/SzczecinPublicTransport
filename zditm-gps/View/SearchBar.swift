//
//  SearchBar.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 02/01/2022.
//  Copyright © 2022 Jakub Pomykała. All rights reserved.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
 
    @State private var isEditing = false
    
    var body: some View {
            HStack {
                HStack{
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Wyszukaj linię autobusową lub tramawajową", text: $text)
                        .onTapGesture {
                            self.isEditing = true
                        }
                }
                .padding(8)
                .background(Color(.systemGray6))

                    .cornerRadius(8)
                
     
                if isEditing {
                    Button(action: {
                        self.isEditing.toggle()
                        self.text = ""
     
                    }) {
                        Text("Cancel")
                    }
                    .padding(.horizontal, 10)
                    .transition(.move(edge: .trailing))
                    .animation(.default)
                }
            }
        }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
    }
}
