import SwiftUI

struct EventCard: View {
    let event: Event
    let showTicketData: Bool?
    let showEditButton: Bool?
    
    init(showTicketData: Bool = true, showEditButton: Bool = false, event: Event) {
        self.showTicketData = showTicketData
        self.showEditButton = showEditButton
        self.event = event
    }
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd\nMMM"
        return dateFormatter.string(from: event.dateTime)
    }
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: event.image ?? "")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else if phase.error != nil {
                    Color.red
                } else {
                    Color.gray
                }
            }
            
            
            Color.black.opacity(0.60)
            
            if showTicketData == true {
                VStack {
                    HStack {
                        Image(systemName: "ticket")
                            .foregroundStyle(.white)
                        Text("Tickets Available")
                            .font(.system(size: 14))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(20)
            }
            
            if showTicketData == true {
                VStack(alignment: .trailing) {
                    Text("80%")
                        .font(.system(size: 26))
                        .fontWeight(.bold)
                    Text("Tickets Booked")
                        .font(.system(size: 14))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(17)
            }
            
            if showTicketData == false && showEditButton == true && Date() < event.dateTime {
                VStack(alignment: .trailing) {
                    NavigationLink {
                        EditEventView(eventId: event.id)
                    } label: {
                        Image(systemName: "pencil")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                    }
                    .buttonStyle(CircularButtonStyle(
                        size: 35,
                        backgroundColor: .clear,
                        foregroundColor: .white,
                        borderColor: .white,
                        borderWidth: 1
                    ))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(17)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(event.title.capitalized)
                    .font(.system(size: 26))
                    .fontWeight(.medium)
                    .frame(maxWidth: 150, alignment: .leading)
                    .lineLimit(2)
                    .truncationMode(.tail)
                HStack {
                    Image(systemName: "mappin.circle")
                        .foregroundStyle(.white)
                    Text(event.location)
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.7))
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(20)
            
            // Bottom Right Corner
            VStack(alignment: .trailing) {
                Text(formattedDate)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(14)
                    .background(Circle().fill(Color.accent))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 13))
        }
        .frame(height: 230)
        .clipShape(RoundedRectangle(cornerRadius: 35))
    }
}
//
//#Preview {
//    EventCard(imageUrl: URL(string: "https://plus.unsplash.com/premium_photo-1686783007953-4fcb40669dd8?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDV8fGV2ZW50c3xlbnwwfHwwfHx8MA%3D%3D")!)
//}
