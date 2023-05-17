//
//  MoodSelection.swift
//  MoodRecommendations
//
//  Created by Balutoiu Rares Mihai on 30/03/2023.
//

import SwiftUI
import SDWebImageSwiftUI
import WebKit
import SDWebImage

enum Moods: String {
    case fun
    case scared
    case tensed
    case passionate
    case intrigued
    case excited
    case angry
    case nostalgic
    case sad
}

//Glow effect text
extension View {
    func glow(color: Color = Color(red: 147/255, green: 144/255, blue: 195/255), radius: CGFloat = 5) -> some View {
        self
        .shadow(color: color, radius: radius / 3)
        .shadow(color: color, radius: radius / 3)
        .shadow(color: color, radius: radius / 3)
        .opacity(1.0)
    }
}

//Colors used buttons
extension Color{
    static let offWhite = Color(.purple)
    static let darkBlueGrayStart = Color(red: 22/255, green: 24/255, blue: 25/255)
    static let darkBlueGrayEnd = Color(red: 6/255, green: 7/255, blue: 7/255)
    static let purpleSelected = Color(red: 101/255, green: 103/255, blue: 174/255)
}

//Button Linear Gradient
extension LinearGradient {
    init( colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct ButtonStyleNeomorphic: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label//holds the content of the button
            .padding(5)
            .contentShape(Circle())
            .background(
                Group {
                    if configuration.isPressed {
                        Circle()
                            .overlay(
                                Circle()
                                .stroke(Color.gray, lineWidth: 4)
                                .blur(radius: 4)
                                .offset(x: 2, y: 2)
                                .mask(Circle().fill(LinearGradient(colors: Color.black, Color.clear)))
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 8)
                                    .blur(radius: 4)
                                    .offset(x: -2, y: -2)
                                    .mask(Circle().fill(LinearGradient(colors: Color.clear, Color.black)))
                            )
                            
                    } else {
                        Circle()
                            .fill(Color.offWhite)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5,y: -5)
                    }
                    
                }

            )
            .cornerRadius(50)
    }
}

struct DarkBackground<S: Shape>: View {
    var isHighlightend: Bool
    var shape: S
    var body: some View {
        ZStack {
            if isHighlightend {
                shape
                    .fill(Color.darkBlueGrayEnd)
                    .shadow(color: Color.darkBlueGrayStart, radius: 4, x: 0, y: 5)
                    .shadow(color: Color.purpleSelected, radius: -2, x: 2,y: 3).blur(radius: 2)
            }
            else {
                shape
                    .fill(Color.darkBlueGrayEnd)
                    .shadow(color: Color.darkBlueGrayStart, radius: 10, x: -10, y: -10)
                    .shadow(color: Color.darkBlueGrayEnd, radius: 12, x: -4, y: 10)
            }
        }
    }
    
   
}

struct DarkButtonStyle: ButtonStyle {
    @Binding var isToggled: Bool
    @Binding var toggledCount: Int

    func makeBody(configuration: Self.Configuration) -> some View {
        Button(action: {
            withAnimation {
                if !isToggled && toggledCount < 1 {
                    isToggled.toggle()
                    toggledCount += 1
                } else if isToggled {
                    isToggled.toggle()
                    toggledCount -= 1
                }
            }
        }) {
            configuration.label
                .contentShape(Circle())
                .background(
                    DarkBackground(isHighlightend: isToggled, shape: Circle())
                )
        }
    }
}

//ToggleStyle
struct DarkToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Button (action : {
            configuration.isOn.toggle()
            
        }) {
            configuration.label
//                .padding(40)
                .contentShape(Circle())
                
        }
        .background(
            DarkBackground(isHighlightend: configuration.isOn, shape: Circle())
                
        )
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

struct MoodSelection: View {
    private var shouldNavigate: Bool {
        //toggledCount >= 2
        toggledCount == 1
    }
    
    @State private var toggledCount = 0
    @State private var isSadToggled = false
    @State private var isFunToggled = false
    @State private var isNostalgicToggled = false
    @State private var isTensedToggled = false
    @State private var isAngryToggled = false
    @State private var isPassionateToggled = false
    @State private var isExcitedToggled = false
    @State private var isScaredToggled = false
    @State private var isIntruigedToggled = false
    
    @State private var selectedMoods: Moods?
    @State private var activeNavigationLink: String?
    
    // Helper function to display mood image or GIF based on the toggle state
    
    

    func moodImage(_ imageName: String, isToggled: Bool) -> some View {
        if isToggled {
            if let url = Bundle.main.url(forResource: imageName, withExtension: "gif") {
                return AnyView(
                    AnimatedImage(url: url)
                        .resizable()
                        .scaledToFit()
                )
            } else {
                return AnyView(
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                )
            }
        } else {
            return AnyView(
                Image(imageName)
                    .resizable()
                    .scaledToFit()
            )
        }
    }

