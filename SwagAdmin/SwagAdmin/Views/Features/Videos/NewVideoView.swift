//
//  NewVideoView.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 15/02/2026.
//

import SwiftUI

struct NewVideoView: View {
    @State var video: Video = Video(id: 0,
                                    title: "",
                                    description: "",
                                    link: "",
                                    date: Date())
    
    var didSave: ((Video) -> Void)?
    
    var body: some View {
        VStack {
            Spacer()
            TextField("Title", text: Binding(
                get: { video.title},
                set: { video.title = $0 }
            ))
                .textFieldStyle(.roundedBorder)
            TextField("Description", text: Binding(
                get: { video.description ?? "" },
                set: { video.description = $0 }
            ))
                .textFieldStyle(.roundedBorder)
            TextField("Link", text: Binding(
                get: { video.link },
                set: { video.link = $0 }
            ))
                .textFieldStyle(.roundedBorder)
            DatePicker("Date Published", selection: $video.date, displayedComponents: .date)
                .datePickerStyle(.compact)
            Spacer()
            Button {
                save()
            } label: {
                Text("Save")
            }
            .buttonStyle(RoundedBorderButtonStyle())
        }
        .autocorrectionDisabled()
        .padding()
    }
    
    @MainActor
    private func save() {
        let repo = VideoRepository()
        Task {
            do {
                let newId = try await repo.create(object: video)
                video.id = newId
                didSave?(video)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    NewVideoView()
}
