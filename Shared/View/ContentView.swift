//
//  ContentView.swift
//  Shared
//
//  Created by Max Zhang on 2022/4/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            NoteList()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
