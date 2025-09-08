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
  @EnvironmentObject var locationManager: LocationManager
  
  @ObservedResults(RealmCity.self) var cities
  
  @State private var searchText = ""
  @State private var showSearchBar = false
  @State private var showSearchResult = false
  
  //MARK: - body
  var body: some View {
    NavigationStack {
      ZStack {
        CityListView(cities: Array(cities))
          .padding(.top, showSearchBar ? 70 : 0)
          .sheet(isPresented: $showSearchResult) {
            CitySearchResultView(searchCityTerm: searchText)
          }
        VStack {
          if showSearchBar {
            searchBarView()
              .padding(10)
          }
          Spacer()
        }
      }
      .safeAreaInset(edge: .bottom) {
        exploreButton()
      }
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        startListToolbar()
      }
    }
  }
  
}

private extension StartListView {
  
  // MARK: - Toolbar
  @ToolbarContentBuilder
  private func startListToolbar() -> some ToolbarContent {
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
    ToolbarItem(placement: .principal) {
      Text("Explore sights Around the World")
        .font(.headline)
        .multilineTextAlignment(.center)
        .lineLimit(2)
        .minimumScaleFactor(0.8)
    }
  }
  
  //MARK: - exploreButton()
  @ViewBuilder
  private func exploreButton() -> some View {
    Button {
      locationManager.requestPermissionAndStart()
    } label: {
      Label("explore sights around me", systemImage: "location.circle.fill")
        .font(.title2)
        .foregroundColor(.white)
        .padding(.vertical, 14)
        .padding(.horizontal, 24)
        .background(Color.blue)
        .clipShape(Capsule())
    }
    .padding(.horizontal, 22)
    .padding(.vertical, 8)
    .background(Color(.systemGray6))
  }
  
  // MARK: - searchBarView()
  @ViewBuilder
  private func searchBarView() -> some View {
    HStack {
      Button {
        loadCities(term: searchText, limit: 15)
        searchText = ""
      } label: {
        Image(systemName: "magnifyingglass")
          .foregroundColor(searchText.isEmpty ? .gray : .blue)
      }
      .disabled(searchText.isEmpty)
      
      TextField("enter city name", text: $searchText, onCommit: {
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
    .clipShape(Capsule())
    .padding(.horizontal, 10)
    .shadow(radius: 1)
  }
  
  
  // MARK: - loadCities()
  private func loadCities(term: String, limit: Int) {
    guard !term.isEmpty else { return }
    dataSource.loadCities(by: term, limit: limit)
    showSearchResult.toggle()
  }
  
  // MARK: - Apologize View
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



