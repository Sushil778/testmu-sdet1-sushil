
import { test, expect } from "../../src/llm/failureExplainerFixture";

test("TestMu login rejects an incorrect password", async ({ page }) => {
  const authResponses: Array<{
    url: string;
    status: number;
    body: string;
  }> = [];

  // Capture actual authentication responses, without logging credentials.
  page.on("response", async (response) => {
    if (!/auth\.lambdatest\.com\/api\/login/i.test(response.url())) {
      return;
    }

    let body = "Response body unavailable";

    try {
      body = await response.text();
    } catch {
      // The response may no longer be readable.
    }

    // Keep the captured diagnostic data small.
    authResponses.push({
      url: response.url(),
      status: response.status(),
      body: body.slice(0, 2000),
    });
  });

  await page.goto("https://www.testmuai.com/login/");

  const email = process.env.TESTMU_EMAIL;

  if (!email) {
    throw new Error("TESTMU_EMAIL is missing from .env");
  }

  // Follow the real email-first login flow.
  await page.locator("#email").fill(email);
  await page.getByRole("button", { name: "Continue" }).click();

  await page.waitForURL(/accounts\.lambdatest\.com\/login/, {
    timeout: 15000,
  });

  await expect(page.locator("#email")).toBeVisible();
  await expect(page.locator("#password")).toBeVisible();

  // Use one deliberately incorrect password for this negative test.
  await page.locator("#password").fill("InvalidPassword-For-Test-123!");
  await page.getByRole("button", { name: "Login" }).click();

  // Wait for the real authentication request to finish.
  await expect
    .poll(() => authResponses.length, { timeout: 15000 })
    .toBeGreaterThan(0);

  const authFailure = authResponses[authResponses.length - 1];

  // Confirm that the server rejected the login attempt.
  expect(authFailure.status).toBeGreaterThanOrEqual(400);

  // Check the actual validation message shown by the application.
  await expect(
    page.locator("#useremail")
  ).toContainText(/correct email address and password/i);

  // Pass the real API response and page context to Gemini.
  const { explainFailure } = await import(
  "../../src/llm/failureExplainer.js"
);

  const pageState = await page.locator("body").innerText();

  const explanation = await explainFailure({
    testName: "TestMu login rejects an incorrect password",
    errorMessage: `Authentication request returned HTTP ${authFailure.status}`,
    pageUrl: page.url(),
    pageState,
    apiResponse: JSON.stringify({
      status: authFailure.status,
      body: authFailure.body,
    }),
  });

  const reportOutput = [
    "TestMu Real Login Failure Analysis",
    `HTTP status: ${authFailure.status}`,
    `Page URL: ${page.url()}`,
    "",
    "Captured API response:",
    authFailure.body,
    "",
    `Explanation: ${explanation.explanation}`,
    `Likely cause: ${explanation.likelyCause}`,
    `Suggested fix: ${explanation.suggestedFix}`,
  ].join("\n");

  await test.info().attach("testmu-api-failure-explanation.txt", {
    body: reportOutput,
    contentType: "text/plain",
  });
});
