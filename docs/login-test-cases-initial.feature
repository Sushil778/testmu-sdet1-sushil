## Feature 1: Login with valid and invalid credentials

Feature: Login with valid and invalid credentials

  Scenario: Successful login with valid credentials
    Given the user has an active registered account
    And the user is on the login page
    When the user enters a valid username
    And the user enters the correct password
    And the user clicks the Login button
    Then the user should be authenticated successfully
    And the user should be redirected to the default authenticated page
    And an authenticated session should be created

  Scenario: Login with an invalid username and valid password
    Given the user is on the login page
    When the user enters an unregistered username
    And the user enters a valid account password
    And the user clicks the Login button
    Then the login should fail
    And an appropriate authentication error should be displayed
    And the user should remain unauthenticated

  Scenario: Login with a valid username and invalid password
    Given the user has an active registered account
    And the user is on the login page
    When the user enters the registered username
    And the user enters an incorrect password
    And the user clicks the Login button
    Then the login should fail
    And an appropriate authentication error should be displayed
    And the user should remain unauthenticated

  Scenario: Login with both invalid username and invalid password
    Given the user is on the login page
    When the user enters an unregistered username
    And the user enters an incorrect password
    And the user clicks the Login button
    Then the login should fail
    And an appropriate authentication error should be displayed
    And the user should remain unauthenticated

  Scenario: Login with empty username and password
    Given the user is on the login page
    When the user leaves the username field empty
    And the user leaves the password field empty
    And the user clicks the Login button
    Then the login should not be submitted successfully
    And required-field validation messages should be displayed
    And the user should remain on the login page

  Scenario: Login with an empty username
    Given the user is on the login page
    When the user leaves the username field empty
    And the user enters a valid password
    And the user clicks the Login button
    Then the login should be rejected
    And a username validation message should be displayed
    And the user should remain unauthenticated

  Scenario: Login with an empty password
    Given the user has an active registered account
    And the user is on the login page
    When the user enters the registered username
    And the user leaves the password field empty
    And the user clicks the Login button
    Then the login should be rejected
    And a password validation message should be displayed
    And the user should remain unauthenticated

  Scenario: Login with a password containing leading or trailing spaces
    Given the user has an active registered account
    And the user is on the login page
    When the user enters the registered username
    And the user enters the password with additional leading or trailing spaces
    And the user clicks the Login button
    Then the system should validate the password according to the defined password policy
    And the login result should match the stored password and documented whitespace-handling rules

  Scenario: Login with username using different letter casing
    Given the user has an active registered account
    And the user is on the login page
    When the user enters the registered username with different letter casing
    And the user enters the correct password
    And the user clicks the Login button
    Then the login result should follow the documented username case-sensitivity rules
    And the system should not authenticate an account that does not match those rules

  Scenario: Login with a password at the maximum supported length
    Given the user has an active registered account
    And the user is on the login page
    When the user enters the registered username
    And the user enters a valid password at the maximum supported length
    And the user clicks the Login button
    Then the system should process the password without truncation
    And the login should succeed if the password matches the registered account

  Scenario: Login with a password exceeding the maximum supported length
    Given the user is on the login page
    When the user enters a registered username
    And the user enters a password exceeding the supported maximum length
    And the user clicks the Login button
    Then the system should reject the input or handle it according to the documented input limits
    And the system should not authenticate the user using a silently truncated password

