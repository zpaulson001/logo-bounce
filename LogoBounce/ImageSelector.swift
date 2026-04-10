//
//  ImageManager.swift
//  Logo Bounce
//
//  Created by Zac Paulson on 4/7/26.
//

import SwiftUI

struct ImageSelector: View {
    @Binding var selection: String
    @Environment(ImageStore.self) var imageStore
    @Environment(MainToolbarSettings.self) private var toolbarSettings

    func handleImageTap(name: String) {
        if name != selection {
            selection = name
        }
    }

    let itemsPerRow = 3

    var body: some View {
        VStack {
            HStack {
                Text("Select Logo")
                Spacer()
                FilePicker()
                Button(action: {
                    toolbarSettings.isLogoManageMode.toggle()
                }) {
                    Image(systemName: "square.and.pencil")
                }
                .disabled(imageStore.filenames.isEmpty)
            }

            ScrollView {
                Grid {

                    if !imageStore.filenames.isEmpty {
                        ForEach(
                            imageStore.filenames.chunked(into: itemsPerRow),
                            id: \.self
                        ) {
                            rows in
                            GridRow {
                                ForEach(rows, id: \.self) { fileName in
                                    ImageSelectorPreview(
                                        fileName: fileName,
                                        isSelected: fileName == selection
                                    )
                                    .onTapGesture {
                                        handleImageTap(name: fileName)
                                    }
                                }
                            }
                        }
                    } else {
                        Text("No saved logos. Use the '+' button to add one.")
                    }
                }
            }
            .scrollIndicators(.visible)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 250)
            .background(.ultraThinMaterial)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 10,
                    style: .continuous
                )
            )
        }

    }
}

struct ImageSelectorPreview: View {
    let fileName: String
    let isSelected: Bool
    @State private var isHovering = false
    @Environment(ImageStore.self) var imageStore

    var body: some View {
        if isSelected {
            ZStack(alignment: .topTrailing) {
                Image(
                    nsImage: imageStore.getFile(named: fileName)
                )
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 64, height: 64)
                //                                    .border(Color.red, width: 1)

            }
            .padding(8)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.accentColor, lineWidth: 3)

            }
            .contentShape(RoundedRectangle(cornerRadius: 8))

        } else {
            ZStack(alignment: .topTrailing) {
                Image(
                    nsImage: imageStore.getFile(named: fileName)
                )
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 64, height: 64)
                //                                    .border(Color.red, width: 1)

            }
            .padding(8)
            .contentShape(RoundedRectangle(cornerRadius: 8))
        }
    }

}

// Separate view to keep the code clean
struct DeleteBadge: View {
    var body: some View {
        Button {
            // Your delete logic here
            print("Delete triggered")
        } label: {
            Image(systemName: "xmark.circle.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .red)
                .font(.system(size: 22))
                .shadow(radius: 2)  // Helps it pop against busy images
        }
        .buttonStyle(.plain)
        .offset(x: 8, y: -8)  // "Float" it on the corner
    }
}

//#Preview {
//    ImageManager()
//}
