//
//  BooksView.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 03/02/2026.
//

import SwiftUI

struct BooksView: View {
    @StateObject var viewModel: BooksViewModel
    init(viewModel: BooksViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            backgroundView()
            VStack {
                headerView()
                categoriesView()
                Button {
                    viewModel.addNewBook()
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
            .foregroundColor(Color.white)

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
            Color.white
            VStack {
                GeometryReader { geometry in
                    Capsule()
                        .fill(Color.purple)
                        .offset(y: -geometry.size.height / 2)
                }
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
    
    func headerView() -> some View {
        HStack {
            Text("Books")
                .font(AppTypography.title(size: 32))
            Spacer()
            Image(systemName: Images.book)
                .resizable()
                .frame(width: 32, height: 38)
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
                                        .fill(Color.darkerOrange)
                                } else {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.clear)
                                        .stroke(Color.white, lineWidth: 1)
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
                    ForEach(viewModel.books(), id: \.id) { book in
                        MovieBookView(item: .init(from: book))
                            .onTapGesture {
                                viewModel.showMore(of: book)
                            }
                            .onLongPressGesture {
                                viewModel.delete(book: book)
                            }
                    }
                    if viewModel.hasMoreBooks() {
                        LoadingView()
                            .onAppear {
                                viewModel.getBooks()
                            }
                    }
                }
                Spacer(minLength: 160)
            }
        }
    }
}

#Preview {
    BooksView(viewModel: BooksViewModel(coordinator: nil))
}
