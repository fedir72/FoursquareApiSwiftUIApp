//
//  PlaceDetailView.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 24.09.25.
//

import SwiftUI
import RealmSwift
import MapKit

struct MapPinActionsView: View {
    // MARK: - Properties
    @Environment(\.realm) var realm
    @ObservedRealmObject var place: RealmPlace
    let isUserPosition: Bool
    let city: RealmCity
    let onClose: () -> Void

    // Computed property для проверки, добавлено ли место
    private var alreadySaved: Bool {
        city.places.contains(where: { $0._id == place._id })
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(place.name)
                .font(.headline)
            Text(place.categoryName ?? "Category not found")
                .font(.subheadline)
                .foregroundColor(.secondary)

            if isUserPosition {
                Button {
                    openInMaps()
                } label: {
                    Label("Open in Maps", systemImage: "map")
                        .font(.callout.bold())
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }

            // Кнопка добавления в favorites с анимацией
            Button(action: addPlaceToFavorites) {
                Text(alreadySaved ? "Place already added" : "Add to Favorites")
                    .bold()
                    .font(.callout)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(alreadySaved ? Color.gray : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .animation(.easeInOut(duration: 0.25), value: alreadySaved)
            }
            .disabled(alreadySaved)

            Button(action: onClose) {
                Label("Close", systemImage: "xmark.circle")
                    .font(.callout.bold())
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding()
    }

    // MARK: - Functions
    private func openInMaps() {
        let coordinate = CLLocationCoordinate2D(latitude: place.lat, longitude: place.lon)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = place.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }

    private func addPlaceToFavorites() {
        guard !alreadySaved else { return }
        do {
            try realm.write {
                city.places.append(place)
            }
        } catch {
            print("❌ Error adding place: \(error.localizedDescription)")
        }
    }
}
