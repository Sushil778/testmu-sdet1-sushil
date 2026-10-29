Feature: Login Module
  As a registered user
  I want to log in securely
  So that I can access the application and recover my account when needed

  # Application-specific settings requiring confirmation:
  # - Session inactivity timeout
  # - Failed login attempt threshold
  # - Account lockout duration and recovery behavior
  # - Password reset link validity period
  # - Username case sensitivity and input length limits

  Background:
    Given the user is on the login page

  # --------------------------------------------------
  # Feature 1: Login with valid and invalid credentials
  # --------------------------------------------------

  Scenario: Login successfully with valid credentials
    Given the user has an active registered account
    When the user enters the correct username
    And the user enters the correct password
    And the user clicks the Login button
    Then the user should be authenticated successfully
    And the user should be redirected to the default authenticated page
    And an authenticated session should be created

  Scenario: Login with an invalid username
    Given the user does not have an account registered with the entered username
    When the user enters the invalid username
    And the user enters a password
    And the user clicks the Login button
    Then the login should fail
    And an appropriate authentication error should be displayed
    And the user should remain unauthenticated

  Scenario: Login with an invalid password
    Given the user has an active registered account
    When the user enters the correct username
    And the user enters an incorrect password
    And the user clicks the Login button
    Then the login should fail
    And an appropriate authentication error should be displayed
    And the user should remain unauthenticated

  Scenario: Login with both invalid username and password
    Given the entered username is not registered
    When the user enters the invalid username
    And the user enters an incorrect password
    And the user clicks the Login button
    Then the login should fail
    And the user should remain unauthenticated
    And the error message should not disclose whether the username is registered

  Scenario: Submit login form with both fields empty
    When the user leaves the username field empty
    And the user leaves the password field empty
    And the user clicks the Login button
    Then the login request should not be accepted
    And validation messages should identify the required fields
    And the user should remain on the login page

  Scenario: Submit login form with an empty username
    When the user leaves the username field empty
    And the user enters a password
    And the user clicks the Login button
    Then the login request should be rejected
    And a username validation message should be displayed
    And the user should remain unauthenticated

  Scenario: Submit login form with an empty password
    When the user enters a registered username
    And the user leaves the password field empty
    And the user clicks the Login button
    Then the login request should be rejected
    And a password validation message should be displayed
    And the user should remain unauthenticated

  Scenario: Login using a password containing leading or trailing spaces
    Given the user has an active registered account
    When the user enters the registered username
    And the user enters a password containing leading or trailing spaces
    And the user clicks the Login button
    Then the system should validate the password according to its documented whitespace-handling rules
    And the login result should match the stored password and configured authentication behavior

  Scenario: Login using a username with different letter casing
    Given the user has an active registered account
    When the user enters the registered username with different letter casing
    And the user enters the correct password
    And the user clicks the Login button
    Then the system should apply its documented username case-sensitivity rules
    And authentication should succeed only if the entered username matches those rules

  Scenario: Login with a password at the maximum supported input length
    Given the user has an active registered account
    And the maximum supported password length has been confirmed
    When the user enters the registered username
    And the user enters a password at the maximum supported length
    And the user clicks the Login button
    Then the system should process the complete password without unintended truncation
    And authentication should succeed if the password matches the registered account

  Scenario: Login with a password exceeding the maximum supported input length
    Given the maximum supported password length has been confirmed
    When the user enters a password exceeding the supported length
    And the user clicks the Login button
    Then the system should handle the input according to the documented length restriction
    And the system should not authenticate the user using an unintentionally truncated password

  # --------------------------------------------------
  # Feature 2: Forgot-password workflow
  # --------------------------------------------------

  Scenario: Open the forgot-password page
    When the user clicks the Forgot Password link
    Then the forgot-password page should be displayed
    And an email input field should be available
    And the user should be able to submit a password reset request

  Scenario: Request a password reset using a registered email address
    Given the user has an account associated with a registered email address
    When the user opens the forgot-password page
    And the user enters the registered email address
    And the user submits the password reset request
    Then the system should process the reset request
    And a password reset email should be sent according to the configured email delivery process
    And a confirmation message should be displayed

  Scenario: Request a password reset using an unregistered email address
    Given the user does not have an account associated with the entered email address
    When the user opens the forgot-password page
    And the user enters the unregistered email address
    And the user submits the password reset request
    Then the system should not issue a password reset link for that address
    And the response should not disclose whether an account exists

  Scenario: Submit a password reset request with an empty email address
    When the user opens the forgot-password page
    And the user leaves the email field empty
    And the user submits the password reset request
    Then the request should be rejected
    And a required-field validation message should be displayed

  Scenario: Submit a password reset request with an invalid email format
    When the user opens the forgot-password page
    And the user enters an invalid email address such as "user@"
    And the user submits the password reset request
    Then the request should be rejected
    And an email-format validation message should be displayed
    And no password reset email should be sent

  Scenario: Submit an email address at the supported length boundary
    Given the maximum supported email address length has been confirmed
    When the user opens the forgot-password page
    And the user enters an email address at the maximum supported length
    And the user submits the password reset request
    Then the system should validate the address without unintended truncation
    And the request should be processed only if the address is valid

  Scenario: Open a valid password reset link
    Given the user has received a valid password reset link
    When the user opens the link before its expiry
    Then the password reset page should be displayed
    And the user should be allowed to enter a new password

  Scenario: Open an expired password reset link
    Given the user has received a password reset link
    And the link has passed its configured validity period
    When the user opens the link
    Then the system should reject the reset request
    And an appropriate expired-link message should be displayed
    And the user should be prompted to request a new reset link

  Scenario: Reuse a password reset link after a successful reset
    Given the user has successfully reset the password using a reset link
    When the user opens the same reset link again
    Then the system should reject the reused link
    And the password should not be changed through the reused link

  Scenario: Reset the password successfully
    Given the user has opened a valid password reset link
    When the user enters a new password that meets the configured password requirements
    And the user enters the same password in the confirmation field
    And the user submits the password reset form
    Then the password should be updated successfully
    And a password reset confirmation should be displayed
    And the user should be able to log in using the new password

  Scenario: Submit mismatched new password and confirmation
    Given the user has opened a valid password reset link
    When the user enters a valid new password
    And the user enters a different password in the confirmation field
    And the user submits the password reset form
    Then the password reset should be rejected
    And a password mismatch message should be displayed
    And the existing password should remain unchanged

  Scenario: Submit the password reset form with an empty new password
    Given the user has opened a valid password reset link
    When the user leaves the new password field empty
    And the user enters a value in the confirmation field
    And the user submits the password reset form
    Then the password reset should be rejected
    And a required-field validation message should be displayed
    And the existing password should remain unchanged

  # --------------------------------------------------
  # Feature 3: Session expiry and protected-page access
  # --------------------------------------------------

  Scenario: Access a protected page while the session is valid
    Given the user has logged in successfully
    And the authenticated session is still valid
    When the user accesses a protected page
    Then the system should allow access to the page
    And the protected content should be displayed

  Scenario: Session expires after the configured inactivity period
    Given the user has logged in successfully
    And the configured session inactivity timeout has been confirmed
    When the user remains inactive beyond the configured timeout
    And the user attempts an authenticated action
    Then the system should reject the expired session
    And the user should be required to authenticate again

  Scenario: Access a protected page after session expiry
    Given the user has logged in successfully
    And the user's session has expired
    When the user navigates directly to a protected page
    Then the system should deny access to the protected page
    And the user should be redirected to the login page or shown an authentication-required message
    And protected content should not be disclosed

  Scenario: Submit a protected request after session expiry
    Given the user has logged in successfully
    And the user's session has expired
    When the user submits a request to a protected endpoint
    Then the server should reject the request as unauthenticated
    And the protected operation should not be executed
    And the response should indicate that authentication is required

  Scenario: Use the browser Back button after session expiry
    Given the user has logged in successfully
    And the user has viewed a protected page
    And the user's session has expired
    When the user clicks the browser Back button
    Then the application should not serve protected data through a fresh request without authentication
    And any previously cached content should not permit further authenticated operations

  Scenario: Attempt an operation on a page that remains open after session expiry
    Given the user has logged in successfully
    And a protected page remains open in the browser
    And the user's session has expired
    When the user attempts an authenticated operation on that page
    Then the system should reject the operation
    And the user should be required to authenticate again

  Scenario: Reuse a session after logout
    Given the user has logged in successfully
    When the user logs out
    And the user attempts to access a protected page using the previous session
    Then the system should deny access
    And the user should be required to authenticate again

  Scenario: Access a protected page at the session expiry boundary
    Given the user has logged in successfully
    And the session expiry boundary and timeout rules have been confirmed
    When the user attempts to access a protected page at the expiry boundary
    Then the system should apply the documented session validity rule consistently
    And access should be granted only if the session is valid

  # --------------------------------------------------
  # Feature 4: Brute-force protection and account lockout
  # --------------------------------------------------

  Scenario: Log in successfully before reaching the failed-attempt threshold
    Given the user has an active registered account
    And the configured failed-login threshold has been confirmed
    And the user's failed login count is below the configured threshold
    When the user enters the correct username and password
    And the user clicks the Login button
    Then the user should be authenticated successfully
    And the account should not be locked

  Scenario: Reach the configured failed-login threshold
    Given the user has an active registered account
    And the configured failed-login threshold has been confirmed
    And the user has made one fewer consecutive failed attempt than the configured threshold
    When the user submits another login attempt with an incorrect password
    Then the login should fail
    And the system should apply the configured account lockout policy
    And the account should be locked if the threshold has been reached

  Scenario: Attempt login with correct credentials while the account is locked
    Given the user account is locked due to repeated failed login attempts
    When the user enters the correct username and password
    And the user clicks the Login button
    Then the system should deny login while the lockout remains active
    And an appropriate account-locked message should be displayed
    And no authenticated session should be created

  Scenario: Reset the consecutive failed-attempt count after successful login
    Given the user has made one or more failed login attempts
    And the user has not reached the account lockout threshold
    When the user logs in successfully with the correct credentials
    And the user later submits an incorrect password
    Then the system should apply the documented failed-attempt counting policy
    And previous failed attempts should not incorrectly trigger an immediate lockout if successful login resets the count

  Scenario: Attempt login before the lockout period expires
    Given the user account is temporarily locked
    And the configured lockout duration has been confirmed
    And the lockout period has not yet expired
    When the user attempts to log in with the correct credentials
    Then the system should deny login while the lockout remains active
    And no authenticated session should be created

  Scenario: Attempt login after the lockout period expires
    Given the user account was temporarily locked due to repeated failed attempts
    And the configured lockout duration has been confirmed
    And the lockout period has expired
    When the user enters the correct username and password
    And the user clicks the Login button
    Then the system should apply the documented lockout recovery policy
    And login should succeed if the lockout has been lifted and no other restriction applies

  Scenario: Submit repeated failed login attempts for an unknown username
    Given the user is on the login page
    And the brute-force protection policy has been confirmed
    When the user submits repeated login attempts using an unknown username
    And the configured protection threshold is reached
    Then the system should apply the configured brute-force protection
    And authentication responses should not disclose whether the username exists

  Scenario: Continue submitting login attempts while the account is locked
    Given the user account is locked due to repeated failed login attempts
    When the user submits additional login attempts
    Then the system should continue to deny authentication while the lockout remains active
    And no authenticated session should be created
    And additional attempts should not bypass the configured lockout policy

  Scenario: Submit failed login attempts from multiple browser sessions
    Given the user has an active registered account
    And the brute-force protection policy applies across browser sessions
    When failed login attempts for the same account are submitted from multiple browser sessions
    And the configured protection threshold is reached
    Then the system should enforce the applicable account-level protection consistently
    And switching browser sessions should not bypass the configured lockout policy