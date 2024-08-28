//
//  CurrentWeatherView.swift
//  Weather247
//
//  Created by Thabiso Gaereetse on 2023/07/26.
//

import SwiftUI

struct CurrentWeatherView: View {
    @State private var searchText = ""
    @State private var weatherSearchAPI: WeatherSearchAPI?
    @State private var isShowingSuggestions = false
    @State private var selectedPlace: String?
    @State private var previouslySelectedPlace: String? // Added state variable
    // Create an array with hourly times from 01:00 to 00:00
    let hourlyTimes = (1...24).map { String(format: "%02d:00", $0 % 24) }
    
    // Create a list to store selected items
    @State private var selectedItems: [String] = []
    @State private var isShowingList = false
    
    @State private var rectangleHeight: CGFloat = 150 // Initial height
    
    let minHeight: CGFloat = 150
    let maxHeight: CGFloat = 960

    let customWeatherIcons: [String: String] = [
        "Moderate or heavy snow in area with thunder": "patchyHeavySnowThunder",
        "Patchy light snow in area with thunder": "patchyLightSnowThunder",
        "Moderate or heavy rain in area with thunder": "patchyRainWithThunder",
        "Patchy light rain in area with thunder": "patchyRainWithThunder",
        "Moderate or heavy showers of ice pellets": "freezingDrizzle",
        "Light showers of ice pellets": "lightSleetShowers",
        "Moderate or heavy snow showers": "moderateSnow",
        "Light snow showers": "patchySnowNearby",
        "Moderate or heavy sleet showers": "freezingDrizzle",
        "Light sleet showers": "lightDrizzle",
        "Torrential rain shower": "lightAndModerateRain",
        "Moderate or heavy rain shower": "lightAndModerateRain",
        "Light Rain Shower": "lightDrizzle",
        "Light rain shower": "lightDrizzle",
        "Ice pellets": "patchySnow",
        "Heavy snow": "moderateSnow",
        "Patchy heavy snow": "moderateSnow",
        "Moderate snow": "moderateSnow",
        "Patchy moderate snow": "moderateSnow",
        "Light snow": "patchySnow",
        "Patchy light snow": "patchySnow",
        "Moderate or heavy sleet": "moderateSnow",
        "Light sleet": "patchySnow",
        "Moderate or Heavy freezing rain": "freezingDrizzle",
        "Light freezing rain": "lightSleetShowers",
        "Heavy rain": "lightAndModerateRain",
        "Heavy rain at times": "lightAndModerateRain",
        "Moderate rain": "ModerateRainAtTimes",
        "Moderate rain at times": "ModerateRainAtTimes",
        "Light rain": "lightAndModerateRain",
        "Patchy light rain": "patchyRainNearby",
        "Heavy freezing drizzle": "freezingDrizzle",
        "Freezing drizzle": "freezingDrizzle",
        "Light drizzle": "ModerateRainAtTimes",
        "Patchy light drizzle": "ModerateRainAtTimes",
        "Patchy rain possible": "lightAndModerateRain",
        "Freezing fog": "freezingFog",
        "Fog": "fog",
        "Blizzard": "blizzard",
        "Blowing snow": "blowingSnow",
        "Thundery outbreaks in nearby": "thunderOutbreaks",
        "Patchy freezing drizzle nearby": "patchySleetNearby",
        "Patchy sleet nearby": "patchySleetNearby",
        "Patchy snow nearby": "patchySnowNearby",
        "Patchy rain nearby": "patchyRainNearby",
        "Mist": "fog",
        "Overcast": "overcast",
        "Cloudy": "cloudy",
        "Partly cloudy": "cloudy",
        "Sunny": "sunny",
        "Clear": "sunny"
    ]
    
