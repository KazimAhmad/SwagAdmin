//
//  CardView.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 11/02/2026.
//

import PhotosUI
import SwiftUI

enum ColorPickerHex: String {
    case white = "#FFFFFF"
    case accent = "#EC602A"
    case secondary = "#4A2412"
}

struct CardView: View {
    @State var card: Card
    @State private var bgColor: Color = .primary
    
    let cardHeight: CGFloat = 450
    private var firstColorBinding: Binding<Color> {
        Binding<Color> {
            if let first = card.colors.first, let parsed = Color(hex: first) {
                return parsed
            }
            return bgColor
        } set: { newValue in
            card.colors[0] = newValue.hexString ?? ColorPickerHex.accent.rawValue
        }
    }
    
    private var secondColorBinding: Binding<Color> {
        Binding<Color> {
            if let last = card.colors.last, let parsed = Color(hex: last) {
                return parsed
            }
            return bgColor
        } set: { newValue in
            card.colors[1] = newValue.hexString ?? ColorPickerHex.secondary.rawValue
        }
    }
    
    private var textColorBinding: Binding<Color> {
        Binding<Color> {
            if let text = card.textColor, let parsed = Color(hex: text) {
                return parsed
        }
            return bgColor
        } set: { newValue in
            card.textColor = newValue.hexString ?? ColorPickerHex.white.rawValue
        }
    }
    
    @State private var title = ""
    @State private var description = ""
    @State private var link = ""

    @State private var photosPickerPresented = false
    @State private var photoPickerItem: PhotosPickerItem? = nil

    var isEditing: Bool = false
    var didSave: ((Card) -> Void)? = nil
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    ringsView(on: imageView())
                    Spacer()
                }
                Text(card.description)
                    .font(AppTypography.note(size: 24))
                    .padding(.top, 64)
                    .padding(.trailing, 64)
                    .padding(.leading)
                Spacer()
                HStack {
                    Button {
                        if let url = URL(string: card.link) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Image(systemName: Images.link)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(16)
                            .background(
                                Circle()
                                    .stroke(Color.init(hex: card.textColor ?? ColorPickerHex.white.rawValue) ?? .primary,
                                            lineWidth: 2)
                            )
                    }
                    .padding(24)
                    Spacer()
                }
            }
            .frame(height: cardHeight)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .background(
                backgroundView()
                    .padding(.horizontal)
            )
            sideTitleView()
                .padding(.trailing, 48)
            if isEditing {
                HStack {
                    fieldsView()
                    Spacer()
                    colorPickers()
                }
            }
        }
        .foregroundStyle(Color.init(hex: card.textColor ?? ColorPickerHex.white.rawValue) ?? .primary)
    }
    
    private func backgroundView() -> some View {
        CardBackgroundCustomShape()
            .fill(
                Gradient(colors: [Color.init(hex: card.colors.first ?? ColorPickerHex.accent.rawValue) ?? .accentColor,
                                  Color.init(hex: card.colors.last ?? ColorPickerHex.secondary.rawValue) ?? .darkOrange])
            )
    }
    
    private func imageView() -> some View {
        VStack {
            if let url = URL(string: card.image) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(Color.accentColor)
                        .frame(width: 100, height: 100)
                }
            } else if let pickedImage = card.photoItem {
                    Image(uiImage: pickedImage)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
            }
        }
    }
    
    private func ringsView(on view: some View) -> some View {
        ZStack {
            let strokeColor = Color.init(hex: card.colors.first ?? ColorPickerHex.accent.rawValue) ?? .accentColor
            let size = 108.0
            let lineLength: CGFloat = 4.5
            ForEach((0...4), id: \.self) { index in
                let itemSize = size + (Double(index) * 13.0)
                let itemLineLength: CGFloat = lineLength - Double(index)
                Circle()
                    .stroke(strokeColor, lineWidth: itemLineLength)
                    .frame(width: itemSize, height: itemSize)
            }
            view
                .padding(8)
        }
    }
    
    private func sideTitleView() -> some View {
        HStack {
            Spacer()
            VerticalText(text: card.title)
                .frame(width: 16)
        }
        .frame(height: cardHeight)
    }
    
    private func colorPickers() -> some View {
        VStack {
            ColorPicker("", selection: firstColorBinding)
            Spacer()
            ColorPicker("", selection: textColorBinding)
            Spacer()
            ColorPicker("", selection: secondColorBinding)
        }
        .padding(.vertical)
    }
    
    private func fieldsView() -> some View {
        VStack(alignment: .leading) {
            TextField("Title",
                      text: $title)
            .textFieldStyle(.roundedBorder)
            .foregroundStyle(Color.primary)
            .autocorrectionDisabled()
            .onAppear {
                title = card.title
            }
            .onChange(of: title) { oldValue, newValue in
                card.title = newValue
            }
            
            TextField("Description",
                      text: $description)
            .textFieldStyle(.roundedBorder)
            .foregroundStyle(Color.primary)
            .autocorrectionDisabled()
            .onAppear {
                description = card.description
            }
            .onChange(of: description) { oldValue, newValue in
                card.description = newValue
            }

            TextField("Link",
                      text: $link)
            .textFieldStyle(.roundedBorder)
            .foregroundStyle(Color.primary)
            .autocorrectionDisabled()
            .onAppear {
                link = card.link
            }
            .onChange(of: link) { oldValue, newValue in
                card.link = newValue
            }
            Button {
                photosPickerPresented.toggle()
            } label: {
                Image(systemName: "camera")
                    .resizable()
                    .frame(width: 33, height: 30)
                    .padding(.horizontal)
                    .foregroundStyle(Color.accent)
            }

            Spacer()
            Button {
                addCard()
            } label: {
                Text("Save")
            }
            .buttonStyle(RoundedBorderButtonStyle())
            .padding()
        }
        .padding(.vertical)
        .photosPicker(isPresented: $photosPickerPresented, selection: $photoPickerItem)
        .onChange(of: photoPickerItem) { oldValue, newValue in
            guard let newValue else { return }
            Task {
                do {
                    if let imageData = try await newValue.loadTransferable(type: Data.self),
                       let inputImage = UIImage(data: imageData) {
                        card.photoItem = inputImage
                    }
                } catch {
                    print("Failed to load image data: \(error)")
                }
            }
        }
    }
    
    @MainActor
    private func addCard() {
        let repository: CardRepository = CardRepository()
        Task {
            do {
                let id = try await repository.create(object: card)
                card.id = id
                didSave?(card)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    CardView(card: Card(id: 0,
                        title: "Ask Ganjiswag",
                        description: "A channel for advices, recommendations for people's problems and more.",
                        image: "",
                        link: "",
                        colors: ["#EC602A", "#4A2412"],
                        textColor: nil),
    isEditing: true)
}

