
import { test, expect } from "@playwright/test";
import { explainFailure } from "../../src/llm/failureExplainer";

test("SauceDemo rejects an incorrect password and Gemini explains it", async ({
  page,
}, testInfo) => {
  await page.goto("https://www.saucedemo.com/");

  // Observe actual fetch/XHR responses; SauceDemo may not call an auth API.
  const networkResponses: Array<{
    url: string;
    status: number;
    body: string;
  }> = [];

  page.on("response", async (response) => {
    const request = response.request();

    if (!["xhr", "fetch"].includes(request.resourceType())) {
      return;
    }

    let body = "Response body unavailable";

    try {
      body = (await response.text()).slice(0, 1500);
    } catch {
      // Some responses cannot be read.
    }

    networkResponses.push({
      url: response.url(),
      status: response.status(),
      body,
    });
  });

  await page.locator("#user-name").fill("standard_user");
  await page.locator("#password").fill("DefinitelyWrongPassword123!");
  await page.locator('[data-test="login-button"]').click();

  const errorMessage = page.locator('[data-test="error"]');

  await expect(errorMessage).toBeVisible();

  const actualError = (await errorMessage.innerText()).trim();

  // Verify the actual negative-login behavior.
  await expect(errorMessage).toContainText(
    "Username and password do not match"
  );
  await expect(page).toHaveURL("https://www.saucedemo.com/");

  const pageUrl = page.url();
  const pageState = (await page.locator("body").innerText()).slice(0, 3000);

  // Send observed evidence to Gemini. Do not invent an API response.
  const explanation = await explainFailure({
    testName: testInfo.title,
    errorMessage: actualError,
    pageUrl,
    pageState,
    apiResponse:
      networkResponses.length > 0
        ? JSON.stringify(networkResponses)
        : "No relevant fetch/XHR response was observed. The login rejection may be handled client-side.",
  });

  const reportOutput = [
    "SauceDemo Login Failure Analysis",
    `Page URL: ${pageUrl}`,
    `Observed login error: ${actualError}`,
    "",
    "Observed network responses:",
    networkResponses.length > 0
      ? JSON.stringify(networkResponses, null, 2)
      : "No fetch/XHR responses observed.",
    "",
    `Explanation: ${explanation.explanation}`,
    `Likely cause: ${explanation.likelyCause}`,
    `Suggested fix: ${explanation.suggestedFix}`,
  ].join("\n");

  await testInfo.attach("llm-failure-explanation.txt", {
    body: reportOutput,
    contentType: "text/plain",
  });
});
