//
//  SeeMoreView.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 22/01/2026.
//

import SwiftUI

enum SeeMoreImageSize: CGFloat, CaseIterable {
    case small = 24
    case medium = 32
    case large = 48
    case extraLarge = 64
}

enum SeeMoreType {
    case thought
    case fact
    
    var image: Image {
        switch self {
        case .thought:
            return Image(systemName: Images.lightBulb)
        case .fact:
            return Image(systemName: Images.questionMark)
        }
    }
    
    var heading: String {
        switch self {
        case .thought:
            return "Thoughts"
        case .fact:
            return "Facts"
        }
    }
    
    var subHeading: String {
        switch self {
        case .thought:
            return "More on this:"
        case .fact:
            return "Did you know?"
        }
    }
}

struct SeeMoreConfig {
    var type: SeeMoreType
    var title: String
    var description: String
    var dismiss: (() -> Void)?
    
    init(type: SeeMoreType, title: String, description: String, dismiss: (() -> Void)? = nil) {
        self.type = type
        self.title = title
        self.description = description
        self.dismiss = dismiss
    }
}

struct SeeMoreView: View {
    let timer = Timer.publish(every: 1,
                              on: .main,
                              in: .common).autoconnect()
    @State private var updateOffset: Bool = false
    var config: SeeMoreConfig
    
    init(config: SeeMoreConfig) {
        self.config = config
    }
        
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Color.black.opacity(0.8)
                infoBox(height: geometry.size.height / 1.6)
            }
            .onReceive(timer) { time in
                withAnimation {
                    updateOffset.toggle()
                }
            }
        }
        .ignoresSafeArea(.all)
    }
    
    func infoBox(height: CGFloat) -> some View {
        VStack(alignment: .leading) {
            topLayerView()
        }
        .frame(height: height)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(uiColor: .systemBackground))
                .shadow(color: Color.primary,
                        radius: 16)
        )
    }
    
    func imageView(size: SeeMoreImageSize) -> some View {
        config.type.image
            .resizable()
            .frame(width: size.rawValue,
                   height: size.rawValue)
            .foregroundStyle(colorOfImage())
            .offset(x: CGFloat(updateOffset ? Int.random(in: 1..<5) : 0))
            .offset(y: CGFloat(updateOffset ? Int.random(in: 1..<5) : 0))
    }
    
    func imageGroup(elements: Int) -> some View {
        VStack {
            Group {
                ForEach(0..<elements, id: \.self) { _ in
                    let index = Int.random(in: 0..<3)
                    imageView(size: SeeMoreImageSize.allCases[index])
                }
            }
        }
    }
    
    func colorOfImage() -> Color {
        let index = Int.random(in: 0..<3)
        return index == 0 ? .accentColor : index == 1 ? .darkOrange : .darkerOrange
    }
    
    func sideImageView() -> some View {
        VStack {
            imageGroup(elements: 1)
            HStack {
                ForEach(0..<4, id: \.self) { _ in
                    let index = Int.random(in: 0..<3)
                    imageGroup(elements: index)
                }
            }
            imageGroup(elements: 1)
            Spacer()
        }
    }
    
    func topLayerView() -> some View {
        ZStack(alignment: .trailing) {
            sideImageView()
            infoView()
                .padding(.top, 64)
        }
    }
    
    func infoView() -> some View {
        VStack(alignment: .leading) {
            Text(config.type.heading)
                .font(AppTypography.title(size: 24))
            ScrollView {
                Text(config.title)
                    .font(AppTypography.body(size: 22))
                    .frame(maxWidth: .infinity, alignment: .leading)
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 100, height: 1)
                    .padding(.bottom)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(config.type.subHeading)
                    .font(AppTypography.note(size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(config.description)
                    .font(AppTypography.body(size: 18))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            HStack {
                Spacer()
                Button {
                    config.dismiss?()
                } label: {
                    Image(systemName: Images.error)
                        .resizable()
                        .frame(width: 44, height: 44)
                        .padding()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    SeeMoreView(config: SeeMoreConfig(type: .thought,
                                      title: "",
                                      description: ""))
}
