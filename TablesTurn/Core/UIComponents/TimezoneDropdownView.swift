import SwiftUI

struct TimezoneDropdownView: View {
    @State private var selectedTimezone: String = TimeZone.current.identifier
    
    var body: some View {
        Picker("Event Timezone", selection: $selectedTimezone) {
            ForEach(TimeZone.knownTimeZoneIdentifiers, id: \.self) { identifier in
                Text(identifier)
                    .tag(identifier)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .tint(.white)
        .frame(maxWidth: .infinity)
        .background(Color.clear)
    }
}

struct TimezoneDropdownView_Previews: PreviewProvider {
    static var previews: some View {
        TimezoneDropdownView()
    }
}
