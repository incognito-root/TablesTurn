//import SwiftUI
//
//struct TimezoneDropdownView: View {
//    @ObservedObject var viewModel: AddEventViewModel
//
//    // Customize your list of offsets as needed.
//    let utcOffsets: [String] = [
//        "UTC-12", "UTC-11", "UTC-10", "UTC-9", "UTC-8", "UTC-7",
//        "UTC-6", "UTC-5", "UTC-4", "UTC-3", "UTC-2", "UTC-1",
//        "UTC+0", "UTC+1", "UTC+2", "UTC+3", "UTC+4", "UTC+5",
//        "UTC+6", "UTC+7", "UTC+8", "UTC+9", "UTC+10", "UTC+11",
//        "UTC+12", "UTC+13", "UTC+14"
//    ]
//    
//    var body: some View {
//        Picker("Event Timezone", selection: $viewModel.timezone) {
//            ForEach(utcOffsets, id: \.self) { offset in
//                Text(offset)
//                    .tag(offset)
//            }
//        }
//        .pickerStyle(MenuPickerStyle())
//        .tint(.white)
//        .frame(maxWidth: .infinity)
//        .background(Color.clear)
//    }
//}
//
////struct TimezoneDropdownView_Previews: PreviewProvider {
////    static var previews: some View {
////        TimezoneDropdownView()
////    }
////}
