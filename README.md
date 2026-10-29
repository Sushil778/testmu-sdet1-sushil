# TestMu AI SDET Assessment

This repository contains the Playwright + TypeScript assessment project.
It includes Task 2 generated test cases and a real Google Gemini API
integration that produces an explanation, likely cause and suggested
fix from supplied test-failure evidence.

## Quick review guide

1. `prompts.md` — Raw prompts used for Task 2.
2. `docs/` — Generated test cases, initial drafts, improved versions, and sample LLM output.
3. `src/llm/failureExplainer.ts` — Gemini API call, prompt, JSON parsing, and response validation.
4. `src/llm/failureExplainerFixture.ts` — Playwright fixture for collecting failure details and attaching the explanation.
5. `src/llm/failureExplainerReporter.ts` — Reporter implementation.
6. `tests/llm/sauceDemoLogin.spec.ts` — Primary end-to-end demonstration.
7. `ai-usage-log.md` — AI tools used, tasks supported, and outputs produced.




## Folder structure

``` text
TestMU-SDET/
├── .github/
│   └── workflows/
│       └── playwright.yml
├── docs/
│   ├── api-test-cases-initial.md
│   ├── api-test-cases.md              
│   ├── dashboard-test-cases-initial.md
│   ├── dashboard-test-cases-improved.md
│   ├── llm-sample-output.md
│   ├── login-test-cases-initial.md
│   └── login-test-cases-improved.md
├── src/
│   ├── llm/
│   │   ├── failureExplainer.ts            # Gemini integration
│   │   ├── failureExplainerFixture.ts     # Capture evidence and attach LLM output
│   │   └── failureExplainerReporter.ts    # Reporter implementation
│   ├── pages/                             
│   └── utils/                             
├── tests/
│   ├── fixtures/                          
│   ├── llm/
│   │   ├── failureExplainer.spec.ts       # LLM integration test
│   │   ├── sauceDemoLogin.spec.ts         # Main SauceDemo demonstration
│   │   └── testmuLogin.spec.ts            # Optional live TestMu experiment
├── .env.example                           # Environment variable template
├── .gitignore
├── ai-usage-log.md
├── package.json
├── package-lock.json
├── playwright.config.ts
├── prompts.md
├── README.md
└── tsconfig.json
```

## Prerequisites

-   Node.js and npm.
-   Internet access to install dependencies, download Chromium, and call
    Gemini.
-   A Google Gemini API key with access to the model configured in
    `src/llm/failureExplainer.ts`.

Developed with Node.js `v24.16.0` and npm `10.8.0`.

## Setup

### 1. Clone the repository

``` bash
git clone https://github.com/Sushil778/testmu-sdet1-sushil.git
cd TestMU-SDET
```

If the directory created by Git has another name, enter that directory.

### 2. Install dependencies and browser

``` bash
npm install
npx playwright install chromium
```

### 3. Configure the Gemini API key

Create a local `.env` file in the project root, using `.env.example` as
a guide:

``` dotenv
GEMINI_API_KEY=your_gemini_api_key_here
```

## Run the project

### Type-check

``` bash
npm run typecheck
```

This checks TypeScript types; it does not execute tests or call Gemini.

### Run the primary SauceDemo demonstration

``` bash
npx playwright test tests/llm/sauceDemoLogin.spec.ts --workers=1
```

The test opens SauceDemo, submits an intentionally incorrect password,
and verifies that the expected login error appears. It then sends the
observed error and page context to Gemini. When the API call succeeds,
the LLM response is attached to the Playwright test result.

This is a negative test: rejection of deliberately incorrect credentials
is expected behavior, not a SauceDemo defect.

### Run the LLM integration test

``` bash
npx playwright test tests/llm/failureExplainer.spec.ts --workers=1
```

This test requires a valid Gemini API key and network access. Review its
current implementation before running if its test inputs or expected
behavior have changed.

### Run all tests

``` bash
npx playwright test
```

The full suite may include optional tests against external login pages.
Those tests can be affected by redirects, site changes, network access,
and API availability. For a focused demonstration of the selected
option, run the SauceDemo test separately.

## View the test report

``` bash
npx playwright show-report
```

Open the test and expand **Attachments** to inspect
`llm-failure-explanation.txt`. The saved sample in
`docs/llm-sample-output.md` lets reviewers inspect an example without
making a new API call.

## How the Failure Explainer works

1.  The Playwright test performs a login attempt and verifies the
    visible result.
2.  The test collects available evidence, such as test name, error
    message, page URL, page text, and relevant network responses when
    available.
3.  `src/llm/failureExplainer.ts` sends the details to the configured
    Gemini model using `@google/genai`.
4.  Gemini is instructed to return JSON with `explanation`,
    `likelyCause`, and `suggestedFix`.
5.  The code parses and validates those fields.
6.  The test or fixture attaches the generated explanation to the
    Playwright test result.

The LLM output is advisory. Review it against the evidence. Network
activity can include unrelated telemetry and should not be mistaken for
an authentication response.


## What I would build next with more time

1.  Add bounded retries and a graceful fallback for transient Gemini
    errors.
2.  Filter network evidence to relevant application endpoints and redact
    sensitive values before sending data to the model.
3.  Add tests for missing API keys, empty responses, invalid JSON,
    malformed model output, and API timeouts.
4.  Report the UI test result separately from AI-analysis availability.
5.  Improve the HTML report so the assertion, evidence, explanation,
    likely cause, and suggested fix are easy to compare.
6.  Run the suite in GitHub Actions using a securely stored secret and
    publish the Playwright report as an artifact.

