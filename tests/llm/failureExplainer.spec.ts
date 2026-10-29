
import { test, expect } from "@playwright/test";
import { explainFailure } from "../../src/llm/failureExplainer";

test("Failure Explainer returns an explanation from the real Gemini API", async ({
}, testInfo) => {
  // Allow enough time for the API request and diagnostic output.
  test.setTimeout(30000);

  const result = await explainFailure({
    testName: "Login with valid credentials",
    errorMessage:
      'Expected URL to contain "/dashboard", but received "/login".',
    pageUrl: "http://localhost:3000/login",
  });

  expect(result.explanation.trim()).not.toBe("");
  expect(result.likelyCause.trim()).not.toBe("");
  expect(result.suggestedFix.trim()).not.toBe("");

  const reportOutput = [
    "LLM Failure Explanation",
    "Test: Login with valid credentials",
    "",
    `Explanation: ${result.explanation}`,
    `Likely cause: ${result.likelyCause}`,
    `Suggested fix: ${result.suggestedFix}`,
  ].join("\n");

  // Attach the actual LLM response to the Playwright HTML report.
  await testInfo.attach("llm-failure-explanation.txt", {
    body: reportOutput,
    contentType: "text/plain",
  });

  console.log("\n--- Gemini Failure Explanation ---");
  console.log(reportOutput);
});
