//
//  SplashScreen.swift
//  Weather247
//
//  Created by Thabiso Gaereetse on 2023/08/07.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive{
            ContentView()
        }else{
            VStack{
                VStack{
                    Image("logo")
                        .resizable()
                        .frame(width: 340, height: 100)
                        .scaledToFit()
                        .foregroundColor(.red)
                        .shadow(color: Color(.systemTeal).opacity(0.3),radius: 10, x: 0.2, y: 0.2)
                    
//                        .padding(.top, 200.0)
                       
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration: 2.0)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                    
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation{
                        self.isActive = true
                    }
                }
            }
        }
    }
    
    struct SplashScreenView_Previews: PreviewProvider {
        static var previews: some View {
            SplashScreenView()
        }
    }
}

