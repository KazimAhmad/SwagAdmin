//
//  MovieView.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 03/02/2026.
//

import SwiftUI

struct MovieView: View {
    var movie: Movie

    var body: some View {
        VStack(alignment: .leading) {
            Text(movie.title)
                .font(AppTypography.title(size: 18))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(uiColor: .systemBackground))
                .shadow(color: .primary.opacity(0.6),
                        radius: 8)
        )
        .padding()
    }
}

#Preview {
    MovieView(movie: Movie(id: 0,
                           title: "A Separation",
                           myReview: "The Iranian film A Separation, written and directed by Asghar Farhadi, seems to me the best film of 2011. It is one of the Academy Award nominees for Best Foreign Picture, but by any sense of justice in any nation (let alone the self-assessed greatest in the world) it would have been nominated for Best Picture before anything else. The ways in which the characters in A Separation struggle for truth and honor, while yielding sometimes to compromise and falsehood, is not foreign to us. Few other films made last year give such a striking sense of, “Look—isn’t this life? Isn’t this our life, too?” In a complete world of film-going, we should no longer tolerate the label “foreign film,” especially since it seems likely that a film from France in which the French language remains tactfully silent is going to stroll away with Best Picture. The Artist is a pleasant soufflé, over which older Academy voters can wax nostalgic. But A Separation is what the cinema was invented for. \nIn Tehran, a married couple argue into the camera in the opening scene, trying to defend and escape from their marriage. Simin (Leila Hatami) wants to leave Iran, taking their eleven-year-old daughter with her, so that they can live in greater liberty. Nader, her husband (Peyman Maadi), is against the separation though resigned to it, but determined that the daughter stay in Tehran with him. He cannot leave, he claims, because he has to look after his father who has deteriorating Alzheimer’s. The court sides with the father, and Simin moves out of their apartment, leaving Nader, his daughter, and the victim of dementia. With a demanding job, Nader cannot manage—Simin was always at home, looking after things—so he seeks to hire a house-sitter. He finds Razieh (Sarey Bayat), a devout wife and mother who knows the pay is not enough, but her husband is unemployed and they are desperate. So she comes to the apartment every day on a long commute, bringing her own young daughter, and she finds that she has to clean the old man when he forgets to go to the bathroom.",
                           rating: 8.3,
                           releaseYear: "2011",
                           imdbLink: "https://www.imdb.com/title/tt1832382/",
                           category: Category(id: 0,
                                              name: "Drama")))
}
