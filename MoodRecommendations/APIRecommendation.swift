//
//  APIRecommendation.swift
//  MoodRecommendations
//
//  Created by Balutoiu Rares Mihai on 31/03/2023.
//

import Foundation

struct PrimaryImage: Codable {
    var id: String
    var url: String
}

struct TitleType: Codable {
    var text: String
}

struct TitleText: Codable {
    var text: String
}

struct ReleaseYear: Codable {
    var year: Int
}

struct Result: Codable {
    var id: String
    var primaryImage: PrimaryImage?
    var titleType: TitleType
    var titleText: TitleText
    var releaseYear: ReleaseYear
}

struct ReturnedData: Codable {
    var page: Int
    var next: String
    var entries: Int
    var results: [Result]
}

struct ReturnDescription: Codable {
    var description: String?
}

struct ReturnRating: Codable {
    var results: RatingResults?
}

struct RatingResults: Codable {
    var averageRating: Double
}

func getRandomYear() -> Int {
    return 2000 + Int.random(in: 16..<20)
}

func getGenre(mood: Moods) -> String {
    
    switch mood {
               case .fun:
                   return "Comedy"
               case .scared:
                   return "Horror"
               case .tensed:
                   return "Thriller"
               case .passionate:
                   return "Romance"
               case .intrigued:
                   return "Mystery"
               case .excited:
                   return "Action"
               case .angry:
                   return "Reality-TV"
               case .nostalgic:
                   return "Animation"
               case .sad:
                   return "Documentary"
               }
        
}

func getMovies(genre: String) -> ReturnedData? {
    
    let year = getRandomYear()
    var resultString = ""
    var returnedData: ReturnedData?
        
    let headers = [
        "X-RapidAPI-Key": "8f7ea7d129msha74ee86dde59cf2p18f368jsn8d64e56827b8",
        "X-RapidAPI-Host": "moviesdatabase.p.rapidapi.com"
    ]
    
    let request = NSMutableURLRequest(url: NSURL(string: "https://moviesdatabase.p.rapidapi.com/titles?genre=\(genre)&startYear=\(year)")! as URL,
                                            cachePolicy: .useProtocolCachePolicy,
                                        timeoutInterval: 10.0)
    
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers

    let semaphore = DispatchSemaphore(value: 0)
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
        guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data available")
            return
        }
        if let httpResponse = response as? HTTPURLResponse {
            print(httpResponse.statusCode)
        }
        
        do {
            returnedData = try JSONDecoder().decode(ReturnedData.self, from: data)
        } catch let error {
            print(error)
            return
        }
        
//        resultString = String(data: data, encoding: .utf8) ?? ""
//        print(resultString)
        
        semaphore.signal()
    }
    
    task.resume()
    semaphore.wait()

//    if let data = resultString.data(using: .utf8) {
//        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//        let result = json?["result"] as? [String: Any]
//        print(result)
//    }
    
    return returnedData
}

func getMovieDescription(id: String?) -> String? {
    
    if (id == nil) {
        return nil
    }

    var returns: ReturnDescription?
    let urlString = "https://mdblist.p.rapidapi.com/?i=\(id!)"
    print(urlString)
    
    let headers = [
        "X-RapidAPI-Key": "8f7ea7d129msha74ee86dde59cf2p18f368jsn8d64e56827b8",
        "X-RapidAPI-Host": "mdblist.p.rapidapi.com"
    ]

    let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL,
                                            cachePolicy: .useProtocolCachePolicy,
                                        timeoutInterval: 10.0)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers

    let semaphore = DispatchSemaphore(value: 0)
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data available")
            return
        }
        if let httpResponse = response as? HTTPURLResponse {
            print(httpResponse.statusCode)
        }
        
        do {
            returns = try JSONDecoder().decode(ReturnDescription.self, from: data)
        } catch let error {
            print(error)
            return
        }
        semaphore.signal()
    })

    dataTask.resume()
    
    semaphore.wait()
    
    return returns?.description
}

func getMovieRating(id: String?) -> Double? {
    
    if (id == nil) {
        return nil
    }

    var returns: ReturnRating?
    let urlString = "https://moviesdatabase.p.rapidapi.com/titles/\(id!)/ratings"
    
    print(urlString)
    
    let headers = [
        "X-RapidAPI-Key": "830d8c46edmshb9129997db59873p1e045cjsn9a3ca72b1b86",
        "X-RapidAPI-Host": "moviesdatabase.p.rapidapi.com"
    ]

    let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL,
                                            cachePolicy: .useProtocolCachePolicy,
                                        timeoutInterval: 10.0)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers

    let semaphore = DispatchSemaphore(value: 0)
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data available")
            return
        }
        if let httpResponse = response as? HTTPURLResponse {
            print(httpResponse.statusCode)
        }
        
        do {
            returns = try JSONDecoder().decode(ReturnRating.self, from: data)
            print(returns?.results?.averageRating)
        } catch let error {
            print(error)
            return
        }
        
        let resultString = String(data: data, encoding: .utf8) ?? ""
                   print(resultString)
           
       /*if let data = resultString.data(using: .utf8) {
           let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
              let result = json?["averageRating"] as? [String: Any]
               print(result)
           }*/
        
        semaphore.signal()
    })

    dataTask.resume()
    
    semaphore.wait()
    
    return returns?.results?.averageRating
}
