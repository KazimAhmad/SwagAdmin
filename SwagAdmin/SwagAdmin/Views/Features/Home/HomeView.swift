//
//  HomeView.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 21/01/2026.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            switch viewModel.viewState {
            case .loading:
                LoadingView()
            case .error(_):
                AlertView()
            case .empty:
                ThoughtView(thought: Thought(id: 0,
                                             thought: "",
                                             more: "",
                                             date: Date()), seeMore: {})
            case .info:
                thoughtList()
            }
        }
        .task {
            viewModel.getThoughts()
        }
        .navigationTitle("Thoughts")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.goToNewThought()
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(Color.white)
                        .padding(8)
                        .background(
                            Circle()
                                
                        )
                }
            }
        }
    }
    
    func thoughtList() -> some View {
        VStack {
            List {
                ForEach(viewModel.thoughts, id: \.id) { thought in
                    ThoughtView(thought: thought) {
                        viewModel.seeMore(of: thought)
                    }
                    .listRowInsets(.init())
                    .listRowBackground(Color.clear)
                    .swipeActions {
                        Button {
                            viewModel.showAlertToDelete(thought: thought)
                        } label: {
                            Image(systemName: "trash.circle.fill")
                                .padding()
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, .red)
                        }
                        .tint(.clear)
                    }
                }
                if viewModel.hasMoreThoughts() {
                    LoadingView()
                        .onAppear {
                            viewModel.getThoughts()
                        }
                }
            }
            .listStyle(.plain)
            .refreshable {
                viewModel.refresh()
            }
            Spacer()
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(coordinator: HomeCoordinator()))
}
