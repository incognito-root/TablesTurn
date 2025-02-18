import SwiftUI

struct CustomDropdownView<T: Hashable>: View {
    let title: String
    let options: [T]
    @Binding var selection: T
    let displayText: (T) -> String

    var body: some View {
        Picker(title, selection: $selection) {
            ForEach(options, id: \.self) { option in
                Text(displayText(option))
                    .tag(option)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .tint(.white)
        .background(Color.clear)
    }
}
