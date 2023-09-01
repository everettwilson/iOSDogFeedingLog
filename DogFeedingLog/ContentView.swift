//
//  ContentView.swift
//  DogFeedingLog
//
//  Created by Everett Wilson on 8/31/23.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var lastFeedingTime: String = "Not yet fetched"
    @State private var errorMessage: String = ""

    var body: some View {
        VStack {
            Button("Log Feeding Time") {
                // Your code to log feeding time will go here
                logFeedingTime()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)

            Button("Get Last Feeding Time") {
                // Your code to get the last feeding time will go here
                getLastFeedingTime()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        Text("Last feeding time: \(lastFeedingTime)").padding()

        if !errorMessage.isEmpty {
            Text("Error: \(errorMessage)")
        }
    }

    func logFeedingTime() {
        guard let url = URL(string: "https://7px8d2brr8.execute-api.us-west-2.amazonaws.com/prod/logfeedingtime") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error)")
                    self.errorMessage = "Failed to log data: \(error.localizedDescription)"
                } else if let data = data, let str = String(data: data, encoding: .utf8) {
                    print("Received data:\n\(str)")
                    self.lastFeedingTime = str
                }
            }
        }
        task.resume()
    }

    func getLastFeedingTime() {
        guard let url = URL(string: "https://7px8d2brr8.execute-api.us-west-2.amazonaws.com/prod/getlastfeedingtime") else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error)")
                    self.errorMessage = "Failed to get data: \(error.localizedDescription)"
                } else if let data = data {
                    let str = String(data: data, encoding: .utf8)
                    print("Received data:\n\(str ?? "")")
                    self.lastFeedingTime = str!
                }
            }
        }
        task.resume()
    }
    
}
