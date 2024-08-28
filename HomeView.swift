// HomeView.swift

import SwiftUI

struct HomeView: View {
    @State private var isFavorites = false
    @State private var searchText = ""
    @State private var rectangleHeight: CGFloat = 150 // Initial height
    
    let minHeight: CGFloat = 150
    let maxHeight: CGFloat = 960
    
    // For auto-suggestion
    @State private var weatherSearchAPI: WeatherSearchAPI?
    @State private var isShowingSuggestions = false
    @State private var selectedPlace: String?
    @State private var previouslySelectedPlace: String? // Added state variable
    
    var body: some View {
        NavigationView {
            VStack {
//                HStack {
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text("Today, \(getCurrentDate())")
//                                .font(.system(size: 15))
//                                .foregroundColor(Color(.secondaryLabel))
//                                .padding(.bottom, -5)
//
//                            HStack {
//                                Image("pin")
//                                    .resizable()
//                                    .frame(width: 25, height: 25)
//                                Text(selectedPlace ?? "Location")
//                                    .fontWeight(.medium)
//                                    .font(.system(size: 20))
//                                    .padding(.leading, -8)
//                            }
//                        }
//                        .padding(.leading)
//                    }
//                    Spacer()
////                    NavigationLink(destination: SelectedPlacesListView(selectedItems: $selectedItems, isShowingList: $isShowingList)) {
////                        RoundedRectangle(cornerRadius: 30)
////                            .fill(.red)
////                            .frame(width: 40, height: 40)
////                            .overlay(
////                                Image(systemName: "list.bullet.indent")
////                            )
////                            .foregroundColor(Color(.white))
////                            .padding(.trailing)
////                            .shadow(color: Color(.red).opacity(0.5), radius: 2.9)
////                    }
//                }
                
                VStack {
                    // Pass the selectedPlace to CurrentWeatherView
                    CurrentWeatherView()
                        .padding(.top, -20)
                    Spacer()
                }
                
                
            }
            .padding(.top)
            .navigationBarHidden(true)
        }.onChange(of: selectedPlace) { newValue in
            // Call the API and update the weather data when the selectedPlace changes
            getWeatherForSelectedPlace()
        }
    }
    
    func getWeatherForSelectedPlace() {
            if let place = selectedPlace {
                WeatherAPIManager.getArea(searchText: place) { apiResponse in
                    self.weatherSearchAPI = apiResponse
                }
            }
        }
    
    func getArea() {
        if !searchText.isEmpty {
            WeatherAPIManager.getArea(searchText: searchText) { apiResponse in
                self.weatherSearchAPI = apiResponse
            }
        } else {
            // Clear the suggestions if the search text is empty
            weatherSearchAPI = nil
        }
    }
    
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        return dateFormatter.string(from: Date())
    }

    
    // Debounce helper function to delay API calls
    private func debounce(seconds: Double, action: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            action()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
