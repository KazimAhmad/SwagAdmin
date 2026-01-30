//
//  NewThoughtViewModel.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 22/01/2026.
//

import Foundation

@MainActor
class NewThoughtViewModel: ObservableObject {
    @Published var thought: String = ""
    @Published var more: String = ""
    @Published var viewState: ViewState = .info
    
    var dependency: ThoughtRepository?
    var onDismiss: (() -> Void)?
    var didPublish: ((Thought) -> Void)?
    
    init(dependency: ThoughtRepository?,
         onDismiss: (() -> Void)?,
         didPublish: ((Thought) -> Void)?) {
        self.dependency = dependency
        self.onDismiss = onDismiss
        self.didPublish = didPublish
    }
    
    func dismiss() {
        onDismiss?()
    }
    
    func publishThought() {
        if thought.isEmpty && more.isEmpty {
            return
        }
        viewState = .loading
        Task {
            do {
                let newID = try await dependency?.create(thought: thought, more: more)
                finsihPublish(id: newID ?? 0)
            } catch {
                print(error)
            }
        }
    }
    
    func finsihPublish(id: Int) {
        let thought = Thought(id: id,
                              thought: self.thought,
                              more: self.more.isEmpty ? "" : self.more,
                              date: Date())
        self.didPublish?(thought)
        dismiss()
    }
    
    func saveDraft() {
        if thought.isEmpty && more.isEmpty {
            return
        }
        viewState = .loading
        Task {
            do {
                try await dependency?.createCD(thought: thought, more: more)
                viewState = .info
                dismiss()
            } catch {
                print(error)
            }
        }
    }
}
