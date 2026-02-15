//
//  VideoView.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 07/02/2026.
//
import SwiftUI

struct VideoView: View {
    let video: Video
    @StateObject var viewModel = VideoViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            if viewModel.image != nil {
                viewModel.image?
                    .resizable()
                    .frame(height: 240)
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20,
                                                      bottomLeadingRadius: 0,
                                                      bottomTrailingRadius: 0,
                                                      topTrailingRadius:  20,
                                                      style: .continuous))
            } else {
                HStack {
                    Spacer()
                    ProgressView()
                        .tint(Color.accentColor)
                    Spacer()
                }
                .frame(height: 240)
            }
            VStack(alignment: .leading) {
                Text(video.title)
                    .font(AppTypography.note(size: 20))
                if let description = video.description, !description.isEmpty {
                    Text(description)
                        .font(AppTypography.body(size: 16))
                        .foregroundColor(Color.secondary)
                        .lineLimit(1)
                }
                HStack {
                    Image(systemName: Images.calender)
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text(viewModel.dateString(from: video.date))
                        .font(AppTypography.note(size: 16))
                }
                .foregroundStyle(Color.purple)
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.clear)
                .stroke(Color.primary, lineWidth: 1)
        )
        .padding(.horizontal)
        .padding(.top)
        .onTapGesture {
            if let url = URL(string: video.link) {
                UIApplication.shared.open(url)
            }
        }
        .task {
            viewModel.loadImage(url: video.link)
        }
    }
}

#Preview {
    VideoView(video: Video(id: 1,
                           title: "Saudi Arabia Walking Tales - Riyadh Night Life #33 | Junaid Akram",
                           description: "asjdfkajsf kjsabdfkjasdfnkasjbk fbkjasbdf ksadfioasfk jasdhf kjasdhfiukajhsdfkhkjadshf iasjdkhf jasdhfuahfnciuaknjhfiaueywr8oqiuawshdhfashfcnjaskdhfc iashfc as jdfhiasdjkhf caskfjhdhfasjkhf",
                           link: "https://www.youtube.com/watch?v=j4VZJ2ZFzJs",
                           date: Date()))
}
