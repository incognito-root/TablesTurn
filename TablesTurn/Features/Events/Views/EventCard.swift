import SwiftUI

struct EventCard: View {
    let imageUrl: URL
    
    var body: some View {
        ZStack {
            AsyncImage(url: imageUrl) { phase in
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
            
            VStack {
                HStack {
                    Image(systemName: "ticket")
                        .foregroundColor(.white)
                    Text("Tickets Available")
                        .font(.system(size: 14))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(20)
            
            VStack(alignment: .trailing) {
                Text("80%")
                    .font(.system(size: 26))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text("Tickets Booked")
                    .font(.system(size: 14))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(17)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Dinner")
                    .font(.system(size: 26))
                    .fontWeight(.medium)
                HStack {
                    Image(systemName: "mappin.circle")
                        .foregroundColor(.white)
                    Text("Jakarta Hall")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
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
                Text("18\nOCT")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.black)
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

#Preview {
    EventCard(imageUrl: URL(string: "https://plus.unsplash.com/premium_photo-1686783007953-4fcb40669dd8?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDV8fGV2ZW50c3xlbnwwfHwwfHx8MA%3D%3D")!)
}
