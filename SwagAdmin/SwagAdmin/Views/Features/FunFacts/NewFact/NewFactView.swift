//
//  NewThoughtView.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 21/01/2026.
//

import SwiftUI

struct NewFactView: View {
    @StateObject private var viewModel: NewFactViewModel
    
    init(viewModel: NewFactViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.primary)
                .frame(width: 80, height: 4)
                .padding()
            Text("New Fact")
                .font(AppTypography.title(size: 18))
            ScrollView {
                Text("Title")
                    .font(AppTypography.body(size: 18))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                TextField("Title or a heading...",
                          text: $viewModel.title,
                          axis: .vertical)
                    .font(AppTypography.body(size: 16))
                    .padding(.horizontal)
                Text("Description")
                    .font(AppTypography.body(size: 18))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                TextField("Description...",
                          text: $viewModel.description,
                          axis: .vertical)
                    .font(AppTypography.body(size: 16))
                    .padding(.horizontal)
                Menu {
                    ForEach(viewModel.categories, id: \.id) { category in
                        Button(action: {
                            viewModel.category = category
                        }) {
                            Text(category.name)
                        }
                    }
                } label: {
                    HStack {
                        Text("Category:")
                            .font(AppTypography.body(size: 18))
                            .foregroundStyle(Color.white)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                            )
                        Text(viewModel.category?.name ?? "-- --")
                            .font(AppTypography.body(size: 18))
                        Spacer()
                        Image(systemName: Images.plus)
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
                .padding()
                
                Text("Link (Optional)")
                    .font(AppTypography.body(size: 18))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                TextField("Link...",
                          text: $viewModel.link.toUnwrapped(defaultValue: ""),
                          axis: .vertical)
                    .font(AppTypography.body(size: 16))
                    .padding(.horizontal)
            }
            Spacer()
            buttonsView()
        }
        .autocorrectionDisabled()
        .textInputAutocapitalization(.sentences)
        .textFieldStyle(RoundedShadowTextFieldStyle())
    }
    
    func buttonsView() -> some View {
        HStack(spacing: 16) {
            if viewModel.viewState == .loading {
                LoadingView()
            } else {
                Button {
                    viewModel.saveDraft()
                } label: {
                    Text("Save Draft")
                        .foregroundStyle(Color.accentColor)
                }
                .buttonStyle(RoundedBorderButtonStyle(backgroundColor: .clear,
                                                      borderColor: .accentColor))

                Button {
                    viewModel.publishThought()
                } label: {
                    Text("Publish")
                }
                .buttonStyle(RoundedBorderButtonStyle())
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    NewFactView(viewModel: NewFactViewModel(categories: [Category(id: 0,
                                                                  name: "Animals"),
                                                         Category(id: 1,
                                                                  name: "Birds")],
                                            dependency: nil,
                                            onDismiss: { },
                                            didPublish: { _ in }))
}