## Feature 2: Forgot-password workflow

 Feature: Forgot-password workflow

  Scenario: Open the forgot-password page
    Given the user is on the login page
    When the user clicks the Forgot Password link
    Then the forgot-password page should be displayed
    And an email input field should be available
    And an option to request a password reset should be available

  Scenario: Request password reset using a registered email address
    Given the user has an active account associated with a registered email address
    And the user is on the forgot-password page
    When the user enters the registered email address
    And the user submits the password reset request
    Then the system should accept the request
    And a password reset email should be sent according to the configured delivery process
    And a confirmation message should be displayed

  Scenario: Request password reset using an unregistered email address
    Given the user is on the forgot-password page
    When the user enters an email address that is not registered
    And the user submits the password reset request
    Then the system should display a generic confirmation message that does not reveal account existence
    And the system should not send a password reset link for an unregistered account

  Scenario: Request password reset with an empty email address
    Given the user is on the forgot-password page
    When the user leaves the email field empty
    And the user submits the password reset request
    Then the request should not be processed
    And a required-field validation message should be displayed

  Scenario: Request password reset with an invalid email format
    Given the user is on the forgot-password page
    When the user enters an invalid email address such as "user@"
    And the user submits the password reset request
    Then the request should be rejected
    And an email-format validation message should be displayed
    And no password reset email should be sent

  Scenario: Request password reset with an email containing boundary-length input
    Given the user is on the forgot-password page
    When the user enters an email address at the maximum supported length
    And the user submits the password reset request
    Then the system should validate the address according to the supported email length
    And the system should process the request only if the address is valid

  Scenario: Open a valid password reset link
    Given the user has received a valid password reset email
    When the user opens the password reset link before it expires
    Then the password reset page should be displayed
    And the system should allow the user to enter a new password

  Scenario: Reset password using an expired link
    Given the user has received a password reset link
    And the password reset link has expired
    When the user opens the expired reset link
    Then the system should reject the reset request
    And an appropriate expired-link message should be displayed
    And the user should be prompted to request a new reset link

  Scenario: Reset password using an already-used link
    Given the user has successfully reset the password using a reset link
    When the user opens the same reset link again
    Then the system should reject the reused link
    And the password should not be changed again through that link

  Scenario: Successfully reset the password
    Given the user has opened a valid password reset link
    When the user enters a new password that meets the password policy
    And the user confirms the same new password
    And the user submits the password reset form
    Then the password should be updated successfully
    And a password reset confirmation should be displayed
    And the user should be able to log in using the new password

  Scenario: Submit mismatched new password and confirmation
    Given the user has opened a valid password reset link
    When the user enters a valid new password
    And the user enters a different value in the confirmation field
    And the user submits the password reset form
    Then the password reset should be rejected
    And a password mismatch message should be displayed
    And the existing password should remain unchanged

  Scenario: Submit an empty new password
    Given the user has opened a valid password reset link
    When the user leaves the new password field empty
    And the user enters a value in the confirmation field
    And the user submits the password reset form
    Then the password reset should be rejected
    And a required-field validation message should be displayed
    And the existing password should remain unchanged

## Feature 3: Session expiry and protected-page access

Feature: Session expiry and protected-page access

  Scenario: Session remains valid before the inactivity timeout
    Given the user has logged in successfully
    And the configured inactivity timeout is 30 minutes
    When the user accesses an authenticated page before the timeout expires
    Then the system should allow access to the page
    And the user should remain authenticated

  Scenario: Session expires after the configured inactivity timeout
    Given the user has logged in successfully
    And the configured inactivity timeout is 30 minutes
    When the user remains inactive for longer than 30 minutes
    And the user attempts to perform an authenticated action
    Then the system should reject the expired session
    And the user should be required to authenticate again

  Scenario: Session behavior at the inactivity timeout boundary
    Given the user has logged in successfully
    And the configured inactivity timeout is 30 minutes
    When the user attempts an authenticated action at the timeout boundary
    Then the system should apply the documented timeout boundary rule consistently
    And access should be granted only if the session is still valid

  Scenario: Access a protected page after session expiry
    Given the user has logged in successfully
    And the user's session has expired
    When the user navigates directly to a protected page
    Then the system should deny access to the protected page
    And the user should be redirected to the login page or shown an authentication-required message
    And protected content should not be disclosed

  Scenario: Use the browser Back button after session expiry
    Given the user has logged in successfully
    And the user has accessed a protected page
    And the user's session has expired
    When the user clicks the browser Back button
    Then the system should not allow access to protected content through a fresh server request
    And protected data should not be retrievable using expired authentication

  Scenario: Submit an authenticated request after session expiry
    Given the user has logged in successfully
    And the user's session has expired
    When the user submits a request to a protected endpoint
    Then the server should reject the request as unauthenticated
    And the protected operation should not be executed
    And the response should indicate that authentication is required

  Scenario: Session expires while a protected page is open
    Given the user has logged in successfully
    And a protected page is open in the browser
    And the user's session expires due to inactivity
    When the user attempts an operation on the open page
    Then the system should detect the expired session
    And the operation should not succeed without renewed authentication

  Scenario: Log out and attempt to reuse the session
    Given the user has logged in successfully
    When the user logs out
    And the user attempts to access a protected page using the previous session
    Then the system should deny access
    And the user should be required to authenticate again

