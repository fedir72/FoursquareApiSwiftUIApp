//
//  TestView.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 23.08.25.
//

import SwiftUI
import RealmSwift

struct StartListView: View {
  
  //MARK: - properties
  @EnvironmentObject var dataSource: PlacesDataSource
  @ObservedResults(RealmCity.self) var cities
  @State private var searchText = ""
  @State private var showSearchBar = false
  @State private var showSearchResult = false
  
  var body: some View {
    
    NavigationStack {
      VStack {
        //MARK: - SearchBar
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
        
        //MARK: - realmCityList
        if cities.isEmpty {
          apologizeView()
        } else {
          
          List {
            ForEach(cities) { city in
              NavigationLink {
                apologizeView()
              } label: {
                CityRow(city: city)
              }
              .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                  // city — из @ObservedResults, принадлежит Realm
                  $cities.remove(city)
                } label: {
                  Label("Удалить", systemImage: "trash")
                }
              }
            }
          }
        }
        Spacer()
      }
      .sheet(isPresented: $showSearchResult) {
        ShowCitySearchResultView(searchCityTerm: searchText)
      }
      
      
      //MARK: - navigations
      .navigationTitle("Explore landmarks around the world")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            withAnimation(.spring()) {
              searchText = ""
              showSearchBar.toggle()
            }
          } label: {
            Image(systemName: "magnifyingglass.circle")
              .font(.title)
          }
        }
      }
    }
    
  }
  
  // MARK: - Удаление объекта Realm
  private func deleteCity(_ city: RealmCity) {
    do {
      let realm = try Realm() // новый, живой инстанс
      if !city.isInvalidated {
        try realm.write {
          realm.delete(city)
        }
      }
    } catch {
      print("Ошибка при удалении: \(error)")
    }
  }
  
  private func deleteCitySafely(_ city: RealmCity) {
    // Проверяем валидность и что Realm не frozen
    guard let realm = city.realm, !city.isInvalidated, !realm.isFrozen else { return }
    do {
      try realm.write {
        realm.delete(city)
      }
    } catch {
      print("Ошибка при удалении объекта Realm: \(error)")
    }
  }
  
  
  
  // MARK: - Загрузка городов (пример)
  private func loadCities(term: String, limit: Int) {
    guard !term.isEmpty else { return }
    dataSource.loadCities(by: term, limit: limit)
    showSearchResult.toggle()
  }
  
  // MARK: - Apologize View (мок)
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
  StartListView()
    .environmentObject(
      PlacesDataSource(networkProvider: NetworkProvider())
    )
}

struct CityRow: View {
  let city: CityRepresentable
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(city.name)
        .font(.headline)
        .foregroundStyle(.blue)
      Text(city.fullAddress)
        .font(.subheadline)
        .foregroundColor(.gray)
      Text(city.coordinateText)
        .font(.subheadline)
        .foregroundColor(.gray)
    }
    .padding(.vertical, 6)
  }
}


