//
//  MoviesView.swift
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
                ScrollView {

                }
            }
            .foregroundColor(Color.white)

            .padding()
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
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.purple)
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
}

#Preview {
    BooksView(viewModel: BooksViewModel())
}
