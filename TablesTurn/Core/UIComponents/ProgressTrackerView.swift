import SwiftUI

struct ProgressTrackerView: View {
    let steps = ["Intro", "Details", "Publish"]
    
    @StateObject private var viewModel = AddEventViewModel()
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(0..<steps.count, id: \.self) { index in
                HStack (spacing: 0) {
                    if index != 0 {
                        Rectangle()
                            .fill(index <= viewModel.currentStep ? Color.orange : Color.gray)
                            .frame(height: 4)
                            .frame(width: .infinity)
                            .padding(.bottom, 20)
                            .offset(x: 2)
                    }
                    
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 36, height: 36)
                            
                            if index == viewModel.currentStep {
                                Circle()
                                    .fill(.tertiaryBackground)
                                    .stroke(Color.orange, lineWidth: 3)
                                    .frame(width: 60, height: 60)
                            }
                            
                            if index < viewModel.currentStep {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.primaryBackground)
                                    .fontWeight(.bold)
                            } else {
                                Text("\(index + 1)")
                                    .foregroundColor(index == viewModel.currentStep ? .white : .black)
                                    .font(.system(size: index == viewModel.currentStep ? 30 : 16))
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(width: .infinity)
                        
                        Text(steps[index])
                            .foregroundColor(.white)
                            .font(.caption)
                    }
                    .frame(maxHeight: .infinity)
                }
            }
        }
    }
}

struct ProgressTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressTrackerView()
    }
}
