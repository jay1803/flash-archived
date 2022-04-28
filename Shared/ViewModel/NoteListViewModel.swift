//
//  NoteListViewModel.swift
//  flash (iOS)
//
//  Created by Max Zhang on 2022/4/28.
//

import Foundation
import Combine
import WCDBSwift

public class NoteListViewModel: ObservableObject {
    @Published var notes: [Note]?
    @Published var isLoading: Bool = true
    
    init() {
        let note = Note()
        note.content = "123"
        self.notes = [note]
    }
    
    func queryNotes() {
        let properties: [Property] = Note.Properties.all
        let condition = Note.Properties.id > 0
        let order: OrderBy = Note.Properties.id.asOrder(by: .descending)
        
        self.notes = DatabaseManager.shared.queryList(properties: properties, condition: condition, orderList: [order], limit: nil, offset: nil)
        self.isLoading = false
    }
    
    func addNotes(content: String) {
        let note = Note()
        note.content = content
        note.createdAt = Date()
        note.updatedAt = Date()
        
        do {
            try DatabaseManager.shared.begin()
            
            try DatabaseManager.shared.insert(objects: [note])
            
            try DatabaseManager.shared.commit()
        } catch {
            try? DatabaseManager.shared.rollback()
        }
        
        self.queryNotes()
    }
}
