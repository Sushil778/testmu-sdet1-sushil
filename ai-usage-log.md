# AI Usage Log

## 1. Project Setup — Task 1
- **AI Tool:** ChatGPT
- **Task:** Set up the Playwright and TypeScript project structure.
- **Usage:** Used AI assistance to understand the project structure, configure Playwright, organize folders, and troubleshoot TypeScript configuration issues.
- **Outcome:** Created the initial framework structure, configured test scripts, and verified the starter tests and type checking.

## 2. Login Module — Task 2
- **AI Tool:** ChatGPT
- **Task:** Generate and refine Login module test cases.
- **Usage:** Generated initial test cases and refined the prompt to request Gherkin format, clearer expected results, reduced duplication, and no unsupported assumptions.
- **Outcome:** Produced improved Gherkin scenarios covering valid and invalid login, forgot password, session expiry, and brute-force protection.
- **Human Review:** Reviewed the generated scenarios and identified application-specific settings that require confirmation.

## 3. Dashboard Module — Task 2
- **AI Tool:** ChatGPT
- **Task:** Generate and refine Dashboard module test cases.
- **Usage:** Generated initial scenarios and improved the prompt to make expected results more specific, reduce overlapping scenarios, and identify missing requirements.
- **Outcome:** Produced improved Gherkin scenarios covering widget loading, data accuracy, filtering and sorting, responsive layout, and permission-based visibility.
- **Human Review:** Reviewed the output for coverage, clarity, duplication, and unsupported assumptions.

## 4. REST API Module — Task 2
- **AI Tool:** ChatGPT
- **Task:** Generate and refine REST API test cases.
- **Usage:** Generated initial scenarios and refined the prompt to distinguish HTTP error handling from schema validation, verify resource state around CRUD operations, and avoid inventing API specifications.
- **Outcome:** Produced improved Gherkin scenarios covering authentication tokens, CRUD operations, HTTP 4xx/5xx errors, rate limiting, and schema validation.
- **Human Review:** Reviewed the scenarios and identified API specifications that require confirmation.

## 5. LLM Integration — Task 3

- **AI Tools:** ChatGPT and Google Gemini API
- **Task:** Implement an LLM-powered Failure Explainer integrated with Playwright.
- **Usage:** Used ChatGPT to help design the integration, structure the failure evidence, implement the Gemini API call, validate the JSON response, integrate the explanation with Playwright, and troubleshoot API timeouts and test execution issues. Google Gemini was called from the implemented code to analyze the supplied test-failure evidence.
- **Implementation:** Added `src/llm/failureExplainer.ts` for the Gemini integration and response validation, `src/llm/failureExplainerFixture.ts` for collecting test evidence and attaching the explanation, and `tests/llm/sauceDemoLogin.spec.ts` as the primary demonstration.
- **Outcome:** The integration requests an explanation, likely cause, and suggested fix from Gemini. When the API call succeeds, the generated explanation is attached to the Playwright test result. A sample response is documented in `docs/llm-sample-output.md`.
- **Human Review:** Reviewed the generated explanation against the observed test evidence. The SauceDemo demonstration intentionally submits incorrect credentials, so the expected login rejection is not an application defect. Network telemetry responses must not be confused with authentication responses.
- **Limitations:** Live analysis requires a valid Gemini API key and network access. API timeouts or service errors may prevent the explanation from being generated.



