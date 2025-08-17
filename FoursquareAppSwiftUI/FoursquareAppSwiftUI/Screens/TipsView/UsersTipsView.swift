//
//  UsersTipsView.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 22.12.2022.
//

import SwiftUI

struct UsersTipsView: View {
  @Environment(\.dismiss) var dismiss
  @State var tips: Tips

    var body: some View {
        VStack {
            HStack {
                Text("Customers tips")
                .font(.title.bold())
                Spacer()
                Button {
                  dismiss()
                } label: {
                    Image(systemName:"xmark.circle")
                        .font(.title)
                        .foregroundColor(.red)
                }
                .padding(.trailing, 10)

            }
            .padding(.all,15)
            List {
                    ForEach(tips, id: \.id) {  tip in
                        VStack(alignment: .leading) {
                            Text(tip.dateText())
                                .font(.title3)
                                .foregroundColor(Color(UIColor.systemRed.cgColor))
                            Text(tip.text ?? "tip is not awailable")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                    }
                }
        }
    }
}

struct UsersTipsView_Previews: PreviewProvider {
    static var previews: some View {
        UsersTipsView(tips: [FoursquareAppSwiftUI.Tip(id: Optional("621e3df0ced9bf23b45c009e"), created_at: Optional("2022-03-01T15:38:24.000Z"), text: Optional("Delicious tapas, friendly staff, i recommand")), FoursquareAppSwiftUI.Tip(id: Optional("5f0a2543cc0fe13148700d53"), created_at: Optional("2020-07-11T20:46:59.000Z"), text: Optional("Everything is good here, homemade food, desserts, attention and familiarity are priceless, every time I am in the area, I come to drink and eat something!")), FoursquareAppSwiftUI.Tip(id: Optional("6033642f41a4b52a4a850102"), created_at: Optional("2021-02-22T07:58:39.000Z"), text: Optional("Los entrantes, las tapas y la carne esta fabulosa..!! Y además no es caro como pone la descripción..")), FoursquareAppSwiftUI.Tip(id: Optional("602f83ed937a5c33017b2f90"), created_at: Optional("2021-02-19T09:25:01.000Z"), text: Optional("El Puente.! Es un valor seguro en el que siempre y digo siempre puedes confiar. Nunca me han fallado y todas las personas que he llevado han repetido. \"Un 10 por la relación Calidad/Precio\".")), FoursquareAppSwiftUI.Tip(id: Optional("5f36b4054ec5da606b6d3edd"), created_at: Optional("2020-08-14T15:55:49.000Z"), text: Optional("La comida ,el ambiente , la atención y la calidad del producto recomendado 100%")), FoursquareAppSwiftUI.Tip(id: Optional("5f36b3c7346aa55e6f3d902b"), created_at: Optional("2020-08-14T15:54:47.000Z"), text: Optional("Lo bueno del Restaurante El Puente es su atención ,el ambiente familiar y su comida casera ,todo muy fresco y de calidad lo recomiendo")), FoursquareAppSwiftUI.Tip(id: Optional("5d7e4c2343116c0006b4f48b"), created_at: Optional("2019-09-15T14:35:15.000Z"), text: Optional("La atención y la limpieza, ambiente familiar y relajado, comida, café y postres excelente! Si estás en Adeje, no dejes de ir!"))])
    }
}
