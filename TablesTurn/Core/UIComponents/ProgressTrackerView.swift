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
                            .frame(width: 80)
                            .padding(.bottom, 20)
                    }
                    
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 50, height: 50)
                            
                            if index == viewModel.currentStep {
                                Circle()
                                    .fill(.tertiaryBackground)
                                    .stroke(Color.orange, lineWidth: 3)
                                    .frame(width: 65, height: 65)
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
