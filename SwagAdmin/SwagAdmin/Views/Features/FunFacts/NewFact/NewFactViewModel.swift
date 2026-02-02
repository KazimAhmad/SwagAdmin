//
//  NewThoughtViewModel.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 22/01/2026.
//

import Foundation

@MainActor
class NewFactViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var category: FunFactCategory?
    @Published var link: String?

    @Published var viewState: ViewState = .info
    var categories: [FunFactCategory] = []
    
    var dependency: FactRepository?
    var onDismiss: (() -> Void)?
    var didPublish: ((FunFact) -> Void)?
    var didSaveDraft: ((FunFact) -> Void)? = nil

    init(categories: [FunFactCategory],
         dependency: FactRepository?,
         onDismiss: (() -> Void)?,
         didPublish: ((FunFact) -> Void)?,
         didSaveDraft: ((FunFact) -> Void)? = nil,
         existingFact: FunFact? = nil) {
        self.categories = categories
        self.dependency = dependency
        self.onDismiss = onDismiss
        self.didPublish = didPublish
        self.didSaveDraft = didSaveDraft
        if let existingFact = existingFact {
            self.title = existingFact.title
            self.description = existingFact.description
            self.category = existingFact.category
            self.link = existingFact.link
        }
    }
    
    func dismiss() {
        onDismiss?()
    }
    
    func publishThought() {
        if title.isEmpty && description.isEmpty {
            return
        }
        guard let category else {
            return
        }
        viewState = .loading
        Task {
            do {
                let newID = try await dependency?.create(fact: FunFact.init(id: 0,
                                                                            title: title,
                                                                            description: description,
                                                                            category: category,
                                                                            link: link))
                finsihPublish(id: newID ?? 0)
            } catch {
                print(error)
                viewState = .info
            }
        }
    }
    
    func finsihPublish(id: Int) {
        guard let category else {
            return
        }
        let fact = FunFact(id: id,
                           title: title,
                           description: description,
                           category: category,
                           link: link)
        self.didPublish?(fact)
        dismiss()
    }
    
    func finsihDrafts(id: Int) {
        guard let category else {
            return
        }
        let fact = FunFact(id: id,
                           title: title,
                           description: description,
                           category: category,
                           link: link)
        self.didSaveDraft?(fact)
        dismiss()
    }
    
    func saveDraft() {
        if title.isEmpty && description.isEmpty {
            return
        }
        guard let category else {
            return
        }
        viewState = .loading
        Task {
            do {
                let newID = try await dependency?.createCD(fact: FunFact(id: 0,
                                                                         title: title,
                                                                         description: description,
                                                                         category: category,
                                                                         link: link))
                viewState = .info
                finsihDrafts(id: newID ?? 0)
                dismiss()
            } catch {
                print(error)
                viewState = .info
            }
        }
    }
}
