## Feature: REST API Authentication Token Validation

  Scenario: Accept a valid token with sufficient permissions
    Given a valid authentication token is available
    And the token grants permission for the requested operation
    When the client sends a valid request to a protected API resource
    Then the API should process the request according to the resource contract
    And the response should match the documented success contract

  Scenario: Reject a missing authentication token
    Given the requested API resource requires authentication
    When the client sends a request without an authentication token
    Then the API should reject the request according to the authentication specification
    And protected resource data should not be disclosed
    And no protected resource modification should occur

  Scenario: Reject an invalid authentication token
    Given the client provides a token that fails the documented validation rules
    When the client sends a request to a protected API resource
    Then the API should reject the request according to the authentication specification
    And protected resource data should not be disclosed
    And no protected resource modification should occur

  Scenario: Reject an expired authentication token
    Given the client provides a token that is expired according to the documented token rules
    When the client sends a request to a protected API resource
    Then the API should reject the request according to the expiration rules
    And protected resource data should not be disclosed
    And no protected resource modification should occur

  Scenario: Deny an operation when the token lacks permission
    Given the client provides a valid authentication token
    And the token does not grant permission for the requested operation
    And the target resource state is recorded before the request
    When the client attempts the operation
    Then the API should deny the operation according to the authorization specification
    And the target resource should remain unchanged
    And unauthorized data should not be disclosed

  Scenario: Handle a malformed authentication token
    Given the client provides a token that violates the documented token format
    When the client sends a request to a protected API resource
    Then the API should handle the token according to the authentication specification
    And the response should follow the documented error contract
    And sensitive authentication details should not be disclosed

  ## Feature: REST API CRUD Operations

  Scenario: Create a resource successfully
    Given the client is authenticated and authorized to create the resource
    And the submitted request satisfies the documented creation schema
    And the resource does not already exist where uniqueness is required
    When the client submits the creation request
    Then the API should return the documented creation response
    And the response should identify the created resource as specified by the API contract
    And retrieving the created resource should return the persisted data
    And the persisted data should match the accepted request according to the creation rules

  Scenario: Reject creation with invalid request data
    Given the client is authenticated and authorized to create the resource
    And the submitted request violates the documented creation schema
    And the relevant resource state is recorded before the request
    When the client submits the creation request
    Then the API should return the documented validation error response
    And no resource should be created from the rejected request
    And the relevant resource state should remain unchanged

  Scenario: Retrieve an existing resource
    Given the client is authenticated and authorized to read the resource
    And the resource exists with known persisted data
    When the client requests the resource
    Then the API should return the documented successful response
    And the returned resource identifier should match the requested identifier
    And the returned data should match the persisted resource according to the response schema

  Scenario: Retrieve a nonexistent resource
    Given the client is authenticated and authorized to read the resource
    And the requested resource does not exist
    When the client requests the resource
    Then the API should return the documented response for a nonexistent resource
    And the response should not contain fabricated resource data
    And no resource should be created as a side effect

  Scenario: Update an existing resource successfully
    Given the client is authenticated and authorized to update the resource
    And the resource exists with a recorded initial state
    And the update request satisfies the documented update schema
    When the client submits the update request
    Then the API should return the documented update response
    And retrieving the resource should show the accepted changes
    And fields not intended to change should retain their values according to the update semantics

  Scenario: Reject an invalid update without changing the resource
    Given the client is authenticated and authorized to update the resource
    And the resource exists with a recorded initial state
    And the update request violates the documented update schema
    When the client submits the update request
    Then the API should return the documented validation error response
    And retrieving the resource should show that its state remains unchanged
    And no unintended field changes should have occurred

  Scenario: Update a nonexistent resource
    Given the client is authenticated and authorized to update resources
    And the target resource does not exist
    When the client submits an update request for that resource
    Then the API should return the documented response for a nonexistent resource
    And no unintended resource should be created or modified

  Scenario: Delete an existing resource successfully
    Given the client is authenticated and authorized to delete the resource
    And the resource exists with a recorded initial state
    When the client submits the deletion request
    Then the API should return the documented deletion response
    And a subsequent retrieval or resource-state check should confirm the documented deletion outcome
    And unrelated resources should remain unchanged

  Scenario: Delete a nonexistent resource
    Given the client is authenticated and authorized to delete resources
    And the target resource does not exist
    When the client submits the deletion request
    Then the API should return the documented response for deleting a nonexistent resource
    And no unrelated resource should be deleted
    And the resource collection should remain consistent with the documented deletion behavior

  ## Feature: REST API HTTP Error Handling

  Scenario: Handle a request using an unsupported HTTP method
    Given the client can access the API resource
    And the requested HTTP method is not supported for that resource
    When the client submits the request
    Then the API should return the documented unsupported-method response
    And the response should conform to the documented error schema
    And the resource state should remain unchanged

  Scenario: Handle a request for an inaccessible resource
    Given the client submits a request for a resource it is not authorized to access
    When the API evaluates the request
    Then the API should apply the documented authorization and resource-disclosure rules
    And protected information should not be exposed
    And no unauthorized modification should occur

  Scenario: Handle a request that exceeds an allowed request constraint
    Given the API specification defines a request constraint
    And the client submits a request that violates that constraint
    When the API validates the request
    Then the API should return the documented client-error response
    And the response should identify the failure according to the error contract
    And no unintended resource modification should occur

  Scenario: Handle an unexpected internal server failure
    Given the client submits a request that satisfies the documented API contract
    And the server encounters an internal processing failure
    When the API processes the request
    Then the API should return the documented server-error response
    And the response should conform to the documented error schema
    And the response should not expose stack traces, secrets, or internal implementation details

  Scenario: Handle an unavailable server-side dependency
    Given the client submits a valid API request
    And a required server-side dependency is unavailable
    When the API attempts to process the request
    Then the API should return the documented failure response
    And the response should not falsely indicate successful completion
    And the resource state should be consistent with the documented failure and transaction behavior

  Scenario: Verify recovery after a server-side failure
    Given a valid request previously encountered a transient server-side failure
    And the server-side dependency has recovered
    And the current resource state is recorded before retrying
    When the client retries the request according to the documented retry rules
    Then the API should return the response appropriate to the retry outcome
    And the resulting resource state should match the documented operation semantics
    And the retry should not cause unintended duplicate changes

  ## Feature: REST API Rate Limiting

  Scenario: Process requests within the documented rate limit
    Given the applicable rate limit and measurement window are documented
    And the client has not exceeded the applicable limit
    When the client sends requests within the permitted limit
    Then the API should process the requests according to their individual contracts
    And the responses should conform to the documented success or operation-specific outcomes

  Scenario: Enforce the rate limit when the permitted limit is exceeded
    Given the applicable rate limit and measurement window are documented
    And the client has reached the applicable request limit
    When the client sends an additional request within the restricted period
    Then the API should apply the documented rate-limiting behavior
    And the response should match the documented rate-limit error contract
    And a rejected modifying request should not change the resource state

  Scenario: Verify behavior at the rate-limit boundary
    Given the applicable rate limit and measurement window are documented
    And the initial rate-limit state is known
    When the client sends requests up to the documented limit
    And the client sends one additional request within the same measurement window
    Then the API should handle each request according to the documented boundary rules
    And the response for each request should match the applicable rate-limit behavior

  Scenario: Verify request handling after the rate limit resets
    Given the client has exceeded the applicable rate limit
    And the documented reset condition has been reached
    When the client sends a valid request
    Then the API should evaluate the request against the current rate-limit state
    And the response should follow the documented rate-limiting rules

  Scenario: Verify documented rate-limit metadata
    Given the API specification defines rate-limit response headers or body fields
    And the client sends a request that exceeds the applicable limit
    When the API returns a rate-limit response
    Then each required rate-limit metadata field should be present
    And each returned value should conform to the documented type and meaning

  ## Feature: REST API Request and Response Schema Validation

  Scenario: Accept a request that conforms to the documented schema
    Given the request schema defines the required fields and accepted value types
    And the client submits a request that conforms to that schema
    When the API validates the request
    Then the request should pass schema validation
    And the API should process it according to the resource contract
    And the response should conform to the documented response schema

  Scenario: Reject a request with a missing required field
    Given the request schema identifies a field as required
    And the client omits that field
    When the client submits the request
    Then the API should apply the documented missing-field validation behavior
    And the response should match the documented validation error schema
    And no unintended resource modification should occur

  Scenario: Reject a request with an incorrect field type
    Given the request schema defines the expected type of a field
    And the client supplies a value of an incompatible type
    When the client submits the request
    Then the API should apply the documented type-validation behavior
    And the response should match the documented validation error schema
    And the request should not produce an unintended resource modification

  Scenario: Validate additional fields according to the schema
    Given the request schema defines how undocumented fields are handled
    And the client submits a request containing an additional field
    When the API validates the request
    Then the API should accept or reject the field according to the schema rules
    And the response and persisted resource state should follow the documented contract

  Scenario: Validate string values at documented length boundaries
    Given the request schema defines minimum or maximum string lengths
    And the client prepares values at each defined boundary and immediately outside it
    When the client submits a request for each test value
    Then values at the boundaries should be handled according to the documented inclusive or exclusive rules
    And values outside the permitted range should be handled according to the validation contract
    And rejected requests should not cause unintended resource modifications

  Scenario: Validate numeric values at documented boundaries
    Given the request schema defines minimum or maximum numeric values
    And the client prepares values at each defined boundary and immediately outside it
    When the client submits a request for each test value
    Then values at the boundaries should be handled according to the documented range rules
    And values outside the permitted range should be handled according to the validation contract
    And rejected requests should not cause unintended resource modifications

  Scenario: Reject syntactically malformed JSON
    Given the API endpoint expects a JSON request body
    And the client submits syntactically invalid JSON
    When the API attempts to parse the request body
    Then the API should return the documented parsing-error response
    And the response should conform to the documented error schema
    And no unintended resource modification should occur

  Scenario: Verify successful response schema compliance
    Given the response schema for a successful operation is documented
    And the client submits a valid request
    When the API returns a successful response
    Then all required response fields should be present
    And each field should have the documented type and format
    And the returned resource data should match the operation outcome

  Scenario: Verify error response schema compliance
    Given the API defines a response schema for validation errors
    And the client submits a request that violates the documented request schema
    When the API rejects the request
    Then the response should conform to the documented validation error schema
    And required error fields should be present with the correct types
    And internal implementation details should not be exposed

  ## Feature: REST API Request and Response Schema Validation

  Scenario: Accept a request that conforms to the documented schema
    Given the request schema defines the required fields and accepted value types
    And the client submits a request that conforms to that schema
    When the API validates the request
    Then the request should pass schema validation
    And the API should process it according to the resource contract
    And the response should conform to the documented response schema

  Scenario: Reject a request with a missing required field
    Given the request schema identifies a field as required
    And the client omits that field
    When the client submits the request
    Then the API should apply the documented missing-field validation behavior
    And the response should match the documented validation error schema
    And no unintended resource modification should occur

  Scenario: Reject a request with an incorrect field type
    Given the request schema defines the expected type of a field
    And the client supplies a value of an incompatible type
    When the client submits the request
    Then the API should apply the documented type-validation behavior
    And the response should match the documented validation error schema
    And the request should not produce an unintended resource modification

  Scenario: Validate additional fields according to the schema
    Given the request schema defines how undocumented fields are handled
    And the client submits a request containing an additional field
    When the API validates the request
    Then the API should accept or reject the field according to the schema rules
    And the response and persisted resource state should follow the documented contract

  Scenario: Validate string values at documented length boundaries
    Given the request schema defines minimum or maximum string lengths
    And the client prepares values at each defined boundary and immediately outside it
    When the client submits a request for each test value
    Then values at the boundaries should be handled according to the documented inclusive or exclusive rules
    And values outside the permitted range should be handled according to the validation contract
    And rejected requests should not cause unintended resource modifications

  Scenario: Validate numeric values at documented boundaries
    Given the request schema defines minimum or maximum numeric values
    And the client prepares values at each defined boundary and immediately outside it
    When the client submits a request for each test value
    Then values at the boundaries should be handled according to the documented range rules
    And values outside the permitted range should be handled according to the validation contract
    And rejected requests should not cause unintended resource modifications

  Scenario: Reject syntactically malformed JSON
    Given the API endpoint expects a JSON request body
    And the client submits syntactically invalid JSON
    When the API attempts to parse the request body
    Then the API should return the documented parsing-error response
    And the response should conform to the documented error schema
    And no unintended resource modification should occur

  Scenario: Verify successful response schema compliance
    Given the response schema for a successful operation is documented
    And the client submits a valid request
    When the API returns a successful response
    Then all required response fields should be present
    And each field should have the documented type and format
    And the returned resource data should match the operation outcome

  Scenario: Verify error response schema compliance
    Given the API defines a response schema for validation errors
    And the client submits a request that violates the documented request schema
    When the API rejects the request
    Then the response should conform to the documented validation error schema
    And required error fields should be present with the correct types
    And internal implementation details should not be exposed

  