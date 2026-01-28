//
//  FactView.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 25/01/2026.
//

import SwiftUI

struct FactView: View {
    let fact: FunFact
    var edge: Edge = .trailing
    
    var body: some View {
        infoView()
    }
    
    func infoView() -> some View {
        VStack(alignment: edge == .leading ? .trailing : .leading,
               spacing: 16) {
            Image(systemName: Images.quote)
            Text(fact.title)
                .font(AppTypography.body(size: 18))
            Text(fact.more)
                .font(AppTypography.note(size: 18))
            HStack {
                if edge == .leading {
                    Spacer()
                }
                Text(fact.category.name)
                    .font(AppTypography.title(size: 18))
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(edge == .leading ? Color.darkOrange : Color.purple)
                    )
                if edge == .trailing {
                    Spacer()
                }
            }
            if let link = fact.link {
                Button {
                    print(link)
                } label: {
                    HStack {
                        Text("Learn More")
                            .font(AppTypography.note(size: 16))
                        Image(systemName: Images.link)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity,
               alignment: edge == .leading ? .trailing : .leading)
        .multilineTextAlignment(edge == .leading ? .trailing : .leading)
        .padding()
        .background(
            UnevenRoundedRectangle(topLeadingRadius: edge == .leading ? 0 : 20,
                                   bottomLeadingRadius: edge == .leading ? 0 : 20, bottomTrailingRadius: edge == .leading ? 20 : 0, topTrailingRadius: edge == .leading ? 20 : 0,
                                   style: .continuous)
            .fill(edge == .leading ? Color.darkPurple : Color.darkerOrange)
        )
        .padding(edge == .leading ? .trailing : .leading, 44)
        .foregroundStyle(.white)
    }
    
    func trailingView() -> some View {
        Text("")
    }
}

#Preview {
    FactView(fact: FunFact(id: 1,
                           title: "A teaspoon of neutron star material weighs over 6 ds d billion tons",
                           more: "or that sharks existed before trees. Other examples include that dolphins have names for each other, and that the Eiffel Tower can be 15 cm taller during the summer due to thermal expansion. ",
                           category: FunFactCategory(id: 1,
                                                     name: "Animals"),
                           link: "https://did-you-knows.com"))
}
