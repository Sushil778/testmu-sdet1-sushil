
import type {
  Reporter,
  TestCase,
  TestResult,
} from "@playwright/test/reporter";
import { mkdir, writeFile } from "node:fs/promises";
import path from "node:path";

import { explainFailure } from "./failureExplainer";

class FailureExplainerReporter implements Reporter {
  async onTestEnd(test: TestCase, result: TestResult): Promise<void> {
    if (result.status !== "failed" && result.status !== "timedOut") {
      return;
    }

    const errorMessage =
      result.errors
        .map((error) => error.message ?? "Unknown error")
        .join("\n") || "Test failed without an error message";

    console.log(`\n[Failure Explainer] Analyzing: ${test.title}`);

    try {
      const explanation = await explainFailure({
        testName: test.title,
        errorMessage,
      });

      const reportOutput = [
        `Test: ${test.title}`,
        `Status: ${result.status}`,
        "",
        `Explanation: ${explanation.explanation}`,
        `Likely cause: ${explanation.likelyCause}`,
        `Suggested fix: ${explanation.suggestedFix}`,
      ].join("\n");

      const outputDir = path.resolve("test-results");
      await mkdir(outputDir, { recursive: true });

      const attachmentPath = path.join(
        outputDir,
        `llm-failure-explanation-${Date.now()}.txt`
      );

      await writeFile(attachmentPath, reportOutput, "utf8");

      console.log(`\n${reportOutput}`);
      console.log(`Saved explanation to: ${attachmentPath}`);
    } catch (error) {
      const message =
        error instanceof Error ? error.message : String(error);

      console.error(
        `[Failure Explainer] Could not analyze "${test.title}": ${message}`
      );
    }
  }
}

export default FailureExplainerReporter;
