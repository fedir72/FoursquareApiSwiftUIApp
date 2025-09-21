# FoursquareApiSwiftUIApp

[![Swift](https://img.shields.io/badge/Swift-5.9-orange?logo=swift)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-17-blue?logo=apple)](https://developer.apple.com/ios/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-yes-brightgreen?logo=swift)](https://developer.apple.com/xcode/swiftui/)
[![Realm](https://img.shields.io/badge/Realm-Database-blueviolet)](https://realm.io/)
[![Foursquare API](https://img.shields.io/badge/Foursquare-API-lightgrey)](https://developer.foursquare.com/)
[![OpenWeatherMap](https://img.shields.io/badge/OpenWeatherMap-API-lightblue)](https://openweathermap.org/api)
[![Moya](https://img.shields.io/badge/Moya-Networking-lightgrey)](https://github.com/Moya/Moya)
[![SDWebImageSwiftUI](https://img.shields.io/badge/SDWebImage-SwiftUI-lightblue)](https://github.com/SDWebImage/SDWebImageSwiftUI)

---

## 📱 Project Description

**FoursquareApiSwiftUIApp** is a modern **SwiftUI** application for exploring points of interest (restaurants, museums, cafes, etc.) in cities worldwide.  
The app uses the **Foursquare API** for places, **OpenWeatherMap API** for city search, **CoreLocation** for current location, and **MapKit** for displaying places on a map.  
It features local data storage with **Realm**, a full network layer with **Moya**, and asynchronous image loading via **SDWebImage SwiftUI**.

---

## 🛠 Technologies & Libraries

- **SwiftUI** — declarative UI framework  
- **Foursquare API** — places data (categories, photos, addresses)  
- **OpenWeatherMap API** — city search and weather integration  
- **CoreLocation** — access to user's current location  
- **MapKit** — map view with custom annotations  
- **Realm Swift** — persistent local database  
- **Moya** — network abstraction layer for API requests  
- **SDWebImage SwiftUI** — asynchronous image loading and caching  

---

## ✨ Key Features

- **City Search** via OpenWeatherMap API  
- **Browse Places** with photos, categories, and formatted addresses  
- **Favorites Management**: save or remove cities and associated places using Realm  
- **Custom Map Annotations**: show places with different colored markers  
- **Fullscreen Photo Carousel** for place images  
- **Adaptive Photo Grid**: dynamically adjust number of columns  
- **User Tips** for each place  
- **Current Location Support**  
- **Asynchronous Image Loading** with SDWebImage SwiftUI  
- **Network Layer via Moya**  

---

## 💻 Code Highlights

- **DetailPlaceView**: clean separation of logic for adding/removing favorites (`addPlace` and `removePlace`)  
- **Realm Models**: `RealmPlace` and `RealmCity` with initializers from API models  
- **StartListView**: organized using extensions — separating UI view-building functions from business logic  
- **Dynamic Grid Layout**: calculates item width automatically based on screen size and column count  
- **NavigationStack + Path**: smooth navigation through cities and their places  
- **Custom Search Bar**: includes clear button, search-on-submit, and animated show/hide  
- **Asynchronous Data Loading**: fetch photos and tips efficiently using `.task` modifier  

---

## ⚡️ Future Improvements

- Improve **UI/UX** and animations  
- Add filtering and sorting options for places  
- Integrate weather information from OpenWeatherMap  
- Enhance offline support using Realm  
- Implement detailed place pages with full photo galleries and user reviews  
- Add unit tests and UI tests for key features  

---

## 📜 License

This project is released under the **MIT License**.  

**MIT License** allows you to:  
- Use, copy, modify, merge, publish, distribute, sublicense, and sell copies of the software  
- Include the original copyright notice and license in all copies or substantial portions  

**Disclaimer**: The software is provided “as is”, without warranty of any kind.
