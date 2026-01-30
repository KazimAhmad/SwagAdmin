//
//  SettingsView.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 29/01/2026.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            headerView()
            draftsView()
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func headerView() -> some View {
        HStack {
            Image(Images.logo)
                .resizable()
                .frame(width: 100, height: 100)
            VStack(alignment: .leading) {
                Text("Swag Admin")
                    .font(AppTypography.title(size: 24))
                Text("Khalli Walli")
                    .font(AppTypography.body(size: 14))
            }
        }
    }
    
    func draftsView() -> some View {
        List {
            Section {
                ForEach(viewModel.sections, id: \.self) { section in
                    HStack {
                        Text(section.rawValue)
                            .font(AppTypography.body(size: 16))
                        Spacer()
                        Image(systemName: Images.disclose)
                            .foregroundStyle(.gray)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.navigate(to: section)
                    }
                }
            } header: {
                Text("Drafts")
                    .font(AppTypography.title(size: 18))
            }
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel())
}
