//
//  FunFactViewModel.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 28/01/2026.
//

import Foundation

class FunFactViewModel: ObservableObject {
    @Published var funFact: [FunFact] = []
    @Published var categories: [FunFactCategory] = []
    @Published var viewState: ViewState = .loading
}
