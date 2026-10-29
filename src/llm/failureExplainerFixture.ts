
import { test as base, expect } from "@playwright/test";
import type { TestInfo } from "@playwright/test";
import { explainFailure } from "./failureExplainer";

type FailureExplainerFixtures = {
  failureExplainer: void;
};

export const test = base.extend<FailureExplainerFixtures>({
  failureExplainer: [
    async ({ page }, use, testInfo: TestInfo) => {
      await use();

      // Analyze failed tests after execution and attach the explanation.
      if (
        testInfo.status !== "failed" &&
        testInfo.status !== "timedOut"
      ) {
        return;
      }

      const errorMessage =
        testInfo.errors
          .map((error) => error.message ?? "Unknown error")
          .join("\n") || "Test failed without an error message";

      // Capture actual browser context when the page is still available.
      let pageUrl: string | undefined;
      let pageState: string | undefined;

      try {
        pageUrl = page.url();

        pageState = await page
          .locator("body")
          .innerText({ timeout: 3000 })
          .catch(() => "Page text unavailable");
      } catch {
        pageState = "Browser page context unavailable";
      }

      try {
        const explanation = await explainFailure({
          testName: testInfo.title,
          errorMessage,
          pageUrl,
          pageState,
        });

        const reportOutput = [
          "LLM Failure Explanation",
          `Test: ${testInfo.title}`,
          `Status: ${testInfo.status}`,
          `Page URL: ${pageUrl ?? "Unavailable"}`,
          "",
          "Page state:",
          pageState ?? "Unavailable",
          "",
          `Explanation: ${explanation.explanation}`,
          `Likely cause: ${explanation.likelyCause}`,
          `Suggested fix: ${explanation.suggestedFix}`,
        ].join("\n");

        await testInfo.attach("llm-failure-explanation.txt", {
          body: reportOutput,
          contentType: "text/plain",
        });

        console.log("\n" + reportOutput);
      } catch (error) {
        console.error(
          "[Failure Explainer] Error:",
          error instanceof Error ? error.message : String(error)
        );
      }
    },
    { auto: true },
  ],
});

export { expect };
