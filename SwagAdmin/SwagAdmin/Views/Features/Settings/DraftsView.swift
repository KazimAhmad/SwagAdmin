//
//  DraftsView.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 31/01/2026.
//

import SwiftUI

struct DraftsView: View {
    @StateObject var viewModel: DraftsViewModel
    init(viewModel: DraftsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            switch viewModel.section {
            case .thoughts:
                thoughtsView()
            case .movies:
                moviesView()
            case .books:
                booksView()
            case .funfacts:
                factsView()
            }
        }
        .task {
            viewModel.getDrafts()
        }
        .navigationTitle(viewModel.section.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func thoughtsView() -> some View {
        List {
            ForEach(viewModel.thoughts, id: \.id) { thought in
                ThoughtView(thought: thought)
                    .onTapGesture {
                        viewModel.updateThought(thought)
                    }
                    .listRowInsets(.init())
                    .listRowBackground(Color.clear)
                    .swipeActions {
                        Button {
                            viewModel.delete(thought)
                        } label: {
                            Image(systemName: "trash.circle.fill")
                                .padding()
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, .red)
                        }
                        .tint(.clear)
                    }
            }
        }
        .listStyle(.plain)
    }
    
    func moviesView() -> some View {
        List {
            
        }
        .listStyle(.plain)
    }

    func booksView() -> some View {
        List {
            
        }
        .listStyle(.plain)
    }

    func factsView() -> some View {
        List {
            
        }
        .listStyle(.plain)
    }
}

#Preview {
    DraftsView(viewModel: DraftsViewModel(section: .thoughts,
                                          thoughtRepo: nil))
}
