//
//  NewThoughtView.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 21/01/2026.
//

import SwiftUI

struct NewMovieView: View {
    @StateObject private var viewModel: NewMovieViewModel
    
    init(viewModel: NewMovieViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.primary)
                .frame(width: 80, height: 4)
                .padding()
            Text("New Movie")
                .font(AppTypography.title(size: 18))
            ScrollView {
                Text("Name")
                    .font(AppTypography.body(size: 18))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                TextField("Movie name...",
                          text: $viewModel.title,
                          axis: .vertical)
                    .font(AppTypography.body(size: 16))
                    .padding(.horizontal)
                Text("My Review")
                    .font(AppTypography.body(size: 18))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                TextField("My review...",
                          text: $viewModel.myReview,
                          axis: .vertical)
                    .font(AppTypography.body(size: 16))
                    .padding(.horizontal)
                VStack {
                    HStack {
                        Text("My Rating:")
                            .font(AppTypography.body(size: 16))
                        Spacer()
                        Text(String(format: "%.1f", viewModel.rating ?? 0.0))
                            .font(AppTypography.body(size: 20))
                    }
                    Slider(
                        value: $viewModel.rating.toUnwrapped(defaultValue: 0.0),
                        in: 1...10,
                        step: 0.1
                    )
                }
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
                
                Text("IMDB Link")
                    .font(AppTypography.body(size: 18))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                TextField("Link...",
                          text: $viewModel.imdbLink.toUnwrapped(defaultValue: ""),
                          axis: .vertical)
                    .font(AppTypography.body(size: 16))
                    .padding(.horizontal)
                VStack {
                    let year = Calendar.current.component(.year, from: Date())
                    HStack {
                        Text("Release Year:")
                            .font(AppTypography.body(size: 16))
                        Spacer()
                        Text(viewModel.releaseYear ?? String(year))
                            .font(AppTypography.body(size: 20))
                    }
                    Picker("", selection: $viewModel.releaseYear) {
                        ForEach((1888...year).reversed(), id: \.self) { index in
                            Text(String(index)).tag(String(index))
                        }                }
                    .pickerStyle(.wheel)
                }
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
    NewMovieView(viewModel: NewMovieViewModel(categories: [Category(id: 0,
                                                                  name: "Animals"),
                                                         Category(id: 1,
                                                                  name: "Birds")],
                                              dependency: nil,
                                              onDismiss: { },
                                              didPublish: { _ in }))
}
