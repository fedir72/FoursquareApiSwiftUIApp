//
//  CustomSearchBar.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 22.09.25.
//
import SwiftUI


struct CustomSearchBar: View {
  
    @Binding var text: String
    var placeholder: String
    var onSearch: (() -> Void)? = nil

    var body: some View {
        HStack {
            Button {
                onSearch?()
            } label: {
                Image(systemName: "magnifyingglass")
            }
            .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .submitLabel(.search)
                .onSubmit { onSearch?() }

            if !text.isEmpty {
                Button(action: { text = "" }) {
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
}

