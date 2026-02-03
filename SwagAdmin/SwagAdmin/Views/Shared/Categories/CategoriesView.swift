//
//  CategoriesView.swift
//  Swag
//
//  Created by Kazim Ahmad on 02/02/2026.
//

import SwiftUI

struct CategoriesView: View {
    @StateObject var viewModel: CategoriesViewModel
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    deleteCategory()
                    addNewCategory()
                    categoriesView(height: geometry.size.height / 2)
                }
            }
        }
        .ignoresSafeArea()
    }
    
    func deleteCategory() -> some View {
        HStack {
            Menu {
                ForEach(viewModel.categories, id: \.id) { category in
                    Button(action: {
                        viewModel.categoryToDelete = category
                    }) {
                        Text(category.name)
                    }
                }
            } label: {
                HStack {
                    Text("Delete category:")
                        .font(AppTypography.body(size: 18))
                        .foregroundStyle(Color.white)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                        )
                    Text(viewModel.categoryToDelete?.name ?? "-- --")
                        .font(AppTypography.body(size: 18))
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                        )
                    Spacer()
                }
            }
            Button {
                viewModel.deleteCategory()
            } label: {
                Image(systemName: Images.delete)
                    .resizable()
                    .frame(width: 35, height: 35)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.primary)
        )
    }
    
    func addNewCategory() -> some View {
        HStack {
            TextField("New Category...", text: $viewModel.newCategoryName)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
            Button {
                viewModel.addCategory()
            } label: {
                Image(systemName: Images.plus)
                    .resizable()
                    .frame(width: 35, height: 35)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.primary)
        )
    }
    
    func categoriesView(height: CGFloat) -> some View {
        VStack() {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.primary)
                .frame(width: 80, height: 4)
            Text(viewModel.categoryType.rawValue + " Categories")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(AppTypography.title(size: 18))
                .padding(.top)
            categoriesGrid()
            HStack {
                Button {
                    viewModel.didClearCategory?()
                } label: {
                    Text("Clear")
                        .foregroundStyle(Color.accentColor)
                }
                .buttonStyle(RoundedBorderButtonStyle(backgroundColor: .clear))
                Button {
                    viewModel.didSelectCategory?(viewModel.selectedCategory)
                } label: {
                    Text("Results")
                }
                .buttonStyle(RoundedBorderButtonStyle())
                Button {
                    viewModel.dismiss?()
                } label: {
                    Image(systemName: Images.error)
                        .resizable()
                        .frame(width: 45, height: 45)
                }
            }
        }
        .padding()
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(uiColor: .systemBackground))
                .shadow(color: .primary,
                        radius: 24)
        )
        .padding()
        .padding(.bottom)
    }
    
    func categoriesGrid() -> some View {
        ScrollView {
            FlowLayout {
                ForEach(viewModel.categories, id: \.id) { cat in
                    Text(cat.name)
                        .font(AppTypography.note(size: 18))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(viewModel.isSelected(cat) ? Color.accentColor : Color.darkPurple.opacity(0.6))
                        )
                        .padding(2)
                        .onTapGesture {
                            viewModel.selectCategory(cat)
                        }
                }
            }
        }
    }
}

#Preview {
    CategoriesView(viewModel: CategoriesViewModel(config: CategoriesConfig.init(categories: [],
                                                                                categoryType: .facts,
                                                                                didSelectCategory: { _ in },
                                                                                didClearCategory: { },
                                                                                didDeleteCategory: { _ in },
                                                                                dismiss: { })))
}
