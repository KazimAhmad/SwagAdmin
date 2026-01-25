//
//  RecommendationView.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 24/01/2026.
//

import SwiftUI

struct RecommendationView: View {
    @StateObject var viewModel: RecommendationViewModel
    
    init(viewModel: RecommendationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text("Recommendation View")
            }
            floatingBarView()
        }
        .padding()
    }

    func floatingBarView() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                CustomFloatingBar(selectedOption: $viewModel.selectedTab,
                                  options: viewModel.floatingTabs)
            }
        }
    }
}

#Preview {
    RecommendationView(viewModel: RecommendationViewModel())
}
