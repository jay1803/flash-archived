//
//  Note.swift
//  flash (iOS)
//
//  Created by Max Zhang on 2022/4/28.
//

import SwiftUI

struct NoteList: View {
    @ObservedObject var viewModel = NoteListViewModel()
    
    @ViewBuilder
    var body: some View {
        List {
            ForEach(viewModel.notes!) {note in
                Text(note.content!)
            }
        }
        .navigationBarItems(trailing: Button(action: {
            print("Button pressed")
        }) {
            Text("Add")
        })
        .listStyle(.inset)
        .navigationTitle("Notes")
    }

}

struct Note_Previews: PreviewProvider {
    static var previews: some View {
        NoteList()
    }
}
