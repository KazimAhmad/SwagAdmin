//
//  ThoughtView.swift
//  Swag
//
//  Created by Kazim Ahmad on 19/01/2026.
//

import SwiftUI

struct ThoughtView: View {
    let thought: Thought
    var seeMore: () -> Void = {}
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Image(systemName: Images.quote)
                    .resizable()
                    .frame(width: 34, height: 32)
                    .foregroundColor(.purple)
                .padding(.bottom)
                Text(thoughtText())
                    .font(AppTypography.note(size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                if !thought.more.isEmpty {
                    Button {
                        seeMore()
                    } label: {
                        Text("See More...")
                            .font(AppTypography.body(size: 14))
                    }
                    .padding(.vertical)
                }
            }
            .padding(24)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(uiColor: .systemBackground))
                .shadow(color: Color.primary.opacity(0.4), radius: 8, y: 8)
        )
        .padding()
        .overlay {
            VStack(alignment: .leading) {
                HStack {
                    Text(dateString())
                        .foregroundStyle(Color.white)
                        .font(AppTypography.title(size: 14))
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.purple)
                        )
                        .padding(.leading, 64)
                    Spacer()
                }
                Spacer()
            }
        }
    }
    
    func thoughtText() -> String {
        if thought.thought.isEmpty {
            "No good thought has occured to me yet, so far only bad and unshareable thoughts, will keep you updated."
        } else {
            thought.thought
        }
    }
    
    func dateString() -> String {
        if Calendar.current.isDateInToday(thought.date) {
            return "Thought of the day"
        } else if Calendar.current.isDateInYesterday(thought.date) {
            return "Thought of Yesterday"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            return dateFormatter.string(from: thought.date)
        }
    }
}

#Preview {
    ThoughtView(thought: Thought(id: 1,
                                 thought: " specimen book.",
                                 more: "More",
                                 date: Date()))
}