    var body: some View {
        NavigationView {
            Image("NEW_bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    ZStack {
                        VStack {
                            VStack {
                                HStack {
                                    // Sad button
                                    VStack {
                                        Button(action: {
                                            isSadToggled.toggle()
                                            
                                        }) {
                                            //Gif animation part
                                            Image("Sad")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
//                                            moodImage("Sad", isToggled: isSadToggled)
                                        }
                                        .buttonStyle(DarkButtonStyle(isToggled: $isSadToggled, toggledCount: $toggledCount))
                                        .padding(5)
                                        Text("Sad")
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                                            .cornerRadius(20)
                                            .glow()
                                    }
                                    //Fun button
                                    VStack {
                                        Button(action: {
                                            isFunToggled.toggle()
                                        
                                            
                                        }) {
                                            Image("Fun")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        }
                                        .buttonStyle(DarkButtonStyle(isToggled: $isFunToggled, toggledCount: $toggledCount))
                                        .padding(5)
                                        Text("Fun")
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                                            .cornerRadius(20)
                                            .glow()
                                    }
                                    //Nostalgic button
                                    VStack {
                                        Button(action: {
                                            isNostalgicToggled.toggle()
                                            print("Button Nostalgic taped")
                                        }) {
                                            Image("Nostalgic")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        }
                                        .buttonStyle(DarkButtonStyle(isToggled: $isNostalgicToggled, toggledCount: $toggledCount))
                                        .padding(5)
                                        Text("Nostalgic")
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                                            .cornerRadius(20)
                                            .glow()
                                    }
                                    
                                }
                                .padding()
                                //Tensed button
                                VStack {
                                    HStack {
                                        VStack{
                                            
                                            Button(action: {
                                                isTensedToggled.toggle()
                                            }) {
                                                Image("Tensed")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            }
                                            .buttonStyle(DarkButtonStyle(isToggled: $isTensedToggled, toggledCount: $toggledCount))
                                            .padding(5)
                                            Text("Tensed")
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                                                .cornerRadius(20)
                                                .glow()
                                            
                                        }
                                        //Angry button
                                        VStack{
                                            
                                            Button(action: {
                                                isAngryToggled.toggle()
                                            }) {
                                                Image("Angry")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            }
                                            .buttonStyle(DarkButtonStyle(isToggled: $isAngryToggled, toggledCount: $toggledCount))
                                            .padding(5)
                                            Text("Angry")
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                                                .cornerRadius(20)
                                                .glow()
                                            
                                        }
                                        //Passionate button
                                        VStack{
                                            
                                            Button(action: {
                                                isPassionateToggled.toggle()
                                            }) {
                                                Image("Passionate")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            }
                                            .buttonStyle(DarkButtonStyle(isToggled: $isPassionateToggled, toggledCount: $toggledCount))
                                            .padding(5)
                                            Text("Passionate")
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                                                .cornerRadius(20)
                                                .glow()
                                            
                                        }
                                        
                                    }
                                }
                                .padding()
                                //Excited button
                                VStack {
                                    HStack {
                                        VStack{
                                            
                                            Button(action: {
                                                isExcitedToggled.toggle()
                                            }) {
                                                Image("Excited")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            }
                                            .buttonStyle(DarkButtonStyle(isToggled: $isExcitedToggled, toggledCount: $toggledCount))
                                            .padding(5)
                                            Text("Excited")
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                                                .cornerRadius(20)
                                                .glow()
                                            
                                        }
                                        //Scared button
                                        VStack{
                                            
                                            Button(action: {
                                                isScaredToggled.toggle()
                                            }) {
                                                Image("Scared")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            }
                                            .buttonStyle(DarkButtonStyle(isToggled: $isScaredToggled, toggledCount: $toggledCount))
                                            .padding(5)
                                            Text("Scared")
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                                                .cornerRadius(20)
                                                .glow()
                                            
                                        }
                                        //Intruiged button
                                        VStack{
                                            
                                            Button(action: {
                                                isIntruigedToggled.toggle()
                                            }) {
                                                Image("Intruiged")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            }
                                            .buttonStyle(DarkButtonStyle(isToggled: $isIntruigedToggled, toggledCount: $toggledCount))
                                            .padding(5)
                                            Text("Intruiged")
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                                                .cornerRadius(20)
                                                .glow()
                                            
                                        }
                                        
                                    }
                                    
                                    .padding()
                                }
                                //Navigation path to the recommendation page
                                NavigationLink(destination: Recommendation(selectedMood: selectedMoods ?? Moods.fun),
                                               tag: "navigate",
                                               selection: $activeNavigationLink
                                )
                                {
                                    EmptyView()
                                }
                                
                            }
                            
                            .navigationViewStyle(StackNavigationViewStyle())
                            .accentColor(.white)
                            .foregroundColor(.white)
                            .background(Color.black.edgesIgnoringSafeArea(.all))
                            .onChange(of: toggledCount, perform: { value in
                                if shouldNavigate {
                                    
                                    if (isSadToggled) {
                                        selectedMoods = Moods.sad
                                    } else if (isFunToggled) {
                                        selectedMoods = Moods.fun
                                    } else if (isAngryToggled) {
                                        selectedMoods = Moods.angry
                                    } else if(isScaredToggled) {
                                        selectedMoods = Moods.scared
                                    } else if(isTensedToggled) {
                                        selectedMoods = Moods.tensed
                                    } else if(isExcitedToggled) {
                                        selectedMoods = Moods.excited
                                    } else if(isIntruigedToggled) {
                                        selectedMoods = Moods.intrigued
                                    } else if(isNostalgicToggled) {
                                        selectedMoods = Moods.nostalgic
                                    } else if(isPassionateToggled) {
                                        selectedMoods = Moods.passionate
                                    }
                                    
                                    
                                    //2 seconds delay upon selecting a second mood
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        activeNavigationLink = "navigate"
                                    }
                                } else {
                                    activeNavigationLink = nil
                                }
                            })
                        }
                    }
                    
                    
                )

            
        }
        
    }
   
}

struct Previews_MoodSelection_Previews: PreviewProvider {
    static var previews: some View {
        MoodSelection()
    }
}

