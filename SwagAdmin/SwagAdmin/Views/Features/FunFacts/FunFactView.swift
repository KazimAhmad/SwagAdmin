//
//  FunFactView.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 25/01/2026.
//

import SwiftUI

struct FunFactView: View {
    @StateObject var viewModel: FunFactViewModel
    
    init(viewModel: FunFactViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                headerView()
                switch viewModel.viewState {
                case .loading:
                    LoadingView()
                case .info:
                    categoriesView()
                    factsListView()
                case .error(let error):
                    AlertView(config: AlertConfig(message: error.localizedDescription))
                case .empty:
                    AlertView(config: AlertConfig(alertType: .empty))
                }
            }
        }
    }
    
    func headerView() -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.clear)
                .stroke(Color.accentColor, lineWidth: 2)
                .frame(height: 200)
                .padding(.horizontal, 44)
                .padding(.top, 44)
            
            Text("Did you\nknow ?".uppercased())
                .font(AppTypography.title(size: 32))
                .padding()
                .background(
                    Rectangle()
                        .fill(Color(uiColor: .systemBackground))
                )
            HStack {
                Spacer()
                Rectangle()
                    .fill(Color(uiColor: .systemBackground))
                    .frame(width: 80, height: 80)
            }
            .padding(.bottom, 100)

            RoundedRectangle(cornerRadius: 24)
                .fill(Color.darkerOrange.opacity(0.6))
                .frame(height: 200)
                .padding(.leading, 100)
                .padding(.bottom, 44)
                .overlay {
                    VStack {
                        HStack {
                            Spacer()
                            Text("?")
                                .font(AppTypography.body(size: 100))
                                .rotationEffect(Angle(degrees: 30))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 44)
                }
        }
    }
    
    func categoriesView() -> some View {
        Section {
            ScrollView(.horizontal) {
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
        } header: {
            HStack {
                Text("Categories")
                    .font(AppTypography.title(size: 16))
                Spacer()
                Button {
                    //MARK: -TODO
                } label: {
                    Text("See All")
                        .font(AppTypography.note(size: 16))
                }
            }
        }
        .padding([.horizontal])
    }
    
    func factsListView() -> some View {
        VStack {
            ForEach(viewModel.funFact.indices, id: \.self) { factIndex in
                let fact = viewModel.funFact[factIndex]
                FactView(fact: fact, edge: factIndex % 2 == 0 ? .leading : .trailing)
            }
        }
    }
}

#Preview {
    FunFactView(viewModel: FunFactViewModel())
}
