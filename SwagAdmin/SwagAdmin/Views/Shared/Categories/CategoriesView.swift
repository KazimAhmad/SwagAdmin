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
                    categoriesView(height: geometry.size.height / 2)
                }
            }
        }
        .ignoresSafeArea()
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
            ScrollView {
                FlowLayout {
                    ForEach(viewModel.categories) { cat in
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
}

#Preview {
    CategoriesView(viewModel: CategoriesViewModel(config: CategoriesConfig.init(categories: [],
                                                                                categoryType: .facts,
                                                                                didSelectCategory: { _ in },
                                                                                didClearCategory: { },
                                                                                didDeleteCategory: { _ in },
                                                                                dismiss: { })))
}
