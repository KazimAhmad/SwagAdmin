//
//  VideosViewModel.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 07/02/2026.
//

import Foundation

@MainActor
class VideosViewModel: ObservableObject {
    @Published var videos: [Video] = []
    @Published var viewState: ViewState = .loading
    
    func getVideos() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1,
                                      execute: {
            self.videos = [Video(id: 1,
                                 title: "Saudi Arabia Walking Tales - Riyadh Night Life #33 | Junaid Akram",
                                 description: "asjdfkajsf kjsabdfkjasdfnkasjbk fbkjasbdf ksadfioasfk jasdhf kjasdhfiukajhsdfkhkjadshf iasjdkhf jasdhfuahfnciuaknjhfiaueywr8oqiuawshdhfashfcnjaskdhfc iashfc as jdfhiasdjkhf caskfjhdhfasjkhf",
                                 url: "https://www.youtube.com/watch?v=j4VZJ2ZFzJs",
                                 date: Date()),
                           Video(id: 2,
                                                  title: "Saudi Arabia Walking Tales - Riyadh Night Life #33 | Junaid Akram",
                                                  description: "asjdfkajsf kjsabdfkjasdfnkasjbk fbkjasbdf ksadfioasfk jasdhf kjasdhfiukajhsdfkhkjadshf iasjdkhf jasdhfuahfnciuaknjhfiaueywr8oqiuawshdhfashfcnjaskdhfc iashfc as jdfhiasdjkhf caskfjhdhfasjkhf",
                                                  url: "https://www.youtube.com/watch?v=j4VZJ2ZFzJs",
                                                  date: Date()),
                           Video(id: 3,
                                                  title: "Saudi Arabia Walking Tales - Riyadh Night Life #33 | Junaid Akram",
                                                  description: "asjdfkajsf kjsabdfkjasdfnkasjbk fbkjasbdf ksadfioasfk jasdhf kjasdhfiukajhsdfkhkjadshf iasjdkhf jasdhfuahfnciuaknjhfiaueywr8oqiuawshdhfashfcnjaskdhfc iashfc as jdfhiasdjkhf caskfjhdhfasjkhf",
                                                  url: "https://www.youtube.com/watch?v=j4VZJ2ZFzJs",
                                                  date: Date())]
            self.viewState = .info
        })
    }
}
