 # --------------------------------------------------
 # Prompt : Login Module Test Case Generation
 # --------------------------------------------------

Act as a QA engineer with experience in web application testing and test design.
Generate test cases for a generic web application's Login module. Cover these required areas:

1. Login with valid credentials.
2. Login with invalid username, invalid password, and both invalid.
3. Forgot-password workflow, including invalid or unregistered email addresses.
4. Session expiry and behavior when the user tries to access a protected page after expiry.
5. Brute-force protection and account lockout after repeated failed login attempts.

Generate the test cases in Gherkin format using Feature, Scenario, Given, When, Then, and And.

Include positive, negative and boundary scenarios. Give each scenario a clear title and use specific steps and expected results. Avoid duplicate test cases and don't add test cases for any features I haven't mentioned.

## Improved: Login Module Test Case Generation

Generate test cases for the same Login module using the requirements mentioned in my initial prompt.
Return the test cases in Gherkin format using Feature, Scenario, Given, When, Then, and And.
Cover login with valid and invalid credentials, forgot-password workflow, session expiry, and brute-force protection with account lockout. Include positive, negative, and boundary scenarios.
Make the expected results clear and specific. Avoid duplicate scenarios and do not add test cases for features I have not mentioned. Do not assume values for application-specific settings such as session timeout, failed-login threshold, or lockout duration when they are not provided. Mention such details as requiring confirmation.
Keep the scenarios easy to understand and make sure the output follows valid Gherkin syntax.

### Login Module — Prompt Improvement Notes

The initial prompt covered the main login scenarios, but the generated output included assumptions about session timeout and account-lockout values. I revised the prompt to request Gherkin format and clearer expected results. I also instructed the LLM not to assume unspecified application settings and to avoid unrelated or duplicate scenarios. The revised output follows a more consistent structure, although some overlapping scenarios still require review.

 # --------------------------------------------------
 # Prompt : Dashboard Module
 # --------------------------------------------------

Act as a QA engineer. Generate test cases for the Dashboard module of a generic web-based test management platform.

Cover these areas:
1. Dashboard widgets load correctly.
2. Dashboard data is accurate.
3. Filters and sorting work correctly.
4. Dashboard layout works on different screen sizes.
5. Dashboard widgets and data are visible according to user permissions.

Generate the test cases in Gherkin format using Feature, Scenario, Given, When, Then, and And.

Include positive, negative, and boundary scenarios wherever applicable.
Keep the test cases clear and avoid duplicates. Do not assume application-specific behavior or configuration that has not been provided.

## improved prompt: 
Generate improved test cases for the Dashboard module using the requirements from my initial prompt. Return the test cases in valid Gherkin format using Feature, Scenario, Given, When, Then, and And.

Cover all five required areas: widget loading, data accuracy, filter and sort behavior, responsive layout and permission-based visibility. Include positive, negative and boundary scenarios where relevant.

Improve the output by:
- Making expected results specific, observable, and testable.
- Removing duplicate or substantially overlapping scenarios.
- Avoiding assumptions about application-specific limits, refresh intervals, screen breakpoints, roles, or permission rules that have not been provided.
- Clearly identifying any missing requirements that need confirmation instead of inventing values or behavior.
- Including appropriate negative and boundary cases without adding unrelated features.

Keep scenarios concise, logically grouped, and easy to review. Ensure the Gherkin syntax is valid.

## Dashboard Module — Prompt Improvement Notes

The initial prompt covered all five required areas, but some expected results were vague and a few scenarios overlapped. It also generated scenarios involving unspecified limits and responsive breakpoints. I improved the prompt to request specific, testable expected results, reduce duplicate scenarios and avoid assumptions about application-specific behavior. I also asked the LLM to identify missing requirements that need confirmation.

 # --------------------------------------------------
 # Prompt : REST API Module
 # --------------------------------------------------

 Act as a QA engineer. Generate test cases for the REST API module of a generic web-based test management platform.

Cover these areas:
1. Authentication token validation.
2. CRUD operations (Create, Read, Update, Delete).
3. Error handling for 4xx and 5xx HTTP status codes.
4. Rate limiting.
5. API schema validation.

Generate the test cases in Gherkin format using Feature, Scenario, Given, When, Then, and And. Include positive, negative, and boundary scenarios wherever applicable.

Keep the test cases clear and avoid duplicates. Do not assume application-specific behavior, endpoint paths, request fields, rate limits, authentication rules or response schemas that have not been provided.

## Improved prompt:
Generate improved test cases for the REST API module using the requirements from my initial prompt.

Return the test cases in valid Gherkin format using Feature, Scenario, Given, When, Then, and And.

Cover all five required areas:

1. Authentication token validation.
2. CRUD operations.
3. HTTP 4xx and 5xx error handling.
4. Rate limiting.
5. Request and response schema validation.

Improve the output by:

- Making expected results specific, observable, and testable.
- Verifying resource state before and after CRUD operations where applicable.
- Avoiding duplicate or substantially overlapping scenarios.
- Distinguishing general HTTP error handling from schema-validation failures.
- Covering positive, negative, and boundary cases where relevant.
- Avoiding invented endpoint paths, request fields, HTTP status codes, token rules, rate limits, and schema constraints.
- Clearly identifying missing API specifications that need confirmation instead of assuming values or behavior.

Keep scenarios concise, logically grouped, and easy to review. Ensure the Gherkin syntax is valid.


### REST API Module — Prompt Improvement Notes

The initial output covered all five required areas but included some overlapping scenarios and expected results that were not always specific or testable. I improved the prompt to distinguish HTTP error handling from schema validation and to verify resource state before and after CRUD operations. I also instructed the LLM to include positive, negative, and boundary cases while avoiding assumptions about endpoints, status codes, rate limits, and schema rules that were not provided. The revised output is more structured and highlights missing API specifications that require confirmation.