    var body: some View {
            VStack {
                HStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Today, \(getCurrentDate())")
                                .font(.system(size: 15))
                                .foregroundColor(Color(.secondaryLabel))
                                .padding(.bottom, -5)

                            HStack {
                                Image("pin")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                Text(selectedPlace ?? "Location")
                                    .fontWeight(.medium)
                                    .font(.system(size: 20))
                                    .padding(.leading, -8)
                            }
                        }
                        .padding(.leading)
                    }
                    Spacer()
                    NavigationLink(destination: SelectedPlacesListView(selectedItems: $selectedItems, isShowingList: $isShowingList)) {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.teal)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "list.bullet.indent")
                            )
                            .foregroundColor(Color(.white))
                            .padding(.trailing)
                            .shadow(color: Color(.systemTeal).opacity(0.5), radius: 2.9)
                    }
                }
                .padding(.top, 25)
                TextField("Search", text: $searchText, onEditingChanged: { isEditing in
                    isShowingSuggestions = isEditing
                }, onCommit: {
                    getArea()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                if isShowingSuggestions {
                    if let suggestedPlaces = weatherSearchAPI?.data?.request {
                        ScrollView {
                            VStack(spacing: 8) {
                                ForEach(suggestedPlaces, id: \.query) { place in
                                    Button(action: {
                                        // Add the selected item to the list
                                        selectedItems.append(place.query ?? "")
                                        
                                        // Update the selected place
                                        selectedPlace = place.query
                                        // Close the suggestion view by setting isShowingSuggestions to false
                                        isShowingSuggestions = false
                                    }, label: {
                                        Image("searchedArea")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                        Text(place.query ?? "")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    })
                                }
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("Color")))
                            .shadow(radius: 5)
                        }
                        .frame(maxHeight: 50)
                        .padding(.top, -20)
                    }
                }

                ScrollView(.vertical, showsIndicators: false){
                    VStack{
                        Image("Dotted World Map")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 280)
                            .opacity(0.4)
                            .blur(radius: 6)
                            .overlay(
                                VStack{
                                    
                                    VStack{
                                        Text("\(weatherSearchAPI?.data?.currentCondition?[0].tempC ?? "0")°")
                                            .fontWeight(.heavy)
                                            .font(.system(size: 70))
                                            .padding(.bottom, -20)
                                            .overlay(
                                                VStack {
                                                    if let data = weatherSearchAPI?.data {
                                                        if let weatherCondition = data.currentCondition?[0].weatherDesc?.first?.value,
                                                           let iconName = customWeatherIcons[weatherCondition],
                                                           let customImage = UIImage(named: iconName) {
                                                            Image(uiImage: customImage)
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: 150, height: 150)
                                                        } else {
                                                            // Show the default image here when no matching icon is found
                                                            Image("question mark") // Replace "defaultImageName" with the actual name of your default image asset
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: 100, height: 150)
                                                        }
                                                    } else {
                                                        // Show the default image here when weather data is not available
                                                        Image("question mark") // Replace "defaultImageName" with the actual name of your default image asset
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: 100, height: 150)
                                                    }
                                                }.padding(.bottom, 130)
                                            )
                                        
                                        Text("\(weatherSearchAPI?.data?.currentCondition?[0].weatherDesc?.first?.value ?? "Weather Condition")")
                                            .fontWeight(.medium)
                                            .font(.system(size: 25))
                                    }
                                    HStack{
                                        Spacer()
                                        VStack{
                                            RoundedRectangle(cornerRadius: 30)
                                                .fill(Color("Color"))
                                                .frame(width: 50, height: 50)
                                                .shadow(color: Color(.purple).opacity(0.3),radius: 0.9)
                                                .overlay(
                                                    Image(systemName: "wind")
                                                        .resizable()
                                                        .frame(width: 25, height: 20)
                                                        .foregroundColor(Color.purple)
                                                )
                                            Text("\(weatherSearchAPI?.data?.currentCondition?[0].windspeedKmph ?? "0") km/h")
                                                .font(.system(size: 15))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color(.label))
                                            Text("Wind")
                                                .font(.system(size: 13))
                                                .foregroundColor(Color(.secondaryLabel))
                                            
                                        }
                                        .padding(.horizontal, 10)
                                        
                                        VStack{
                                            RoundedRectangle(cornerRadius: 30)
                                                .fill(Color("Color"))
                                                .frame(width: 50, height: 50)
                                                .shadow(color: Color(.orange).opacity(0.3),radius: 0.9)
                                                .overlay(
                                                    Image(systemName: "sun.max")
                                                        .resizable()
                                                        .frame(width: 30, height: 30)
                                                        .foregroundColor(Color.orange)
                                                )
                                            
                                            Text("\(weatherSearchAPI?.data?.currentCondition?[0].uvIndex ?? "0")")
                                                .font(.system(size: 15))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color(.label))
                                            Text("UV")
                                                .font(.system(size: 13))
                                                .foregroundColor(Color(.secondaryLabel))
                                        }
                                        .padding(.horizontal, 30)
                                        
                                        VStack{
                                            RoundedRectangle(cornerRadius: 30)
                                                .fill(Color("Color"))
                                                .frame(width: 50, height: 50)
                                                .shadow(color: Color(.cyan).opacity(0.3),radius: 0.9)
                                                .overlay(
                                                    Image(systemName: "drop")
                                                        .resizable()
                                                        .frame(width: 20, height: 25)
                                                        .foregroundColor(Color.cyan)
                                                )
                                            Text("\(weatherSearchAPI?.data?.currentCondition?[0].precipMM ?? "0")%")
                                                .font(.system(size: 15))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color(.label))
                                            Text("Precipitaton")
                                                .font(.system(size: 13))
                                                .foregroundColor(Color(.secondaryLabel))
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                    
                                }
                                    .padding(.bottom, -140)
                            )
                        Spacer()
                    }
                    
                    VStack{
                        VStack{
                            Divider()
                                .padding(.top, 15)
                            Text("Today's Weather")
                                .font(.headline)
                                .padding(.top, 15)
                        }.padding(.top, 50)
                        ScrollView(.horizontal, showsIndicators: false) {
                            VStack{
                                if let hourlyWeatherData = weatherSearchAPI?.data?.weather?.first?.hourly {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            // Use a ForEach loop to display hourly times inside RoundedRectangle
                                            ForEach(hourlyWeatherData, id: \.time) { hourlyData in
                                                RoundedRectangle(cornerRadius: 10)
                                                    .frame(width: 70, height: 100)
                                                    .foregroundColor(Color("color"))
                                                    .shadow(color: Color(.label), radius: 0.1)
                                                    .overlay(
                                                        VStack {
                                                            Text("\(hourlyData.tempC ?? "0")°C")
                                                                .padding(.bottom, -10)
                                                                .fontWeight(.medium)
                                                            if let data = weatherSearchAPI?.data {
                                                                if let weatherCondition = data.currentCondition?[0].weatherDesc?.first?.value,
                                                                   let iconName = customWeatherIcons[weatherCondition],
                                                                   let customImage = UIImage(named: iconName) {
                                                                    Image(uiImage: customImage)
                                                                        .resizable()
                                                                        .aspectRatio(contentMode: .fit)
                                                                        .frame(width: 50, height: 50)
                                                                } else {
                                                                    // Show the default image here when no matching icon is found
                                                                    Image("question mark")
                                                                        .resizable()
                                                                        .aspectRatio(contentMode: .fit)
                                                                        .frame(width: 50, height: 50)
                                                                }
                                                            } else {
                                                                // Show the default image here when weather data is not available
                                                                Image("question mark")
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fit)
                                                                    .frame(width: 50, height: 50)
                                                            }
                                                            Text("\(hourlyData.time?.insert(separator: ":", beforeLast: 2) ?? "")")
                                                                .font(.system(size: 10))
                                                                .foregroundColor(Color(.secondaryLabel))
                                                        }
                                                    )
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                } else {
                                    VStack(alignment: .center){
                                        // If no hourly weather data is available, show a sample message
                                        Text("No hourly weather data available")
                                            .font(.system(size: 16))
                                            .foregroundColor(Color(.secondaryLabel))
                                            .padding()
                                            .multilineTextAlignment(.center)
                                    }
                                }
                            }.padding(.horizontal, 80)
                        }
                    }
                }
                VStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.ultraThinMaterial)
                            .frame(height: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.ultraThinMaterial)
                                    .frame(height: rectangleHeight)
                                    .padding(.bottom, -50)
                                    .shadow(color: Color(.black).opacity(0.3),radius: 9.2, y: -2)
                                    .gesture(
                                        DragGesture().onChanged { drag in
                                            // Update the rectangle height based on the drag offset
                                            let offsetY = drag.translation.height
                                            let newHeight = rectangleHeight - offsetY
                                            rectangleHeight = max(minHeight, min(maxHeight, newHeight))
                                        }
                                        .onEnded { drag in
                                            let offsetY = drag.translation.height
                                            if offsetY > 50 {
                                                // User dragged down significantly, set the rectangle to its original size
                                                rectangleHeight = minHeight
                                            } else if offsetY < -50 {
                                                // User dragged up significantly, set the rectangle to its maximum size
                                                rectangleHeight = maxHeight
                                            }
                                        }
                                    )
                                    .overlay(
                                        VStack {
                                            VStack {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .frame(width: 50, height: 4)
                                                    .foregroundColor(Color(.tertiaryLabel))
                                                    .padding(.top, 10)
                                                VStack{
                                                    Text("Weekly Weather Forecast")
                                                        .font(.system(size: 20))
                                                        .fontWeight(.bold)
                                                        .padding(.top, 16)
                                                    ScrollView(.vertical, showsIndicators: false){
                                                        if let weatherForecast = weatherSearchAPI?.data?.weather {
                                                            VStack(alignment: .leading) {
                                                                ForEach(weatherForecast, id: \.date) { weatherData in
                                                                    VStack {
                                                                        Divider()
                                                                        HStack{
                                                                            Text("Date: \(weatherData.date ?? "")")
                                                                            Divider()
                                                                            Text("\(weatherData.hourly?.first?.weatherDesc?.first?.value ?? "")")
                                                                            if let weatherCondition = weatherData.hourly?.first?.weatherDesc?.first?.value,
                                                                                                       let iconName = customWeatherIcons[weatherCondition],
                                                                                                       let customImage = UIImage(named: iconName) {
                                                                                                        Image(uiImage: customImage)
                                                                                                            .resizable()
                                                                                                            .aspectRatio(contentMode: .fit)
                                                                                                            .frame(width: 25, height: 25)
                                                                                                    } else {
                                                                                                        // Show a default image when no matching icon is found
                                                                                                        Image("question mark")
                                                                                                            .resizable()
                                                                                                            .aspectRatio(contentMode: .fit)
                                                                                                            .frame(width: 25, height: 25)
                                                                                                    }
                                                                        }
                                                                        
                                                                        HStack{
                                                                            Spacer()
                                                                            HStack{
                                                                                Text("\(weatherData.maxtempC ?? "")°C")
                                                                                    .fontWeight(.medium)
                                                                                Image("hotTherm")
                                                                                    .resizable()
                                                                                    .foregroundColor(Color(.red))
                                                                                    .frame(width: 25,height: 25)
                                                                            }
                                                                            .padding(.trailing)
                                                                            Divider()
                                                                            
                                                                            HStack{
                                                                                Image("coldTherm")
                                                                                    .resizable()
                                                                                    .foregroundColor(Color(.blue))
                                                                                    .frame(width: 25,height: 25)
                                                                                Text("\(weatherData.mintempC ?? "")°C")
                                                                                    .fontWeight(.medium)
                                                                            }
                                                                            .padding(.leading)
                                                                            Spacer()
                                                                        }
                                                                    }
                                                                }
                                                                Spacer()
                                                            }
                                                        }
                                                    }
                                                    .padding(.top, 20)
                                                }
                                                .padding(.bottom, -500)
                                                
                                                Spacer()
                                            }
                                            
                                            
//                                            GeometryReader { geometry in
                                                ScrollView(.vertical) {
                                                    
                                                }
                                                Spacer()
//                                            }
                                        }
                                    )
                                    // Set a higher z-index for the draggable view
                                    .zIndex(1)
                            )
                }
                Spacer()
                
            }
            .onChange(of: searchText) { newValue in
                isShowingSuggestions = true // Always show suggestions when there is text in the search field
                debounce(seconds: 1) {
                    getArea()
                }
            }
            .onChange(of: selectedPlace) { newValue in
                // Store the previously selected place whenever the selectedPlace changes
                previouslySelectedPlace = newValue
            }
        }
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        return dateFormatter.string(from: Date())
    }

        func getArea() {
            WeatherAPIManager.getArea(searchText: searchText) { apiResponse in
                self.weatherSearchAPI = apiResponse
            }
        }

        // Debounce helper function to delay API calls
        private func debounce(seconds: Double, action: @escaping () -> Void) {
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                action()
            }
        }
    }

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
extension String {
    func insert(separator: String, beforeLast n: Int) -> String {
        guard n < self.count else { return self }
        let index = self.index(self.endIndex, offsetBy: -n)
        return String(self[..<index]) + separator + String(self[index...])
    }
}


