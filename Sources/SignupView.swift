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
    @State private var showInvalidPasswordAlert: Bool = false
    @State private var showInvalidPhoneNumberAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var signUpAlertMessage: Bool = false
    @FocusState private var focusedField: Field?

    enum Field {
        case email
        case password
        case confirmPassword
        case phone
    }

    public init(isSignedUp: Binding<Bool>) {
        self._isSignedUp = isSignedUp
    }

    public var body: some View {
        ZStack {
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

                // MARK: 📧 EMAIL
                VStack(spacing: 16) {
                    HStack {
                        Text("Email").foregroundColor(.black)
                        Text("*").foregroundColor(.red).bold()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 4)
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .modifier(CustomInputStyle())
                        .onSubmit {
                            validateEmail()
                        }
                }
                .alert("Invalid Email", isPresented: $showInvalidEmailAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("Please enter a valid email address before continuing.")
                }
                // MARK: 🔐 PASSWORD
                VStack(spacing: 16) {
                    HStack {
                        Text("Password").foregroundColor(.black)
                        Text("*").foregroundColor(.red).bold()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 4)

                    SecureField("Password", text: $password)
                                       .textContentType(.newPassword)
                                       .disableAutocorrection(true)
                                       .autocapitalization(.none)
                                       .modifier(CustomInputStyle())
                                       .focused($focusedField, equals: .password)
                                        .onSubmit {
                                        focusedField = .confirmPassword
                                          }

                                   // ✅ Confirm Password
                                   SecureField("Confirm Password", text: $confirmPassword)
                                       .textContentType(.newPassword)
                                       .disableAutocorrection(true)
                                       .autocapitalization(.none)
                                       .modifier(CustomInputStyle())
                                       .focused($focusedField, equals: .confirmPassword)
                                        .onSubmit {
                                            validatePassword()
                                        }
                                      }
                                        .padding()
                                        .background(Color.white.opacity(0.15))
                                        .cornerRadius(15)
                                        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 3)
                .alert(isPresented: $showInvalidPasswordAlert) {
                    Alert(title: Text("Password Validation"),
                          message: Text(alertMessage),
                          dismissButton: .default(Text("OK")))
                }

                // 📞 PHONE NUMBER (Toolbar Done ONLY here)
                TextField("Phone Number", text: $phoneNumber)
                    .keyboardType(.phonePad)
                    .modifier(CustomInputStyle())
                    .focused($focusedField, equals: .phone)
                    .onSubmit {
                        validatePhoneNumber()
                    }
                    VStack(alignment: .leading, spacing: 0) {
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
                }
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top, 5)
                    .multilineTextAlignment(.center)
            }

                Button("Sign Up") {
                    signUp()
                        
                }
                .alert("Success", isPresented: $signUpAlertMessage, actions: { Button("OK") { }},
               message: { Text("Your account has been created successfully.") })
                
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(colors: [.green.opacity(0.9), .mint.opacity(0.9)], startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
                
            }
            .padding()
            // 👇 Toolbar is conditionally shown only when phone field is active
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    if focusedField == .phone {
                        Button("Done") {
                            focusedField = nil
                            validatePhoneNumber()
                        }
                    }
                }
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
    
    private func signUp() {
        guard password == confirmPassword, showInvalidEmailAlert == false , showInvalidPasswordAlert == false ,showInvalidPhoneNumberAlert == false else {
            // Check which condition failed (optional)
            if password != confirmPassword {
                if !errorMessage.contains("Passwords do not match") {
                    errorMessage += "\nPasswords do not match"
                }
                signUpAlertMessage = true
            }
            if showInvalidEmailAlert {
                if !errorMessage.contains("Email is invalid") {
                    errorMessage += "\nEmail is invalid"
                }
                signUpAlertMessage = true
            }
            if showInvalidPasswordAlert {
                if !errorMessage.contains("Password is invalid") {
                    errorMessage += "\nPassword is invalid"
                }
                signUpAlertMessage = true
            }
            if showInvalidPhoneNumberAlert {
                if !errorMessage.contains("Phone number is invalid") {
                    errorMessage += "\nPhone number is invalid"
                }
                signUpAlertMessage = true
            }
            return
        }

        AuthService.shared.signup(
            email: email,
            password: password,
            phoneNumber: phoneNumber,
            dateOfBirth: dateOfBirth
        ) { result in
            DispatchQueue.main.async { // Ensure UI updates on main thread
                switch result {
                case .success(let user): // <- capture the FirebaseAuth.User
                    print("User created:", user.uid)
                    AfterAccountSuccessfullyCreation()
                case .failure(let error):
                    errorMessage = error.localizedDescription
                    signUpAlertMessage = true
                }
            }
        }
      }
    
    private func  AfterAccountSuccessfullyCreation() {
        errorMessage = "Account created successfully!"
        isSignedUp = true
        signUpAlertMessage = true
        email = ""
        password = ""
        confirmPassword = ""
        phoneNumber = ""
        dateOfBirth = Date()
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dateOfBirth)
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

    private func validatePassword() {
        // Check for empty fields
        guard !password.isEmpty && !confirmPassword.isEmpty else {
            alertMessage = "Password fields cannot be empty."
            showInvalidPasswordAlert = true
            return
        }

        // Regex for industry-standard password rules
        let regex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>_\\-]).{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)

        // Validate password complexity
        guard predicate.evaluate(with: password) else {
            alertMessage = """
            Password must:
            • Be at least 8 characters
            • Contain 1 uppercase letter
            • Contain 1 lowercase letter
            • Contain 1 number
            • Contain 1 special character
            """
            showInvalidPasswordAlert = true
            return
        }

        // Check if password and confirm password match
        guard password == confirmPassword else {
            alertMessage = "Passwords do not match."
            showInvalidPasswordAlert = true
            return
        }
    }
    
    private func validatePhoneNumber() {
        // Remove spaces or special characters
        let trimmedPhone = phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Regex: 10 digits only
        let phoneRegex = "^[6-9]\\d{9}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        guard predicate.evaluate(with: trimmedPhone) else {
            errorMessage = "Please enter a valid 10-digit phone number."
            showInvalidPhoneNumberAlert = true
            return
        }
        
        // ✅ Phone number is valid
        errorMessage = "" // clear any previous error
    }

}






