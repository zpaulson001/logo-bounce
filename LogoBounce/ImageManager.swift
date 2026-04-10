//
//  ImageManager.swift
//  Logo Bounce
//
//  Created by Zac Paulson on 4/7/26.
//

import SwiftUI

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

struct ImageManager: View {
    @Environment(ImageStore.self) var imageStore
    @Environment(MainToolbarSettings.self) private var toolbarSettings
    @State private var selectedImages: Set<String> = []

    func handleImageTap(name: String, selectMultiple: Bool = false) {
        if selectedImages.contains(name) {
            selectedImages.remove(name)
            return
        }

        if selectMultiple {
            selectedImages.insert(name)
        } else {
            selectedImages.removeAll()
            selectedImages.insert(name)
        }
    }

    func handleImageDelete() {
        for fileName in selectedImages {
            imageStore.deleteFile(named: fileName)
            selectedImages.remove(fileName)
        }
    }

    let itemsPerRow = 3

    var body: some View {
        VStack {
            HStack {
                Text("Select Logo(s)")
                Spacer()
                Button("Done") {
                    toolbarSettings.isLogoManageMode.toggle()
                }
                Button(action: {
                    handleImageDelete()
                }) {
                    Image(systemName: "trash.fill")
                }
                .disabled(selectedImages.isEmpty)
            }

            ScrollView {
                Grid {
                    ForEach(
                        imageStore.filenames.chunked(into: itemsPerRow),
                        id: \.self
                    ) {
                        rows in
                        GridRow {
                            ForEach(rows, id: \.self) { fileName in
                                ImageManagerPreview(
                                    fileName: fileName,
                                    isSelected: selectedImages.contains(fileName)
                                )
                                .onTapGesture {
                                    let isShifted = NSEvent.modifierFlags.contains(
                                        .shift
                                    )
                                    let isCommanded = NSEvent.modifierFlags
                                        .contains(
                                            .command
                                        )

                                    handleImageTap(
                                        name: fileName,
                                        selectMultiple: isCommanded || isShifted
                                    )

                                }
                            }
                        }
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

struct ImageManagerPreview: View {
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
                    .stroke(Color.accentColor, lineWidth: 3)

            }
            .contentShape(RoundedRectangle(cornerRadius: 8))
            //            .overlay(alignment: .topTrailing) {
            //                ImageSelectBadge(isSelected: isSelected)
            //            }

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
            //            .overlay(alignment: .topTrailing) {
            //                ImageSelectBadge(isSelected: isSelected)
            //            }
        }
    }

}

// Separate view to keep the code clean
struct ImageSelectBadge: View {
    let isSelected: Bool

    var body: some View {

        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
            .symbolRenderingMode(.palette)
            .foregroundStyle(isSelected ? .white : .secondary)
            .background(
                Circle().fill(
                    isSelected ? Color.accentColor : Color.black.opacity(0.3)
                )
            )
            .font(.system(size: 22))
            .offset(x: 8, y: -8)  // "Float" it on the corner
    }
}

//#Preview {
//    ImageManager()
//}
