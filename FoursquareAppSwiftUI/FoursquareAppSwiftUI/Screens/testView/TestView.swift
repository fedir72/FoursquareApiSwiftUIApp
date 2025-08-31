//
//  TestView.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 23.08.25.
//

import SwiftUI

import SwiftUI

struct TestView: View {
  @EnvironmentObject var dataSource: PlacesDataSource
  @State private var searchText = ""
  @State private var showSearchBar = false   // 👉 контролируем показ

  var body: some View {
      NavigationStack {
          VStack {
              // 🔍 Поисковая строка под заголовком
              if showSearchBar {
                HStack {
                  Button {
                    loadCities(term: searchText, limit: 15)
                    searchText = ""
                  } label: {
                    Image(systemName: "magnifyingglass")
                      .foregroundColor(searchText.isEmpty ? .gray : .blue)
                  }
                  .disabled(searchText.isEmpty)
                  
                  TextField("Введите название города", text: $searchText, onCommit: {
                    loadCities(term: searchText, limit: 15)
                  })
                  .textFieldStyle(PlainTextFieldStyle())
                  .autocorrectionDisabled()
                  .textInputAutocapitalization(.never)
                  
                  if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                      Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                    }
                  }
                }
                  .padding(10)
                  .background(Color(.systemGray6))
                  .cornerRadius(12)
                  .padding(.horizontal)
                  .transition(.move(edge: .top).combined(with: .opacity))
              }

              // 📋 Список
              if dataSource.cities.isEmpty {
                  apologizeView()
              } else {
                  List(dataSource.cities) { city in
                      CityRow(city: city)
                  }
              }
            Spacer()
          }
          .navigationTitle("Поиск городов")
          .toolbar {
              ToolbarItem(placement: .navigationBarTrailing) {
                  Button {
                      withAnimation(.spring()) {
                          searchText = ""
                          showSearchBar.toggle()
                      }
                  } label: {
                      Image(systemName: "magnifyingglass.circle" )
                      .font(.title)
                  }
              }
          }
      }
  }

  private func loadCities(term: String, limit: Int) {
       guard !term.isEmpty else { return }
       dataSource.loadCities(by: term, limit: limit)
   }
    
    // MARK: - apologizeView
    private func apologizeView() -> some View {
        VStack(spacing: 12) {
            Image(systemName: "wrongwaysign")
                .font(.largeTitle)
                .bold()
            Text("Unfortunately\nno cities were found")
                .multilineTextAlignment(.center)
                .font(.title2)
        }
        .foregroundStyle(.red)
        .padding()
    }
}

#Preview {
    // Для превью нужен моковый dataSource
    TestView()
        .environmentObject(
          PlacesDataSource(networkProvider: NetworkProvider())
        )
}

struct CityRow: View {
    let city: OpenMapCity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(city.name)
                .font(.headline)
            Text(city.fullAddress)
                .font(.subheadline)
                .foregroundColor(.gray)
          
            Text("Координаты: \(city.lat), \(city.lon)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
          Text("\(city.localNamesStrings.count)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 6)
    }
}



//struct TestView: View {
//  
//  @EnvironmentObject var dataSource: PlacesDataSource
//  
//  
//  
//  var body: some View {
//    VStack(alignment: .leading) {
//      if dataSource.cities.isEmpty {
//        apologizeView()
//      }
//      ScrollView {
//        List(dataSource.cities) {  item in
//          CityRow(city: item)
//        }
//      }
//    }
//      .onAppear() {
//        loadCities()
//      }
//      
//  }
//  
//  private func loadCities() {
//    dataSource.loadCities(by: "Budy", 15)
//  }
//  
//  //MARK: - apologizeView
//   private func apologizeView() -> some View {
//       VStack(spacing: 0) {
//           Image(systemName: "wrongwaysign")
//              .font(.largeTitle).bold()
//           Text("\nUnfortunately\nthis photo cannot be downloaded\nin full resolution")
//              .multilineTextAlignment(.center)
//              .font(.title2)
//       }
//     .foregroundStyle(.red)
//   }
//
//  
//}
//
//#Preview {
//    TestView()
//}
//
//struct CityRow: View {
//    let city: OpenMapCity  // Без биндинга, просто данные для отображения
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 1) {
//            // Название города
//            Text(city.name)
//                .font(.headline)
//            
//            // Координаты
//            Text("Координаты: \(city.lat), \(city.lon)")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//            
//            // Страна
//            Text("Страна: \(city.country ?? "not found")")
//                .font(.subheadline)
//                .foregroundColor(.secondary)
//        }
//        .padding(.vertical, 5)
//    }
//}
