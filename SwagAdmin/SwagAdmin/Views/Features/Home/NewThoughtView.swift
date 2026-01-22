//
//  NewThoughtView.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 21/01/2026.
//

import SwiftUI

struct NewThoughtView: View {
    @StateObject private var viewModel: NewThoughtViewModel
    
    init(viewModel: NewThoughtViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.primary)
                .frame(width: 80, height: 4)
                .padding()
            Text("New Thought")
                .font(AppTypography.title(size: 18))
            ScrollView {
                Text("Thought")
                    .font(AppTypography.body(size: 18))
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("Title or a heading...",
                          text: $viewModel.thought,
                          axis: .vertical)
                    .font(AppTypography.body(size: 16))
                Text("More")
                    .font(AppTypography.body(size: 18))
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("More...",
                          text: $viewModel.more,
                          axis: .vertical)
                    .font(AppTypography.body(size: 16))
            }
            Spacer()
            buttonsView()
        }
        .padding(.horizontal)
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
    }
}

#Preview {
    NewThoughtView(viewModel: NewThoughtViewModel(coordinator: HomeCoordinator(),
                                                  didPublish: {_ in}))
}
