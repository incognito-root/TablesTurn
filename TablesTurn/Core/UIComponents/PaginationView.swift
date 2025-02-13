//
//  PaginationView.swift
//  TablesTurn
//
//  Created by Ayaan Ali on 14/02/2025.
//

import SwiftUI

struct PaginationView: View {
    @Binding var currentPage: Int
    let totalPages: Int
    
    var body: some View {
        HStack {
            Button {
                if currentPage > 1 {
                    currentPage -= 1
                }
            } label: {
                Image(systemName: "chevron.left")
            }
            .disabled(currentPage <= 1)
            
            Text("Page \(currentPage) of \(totalPages)")
                .font(.caption)
            
            Button {
                if currentPage < totalPages {
                    currentPage += 1
                }
            } label: {
                Image(systemName: "chevron.right")
            }
            .disabled(currentPage >= totalPages)
        }
        .buttonStyle(.bordered)
    }
}

//#Preview {
//    PaginationView(currentPage: 1, totalPages: 5)
//}
