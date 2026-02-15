//
//  VideosView.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 07/02/2026.
//

import SwiftUI

struct VideosView: View {
    @StateObject var viewModel: VideosViewModel
    
    var body: some View {
        ZStack {
            VStack {
                headerView()
                HStack {
                    Spacer()
                    Button {
                        viewModel.addNewVideo()
                    } label: {
                        Image(systemName: Images.plus)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.horizontal)
                    }
                }
                ScrollView {
                    infoView()
                }
            }
        }
    }
    
    func headerView() -> some View {
        ZStack {
            HStack {
                Spacer()
                Text("Catch Up With \nThe Lastet Videos")
                    .font(AppTypography.title(size: 28))
                    .foregroundStyle(Color.secondary.opacity(0.5))
            }
            RadialGradient(colors: [.purple, .darkPurple, .clear],
                           center: .center,
                           startRadius: 1, endRadius: 120)
            .offset(y: 30)
            VStack(alignment: .leading) {
                Text("Recent Work")
                    .font(AppTypography.body(size: 14))
                Text("Catch Up With \nThe Lastet Videos")
                    .font(AppTypography.title(size: 28))
                    .foregroundStyle(Color.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .frame(height: 240)
        .padding(.horizontal)
        .padding(.bottom, 32)
        .task {
            if viewModel.videos().count == 0 {
                viewModel.getVideos()
            }
        }
    }
    
    func infoView() -> some View {
        VStack {
            switch viewModel.viewState {
            case .loading:
                LoadingView()
            case .info:
                allVideosView()
            case .error:
                AlertView()
            case .empty:
                AlertView(config: AlertConfig(alertType: .empty))
            }
        }
        .padding(.bottom)
    }
    
    func allVideosView() -> some View {
        ForEach(viewModel.videos(), id: \.id) { video in
            VideoView(video: video)
                .onLongPressGesture {
                    viewModel.delete(video)
                }
        }
    }
}

#Preview {
    VideosView(viewModel: VideosViewModel(coordinator: nil))
}
