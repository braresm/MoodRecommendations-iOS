//
//  Slideshow.swift
//  MoodRecommendations
//
//  Created by Balutoiu Rares Mihai on 30/03/2023.
//

import SwiftUI

struct Slideshow: View {
    @State private var currentIndex = 0
    
    let images = ["D1", "D2", "goToMoodSelection"]
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(0..<images.count) { index in
                Image(images[index])
                    .resizable()
                    .scaledToFill()
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .onChange(of: currentIndex) { index in
            if index == images.count - 1 {
                // Switch to MoodSelection view
                let moodSelectionView = MoodSelection()
                UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: moodSelectionView)
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        }
    }
}



/*struct Slideshow_Previews: PreviewProvider {
    static var previews: some View {
        Slideshow()
    }
}
*/
