//
//  HourlyWeatherView.swift
//  Weather247
//
//  Created by Thabiso Gaereetse on 2023/07/27.
//

import SwiftUI

struct HourlyWeatherView: View {
    // Create an array with hourly times from 01:00 to 00:00
    let hourlyTimes = (1...24).map { String(format: "%02d:00", $0 % 24) }
    
    var body: some View {
        VStack{
            VStack{
                Divider()
                Text("Today's Weather")
                    .font(.headline)
                    .padding(.bottom, -5)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    // Use a ForEach loop to display hourly times inside RoundedRectangle
                    ForEach(hourlyTimes, id: \.self) { time in
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 70, height: 100)
                            .foregroundColor(Color("color"))
                            .shadow(color: Color(.label),radius: 0.1)
                            .overlay(
                                VStack {
                                    Text("23°")
                                        .padding(.bottom, -10)
                                        .fontWeight(.medium)
                                    Image("cloudy")
                                        .resizable()
                                        .frame(width: 50 ,height: 50)
                                        .scaledToFit()
                                        .padding(.bottom, -10)
                                    Text(time) // Display hourly time
                                        .font(.system(size: 10))
                                        .foregroundColor(Color(.secondaryLabel))
                                }
                            )
                    }
                }
            }
        }
    }
}

struct HourlyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
