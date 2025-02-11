import SwiftUI

struct AddEventView: View {
    let radius: CGFloat = 50
    
    @StateObject private var viewModel = AddEventViewModel()
    
    @State private var date = Date()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(.white)]
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor(.accentColor),
            .font: UIFont.systemFont(ofSize: 24, weight: .semibold)
        ]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.secondaryBackground, .accentColor]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ZStack(alignment: .topLeading) {
                    Color.primaryBackground
                        .ignoresSafeArea()
                        .padding(.bottom, radius)
                        .cornerRadius(radius)
                        .padding(.bottom, -radius)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
                            Spacer()
                            ProgressTrackerView(viewModel: viewModel)
                            Spacer()
                        }
                        .padding(.top, 10)
                        .frame(height: 150)
                        
                        VStack(spacing: 0) {
                            if viewModel.currentStep == 0 {
                                Text("Basic Details")
                                    .font(.system(size: 35))
                                    .fontWeight(.medium)
                                    .padding(EdgeInsets(top: 20, leading: 25, bottom: 0, trailing: 25))
                                
                                Form {
                                    Section {
                                        VStack(alignment: .leading, spacing: 0) {
                                            Text("Event Title/Headline")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                                .padding(.leading, 4)
                                            
                                            CustomTextField(
                                                placeholder: "Title",
                                                text: $viewModel.title,
                                                keyboardType: .emailAddress,
                                                borderRadius: 0,
                                                paddingValue: 10,
                                                borderColor: .gray,
                                                borderEdges: [.bottom],
                                                borderWidth: 1,
                                                validation: { input in
                                                    if input.isEmpty {
                                                        return "Email cannot be empty."
                                                    }
                                                    return nil
                                                }
                                            )
                                        }
                                        .listRowBackground(Color.clear)
                                        .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
                                    }
                                    
                                    Section {
                                        VStack(alignment: .leading) {
                                            DatePicker(
                                                "Event Date",
                                                selection: $viewModel.date,
                                                in: viewModel.minDate...,
                                                displayedComponents: [.date]
                                            )
                                            
                                        }
                                        .listRowBackground(Color.clear)
                                        .listRowInsets(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
                                    }
                                    
                                    Section {
                                        VStack(alignment: .leading) {
                                            DatePicker(
                                                "Event Time",
                                                selection: $viewModel.time,
                                                in: viewModel.minDate...,
                                                displayedComponents: [.hourAndMinute]
                                            )
                                        }
                                        .listRowBackground(Color.clear)
                                        .listRowInsets(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
                                    }
                                    
                                    Section {
                                        Button(action: {
                                            viewModel.changeStep()
                                        }) {
                                            Text("Next".uppercased())
                                        }
                                        .buttonStyle(MainButtonStyle())
                                        .listRowBackground(Color.clear)
                                        .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
                                    }
                                }
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                                .environment(\.colorScheme, .dark)
                            }
                            else if viewModel.currentStep == 1 {
                                Text("More Details")
                                    .font(.system(size: 35))
                                    .fontWeight(.medium)
                                    .padding(EdgeInsets(top: 20, leading: 25, bottom: 0, trailing: 25))
                                
                                Form {
                                    Section {
                                        VStack(alignment: .leading) {
                                            ImagePickerView()
                                        }
                                        .frame(maxWidth: .infinity)
                                        .listRowBackground(Color.clear)
                                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

                                        VStack(alignment: .leading, spacing: 0) {
                                            Text("Event Description")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                                .padding(.leading, 4)
                                            
                                            CustomTextField(
                                                placeholder: "Description",
                                                text: $viewModel.description,
                                                keyboardType: .default,
                                                borderRadius: 0,
                                                paddingValue: 10,
                                                borderColor: .gray,
                                                borderEdges: [.bottom],
                                                borderWidth: 1,
                                                validation: { input in
                                                    if input.isEmpty {
                                                        return "Description cannot be empty."
                                                    }
                                                    return nil
                                                }
                                            )
                                        }
                                        .listRowBackground(Color.clear)
                                        .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 15, trailing: 5))

                                        VStack(alignment: .leading, spacing: 0) {
                                            Text("Event Location")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                                .padding(.leading, 4)
                                            
                                            CustomTextField(
                                                placeholder: "Location",
                                                text: $viewModel.location,
                                                keyboardType: .default,
                                                borderRadius: 0,
                                                paddingValue: 10,
                                                borderColor: .gray,
                                                borderEdges: [.bottom],
                                                borderWidth: 1,
                                                validation: { input in
                                                    if input.isEmpty {
                                                        return "Description cannot be empty."
                                                    }
                                                    return nil
                                                }
                                            )
                                        }
                                        .listRowBackground(Color.clear)
                                        .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 25, trailing: 5))

                                        VStack(alignment: .leading, spacing: 0) {
                                            TimezoneDropdownView()
                                        }
                                        .listRowBackground(Color.clear)
                                        .listRowInsets(EdgeInsets(top: 5, leading: 10, bottom: 25, trailing: 10))
                                        .listRowSeparator(.hidden)

                                        VStack(alignment: .leading) {
                                            DatePicker(
                                                "RSVP Deadline",
                                                selection: $viewModel.rsvpDeadlineDate,
                                                in: viewModel.minDate...,
                                                displayedComponents: [.date]
                                            )
                                            .foregroundStyle(Color.white)
                                        }
                                        .listRowBackground(Color.clear)
                                        .listRowInsets(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
                                        .environment(\.colorScheme, .dark)
                                    }
                                    
                                    Section {
                                        Button(action: {
                                            viewModel.changeStep()
                                        }) {
                                            Text("Next".uppercased())
                                        }
                                        .buttonStyle(MainButtonStyle())
                                        .listRowBackground(Color.clear)
                                        .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
                                    }
                                }
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                            }
                        }
                        .padding(.top, -30)
                    }
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                }
                .padding(.top, 20)
            }
            .foregroundStyle(.primaryText)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Craft Event")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    AddEventView()
}
