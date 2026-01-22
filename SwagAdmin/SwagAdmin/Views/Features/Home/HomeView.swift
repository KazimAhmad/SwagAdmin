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
        thoughtList()
    }
    
    func thoughtList() -> some View {
        VStack {
            Section {
                List {
                    ForEach(viewModel.thoughts, id: \.id) { thought in
                        ThoughtView(thought: thought) {
                            //TODO: -See More View
                        }
                        .listRowInsets(.init())
                        .listRowBackground(Color.clear)
                        .swipeActions {
                            Button {
                                
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
            } header: {
                HStack {
                    Text("Thoughts")
                        .font(AppTypography.body(size: 32))
                    Spacer()
                    Button {
                        viewModel.goToNewThought()
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color.white)
                            .padding()
                            .background(
                                Circle()
                                    
                            )
                    }
                }
                .padding()
            }
            Spacer()
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(coordinator: HomeCoordinator()))
}
