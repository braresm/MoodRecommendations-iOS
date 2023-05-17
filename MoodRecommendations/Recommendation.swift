//
//  Recommendation.swift
//  MoodRecommendations
//
//  Created by Balutoiu Rares Mihai on 31/03/2023.
//

import SwiftUI
import AudioToolbox

// The notification we'll send when a shake gesture happens.
extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

//  Override the default behavior of shake gestures to send our notification instead.
extension UIWindow {
     open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
     }
}

// A view modifier that detects shaking and calls a function of our choosing.
struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

// A View extension to make the modifier easier to use.
extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}

struct Recommendation: View {
    
    var selectedMood: Moods
    @State var movies: ReturnedData?
    @State var shakeCounter = 0
    @State var currentMovie: Result?
    @State var description: String?
    @State var rating: String?
    @State var moodIcon = "Fun"
    @State var genreText = "Action"
    
    var body: some View {
        NavigationView{
            
            Image("moodflix_bg")
               .resizable()
               .aspectRatio(contentMode: .fill)
               .edgesIgnoringSafeArea(.all)
               .overlay(
                ZStack {
                    
                    VStack {
                        VStack {
                            Text(currentMovie?.titleText.text ?? "")
                                .foregroundColor(.purple)
                                .padding(.bottom, 10)
                                .padding(.top, 110)
                            VStack {
//                                Image("GOT")
                                AsyncImage(url: URL(string: currentMovie?.primaryImage?.url ?? "")) { image in
                                      image
                                          .resizable()
                                          .scaledToFill()
                                          .aspectRatio(contentMode: .fit)
                                  } placeholder: {
                                      ProgressView()
                                  }
                                    .frame(width: 300, height: 160)
                                    .cornerRadius(16)
                            }
                            .frame(width: 400, height: 180)
                            .cornerRadius(16)
                            .shadow(radius: 4)
                            .aspectRatio(contentMode: .fit)
                            VStack {
                                HStack{
                                    VStack {
                                        HStack {
                                            Image("play.circle.fill")
                                            Text("Watch now:")
                                                .foregroundColor(.purple)
                                        }
                                        HStack {
                                            Text("HBO")
                                                .foregroundColor(.white)
                                            Text("N")
                                                .foregroundColor(.white)
                                            Text("HULU")
                                                .foregroundColor(.white)
                                        }
                                        Text("Released")
                                            .foregroundColor(.purple)
                                        Text(String(currentMovie?.releaseYear.year ?? 0))
                                            .foregroundColor(.white)
                                        Text("Mood")
                                            .foregroundColor(.purple)
                                        
                                        // TO DO: add img according to the mood
                                        Image(moodIcon)
                                            .resizable()
                                            .scaledToFill()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 100, height: 50)
                                        Text("Genre")
                                            .foregroundColor(.purple)
                                        Text(genreText)
                                            .foregroundColor(.white)
                                        Text("IMDB rating")
                                            .foregroundColor(.purple)
                                        Text(rating ?? "0.0")
                                            .foregroundColor(.white)
                                    }
                                    VStack {
                                        Text("Bookmark")
                                            .foregroundColor(.purple)
                                        Button(action: {
                                            let str = currentMovie?.titleText.text ?? ""
                                            let search = str.replacingOccurrences(of: " ", with: "%20")
                                            
                                            if let url = URL(string: "https://www.youtube.com/results?search_query=\(search)") {
                                                UIApplication.shared.open(url)
                                            }
                                        })
                                        {
                                            Text("Trailer")
                                                .foregroundColor(.purple)
                                        }
                                        
                                        Text("Description")
                                            .foregroundColor(.purple)
                                        ScrollView{
                                            Text(description ?? "Lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum")
                                                .foregroundColor(.white)
                                        }
                                        .padding(.bottom, 45)
                                    }
                                }
                            }
                            .padding()
                        }
                        
                    }
                }

            )
        }
        .onAppear {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            print("Vibration")
            let genre = getGenre(mood: selectedMood)
            movies = getMovies(genre: genre)
            
            currentMovie = movies?.results.first
            
            setMovieView()
            
            switch selectedMood {
            case .fun:
                moodIcon = "Fun"
                genreText = "Comedy"
            case .scared:
                moodIcon = "Scared"
                genreText = "Horror"
            case .tensed:
                moodIcon = "Tensed"
                genreText = "Thriller"
            case .passionate:
                moodIcon = "Passionate"
                genreText = "Romance"
            case .intrigued:
                moodIcon = "Intruiged"
                genreText = "Mystery"
            case .excited:
                moodIcon = "Excited"
                genreText = "Action"
            case .angry:
                moodIcon = "Angry"
                genreText = "Reality-TV"
            case .nostalgic:
                moodIcon = "Nostalgic"
                genreText = "Animation"
            case .sad:
                moodIcon = "Sad"
                genreText = "Documentary"
                
            }
            
        }
        .onShake {
            shakeCounter += 1
            if (shakeCounter >= 0 && movies?.results.count ?? -1 > shakeCounter) {
                currentMovie = movies?.results[shakeCounter]
                description = getMovieDescription(id: currentMovie?.id)
            } else {
                shakeCounter = 0
                currentMovie = movies?.results[shakeCounter]
                description = getMovieDescription(id: currentMovie?.id)
            }
            
            print("Device shaken!")
        }
    }
    
    func setMovieView() {
        description = getMovieDescription(id: currentMovie?.id)
        let ratingRaw = getMovieRating(id: currentMovie?.id)
        rating = "\(ratingRaw ?? 0)"

    }
}

