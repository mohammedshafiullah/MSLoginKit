
//
//  SignupView.swift
//  MSLoginKit
//
//  Created by mohammed Shafiullah on 05/10/25.
//
import SwiftUI
public struct SignupView: View {
    @Binding public var isSignedUp: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var phoneNumber = ""
    @State private var dateOfBirth = Date()
    @State private var showDatePicker = false
    @State private var dateOfBirthSet = false
    @State private var showInvalidEmailAlert = false

    public init(isSignedUp: Binding<Bool>) {
        self._isSignedUp = isSignedUp
    }
    @FocusState private var focusedField: Field?
    enum Field {
        case phone, email, password
    }
    public var body: some View {
        ZStack {
            // 🌈 Gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                // 🔹 SECTION 1 — Account Details
                 VStack(spacing: 16) {
                HStack {
                    Text("Email")
                        .foregroundColor(.black)
                    Text("*")
                        .foregroundColor(.red).bold()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 4)
                // 📧 Email
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .modifier(CustomInputStyle())
                    .onSubmit {
                            validateEmail()
                        }
                        .onChange(of: email) { _ in
                            // Optional live validation (if you want)
                            if !email.isEmpty && !isValidEmail {
                                // You can show inline hints instead of alerts here if preferred
                            }
                        }

                HStack {
                    Text("Password")
                        .foregroundColor(.black)
                    Text("*")
                        .foregroundColor(.red).bold()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 4)
                // 🔒 Password
                SecureField("Password", text: $password)
                    .textContentType(.newPassword)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .modifier(CustomInputStyle())

                // ✅ Confirm Password
                SecureField("Confirm Password", text: $confirmPassword)
                    .textContentType(.newPassword)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .modifier(CustomInputStyle())
                   }
                     .padding()
                     .background(Color.white.opacity(0.15))
                     .cornerRadius(15)
                     .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 3)
                VStack(spacing: 16) {
                // 📞 Phone Number
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                        .modifier(CustomInputStyle())
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                                    to: nil, from: nil, for: nil)
                                }
                            }
                        }
                    VStack(alignment: .leading, spacing: 0) {
                        if dateOfBirthSet {
                            Text("")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                                .padding(.leading, 4)
                                .transition(.opacity)
                        }
                        
                        Button(action: {
                            showDatePicker.toggle()
                        }) {
                            HStack {
                                Text(dateOfBirthSet ? formattedDate : "Date of Birth")
                                    .foregroundColor(dateOfBirthSet ? .black : .gray)
                                Spacer()
                                Image(systemName: "calendar")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 3)
                        }
                    }
                    .animation(.easeInOut, value: dateOfBirthSet)
                }
                    .padding()
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 3)
                        
                .sheet(isPresented: $showDatePicker) {
                    if #available(iOS 16.0, *) {
                        VStack {
                            DatePicker(
                                "Select your date of birth",
                                selection: $dateOfBirth,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .padding()
                            Button("Done") {
                                dateOfBirthSet = true
                                showDatePicker = false
                            }
                            .padding(.bottom)
                        }
                        .presentationDetents([.fraction(0.3)])
                    } else {
                        // Fallback on earlier versions
                    }
                }

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 5)
                        .multilineTextAlignment(.center)
                        .shadow(color: .white.opacity(0.5), radius: 2, x: 0, y: 1)
                }

                // 🔘 Sign-Up Button
                Button("Sign Up") {
                    signUp()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(colors: [.green.opacity(0.9), .mint.opacity(0.9)], startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
                .padding(.top, 10)
                
                if isSignedUp {
                    Text("✅ Account created successfully!")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                }
            }
            .alert("Invalid Email", isPresented: $showInvalidEmailAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter a valid email address before continuing.")
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 40)
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dateOfBirth)
    }
    

    private func signUp() {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }

        AuthService.shared.signup(
            email: email,
            password: password,
            phoneNumber: phoneNumber,
            dateOfBirth: dateOfBirth
        ) { result in
            switch result {
            case .success:
                errorMessage = ""
                isSignedUp = true
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
    
    private var isValidEmail: Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.com$"#
        return email.range(of: emailRegex, options: .regularExpression) != nil
    }
    private func validateEmail() {
        guard !email.isEmpty else { return }
        if !isValidEmail {
            showInvalidEmailAlert = true
        }
    }
}

// MARK: - Custom Input Field Modifier
struct CustomInputStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 3)
    }
}
#Preview {
    // Use a constant Binding for preview purposes
    SignupView(isSignedUp: .constant(false))
        .previewDevice("iPhone 15 Pro")
}
