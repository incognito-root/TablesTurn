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
            
            Color.black.opacity(0.50)
            
            VStack(alignment: .leading) {
                Text("Event Title")
                    .font(.title)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 2)
                
                Spacer()
                
                Text("Event Date")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 2)
            }
            .padding()
        }
        .frame(width: .infinity, height: 230)
        .clipShape(RoundedRectangle(cornerRadius: 35))
        .shadow(radius: 5)
    }
}

#Preview {
    EventCard(imageUrl: URL(string: "https://plus.unsplash.com/premium_photo-1686783007953-4fcb40669dd8?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDV8fGV2ZW50c3xlbnwwfHwwfHx8MA%3D%3D")!)
}