## Feature 4: Brute-force protection and account lockout

Feature: Brute-force protection and account lockout

  Scenario: Account remains accessible before reaching the failed-attempt limit
    Given the user has an active account
    And the account lockout threshold is 5 consecutive failed attempts
    And the user has made 3 consecutive failed login attempts
    When the user enters the correct username and password
    And the user clicks the Login button
    Then the user should be authenticated successfully
    And the account should not be locked

  Scenario: Account is not locked before the configured threshold
    Given the user has an active account
    And the account lockout threshold is 5 consecutive failed attempts
    And the user has made 4 consecutive failed login attempts
    When the user submits another login attempt with an incorrect password
    Then the login should fail
    And the system should apply the configured failed-attempt policy
    And the account should be locked if the threshold has now been reached

  Scenario: Account is locked after the fifth consecutive failed attempt
    Given the user has an active account
    And the account lockout threshold is 5 consecutive failed attempts
    And the user has made 4 consecutive failed login attempts
    When the user submits a fifth login attempt with an incorrect password
    Then the login should fail
    And the account should be locked according to the configured policy
    And the user should receive an appropriate lockout message

  Scenario: Correct credentials are rejected while the account is locked
    Given the user has an account locked due to repeated failed login attempts
    When the user enters the correct username and password
    And the user clicks the Login button
    Then the system should deny login while the lockout remains active
    And the user should receive an appropriate account-locked message
    And no authenticated session should be created

  Scenario: Failed login attempts reset after successful authentication
    Given the user has an active account
    And the system tracks consecutive failed login attempts
    And the user has made 2 consecutive failed login attempts
    When the user logs in successfully with the correct credentials
    And the user later submits an incorrect password
    Then the system should treat the incorrect password according to the consecutive-attempt policy
    And the previous failed attempts should not incorrectly cause an immediate lockout

  Scenario: Account remains locked at the lockout duration boundary
    Given the account has been locked for repeated failed login attempts
    And the configured lockout duration is 15 minutes
    When the user attempts to log in before the 15-minute lockout period ends
    Then the system should deny login
    And the account should remain locked

  Scenario: Account becomes eligible for login after temporary lockout expires
    Given the account has been temporarily locked due to repeated failed login attempts
    And the configured lockout duration is 15 minutes
    When the user attempts to log in after the lockout period has expired
    And the user enters the correct credentials
    Then the system should allow login if no other restriction applies
    And an authenticated session should be created

  Scenario: Repeated failed attempts against an unknown username
    Given the user is on the login page
    When an unknown username is submitted with an incorrect password repeatedly
    And the configured failed-attempt threshold is reached
    Then the system should apply the configured brute-force protection
    And authentication error messages should not disclose whether the username exists

  Scenario: Repeated failed attempts do not bypass the lockout
    Given the user's account is locked after reaching the failed-attempt threshold
    When the user submits additional login attempts with incorrect credentials
    Then the system should continue to deny authentication
    And the system should not create an authenticated session
    And the configured lockout policy should remain enforced

  Scenario: Failed login attempts from multiple clients are handled consistently
    Given the user has an active account
    And the failed-attempt policy is enforced across login requests
    When failed login attempts for the same account are submitted from multiple browser sessions
    And the configured threshold is reached
    Then the system should apply the account-level protection consistently
    And the user should not be able to bypass the lockout by switching browser sessions
