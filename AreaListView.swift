//
//  AreaListView.swift
//  Weather247
//
//  Created by Thabiso Gaereetse on 2023/08/04.
//
import SwiftUI

struct SelectedPlacesListView: View {
    @Binding var selectedItems: [String]
    @Binding var isShowingList: Bool

    var body: some View {
        VStack {
            Text("Selected Places:")
                .font(.headline)
                .padding()

            List {
                ForEach(selectedItems.reversed(), id: \.self) { item in
                    Text(item)
                }
                .onDelete { indices in
                    selectedItems.remove(atOffsets: indices)
                }
            }

            Button(action: {
                selectedItems.removeAll()
                isShowingList = false
            }) {
                Text("Clear List")
                    .foregroundColor(.red)
            }
        }
        .toolbar {
            EditButton()
        }
    }
}

//struct SelectedPlacesListView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectedPlacesListView(selectedItems: .constant(["Place 1", "Place 2"]), isShowingList: .constant(true))
//    }
//}
