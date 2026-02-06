//
//  MoviesView.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 03/02/2026.
//

import SwiftUI

struct MoviesView: View {
    @StateObject var viewModel: MoviesViewModel
    init(viewModel: MoviesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            backgroundView()
            VStack {
                headerView()
                categoriesView()
                Button {
                    viewModel.addNewMovie()
                } label: {
                    HStack {
                        Spacer()
                        Image(systemName: Images.plus)
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
                infoView()
            }
            .foregroundColor(Color.black)

            .padding()
        }
        .task {
            if viewModel.categories.count == 0 {
                viewModel.getInitialData()
            }
        }
    }
    
    func backgroundView() -> some View {
        ZStack {
            Color.black
            VStack {
                GeometryReader { geometry in
                    Capsule()
                        .fill(Color.accentColor)
                        .offset(y: -geometry.size.height / 2)
                }
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
    
    func headerView() -> some View {
        HStack {
            Text("Movies")
                .font(AppTypography.title(size: 32))
            Spacer()
            Image(systemName: Images.movie)
                .resizable()
                .frame(width: 34, height: 34)
        }
    }
    
    func categoriesView() -> some View {
        HStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.categories, id: \.id) { category in
                        Text(category.name)
                            .font(AppTypography.body(size: 16))
                            .padding()
                            .background {
                                if viewModel.isSelectedCategory(category) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.purple)
                                } else {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.clear)
                                        .stroke(Color.black, lineWidth: 1)
                                }
                            }
                            .onTapGesture {
                                viewModel.selectedCategory = category
                                viewModel.reinitialise()
                            }
                    }
                }
            }
            Spacer()
            Button {
                viewModel.seeAllCategories()
            } label: {
                Text("See All")
                    .font(AppTypography.note(size: 16))
            }
        }
    }
    
    func infoView() -> some View {
        ScrollView {
            switch viewModel.viewState {
            case .loading:
                LoadingView()
            case .error:
                AlertView()
                    .foregroundStyle(Color.white)
            case .empty:
                AlertView(config: AlertConfig.init(alertType: .empty))
                    .foregroundStyle(Color.white)
            case .info:
                LazyVGrid(columns: [GridItem.init(.flexible()), GridItem.init(.flexible())]) {
                    ForEach(viewModel.movies(), id: \.id) { movie in
                        MovieBookView(item: .init(from: movie))
                            .onTapGesture {
                                viewModel.showMore(of: movie)
                            }
                            .onLongPressGesture {
                                viewModel.showDeleteAlert(for: movie)
                            }
                    }
                    if viewModel.hasMoreMovies() {
                        LoadingView()
                            .onAppear {
                                viewModel.getMovies()
                            }
                    }
                }
                Spacer(minLength: 160)
            }
        }
    }
}

#Preview {
    MoviesView(viewModel: MoviesViewModel(coordinator: nil))
}
