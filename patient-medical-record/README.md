# Sunbird Healthcare — Patient Medical Record (PMR) Module

Version 1.0 · November 2026 · Confidential

Solutions Architect: Alaa Himour · Backend: Zeina Itriq · Frontend: Mohammad Khalifa

## Contents

| File | What it is | Used by |
| --- | --- | --- |
| `Sunbird_Healthcare_Patient_Medical_Record_Blueprint_v1.0.docx` | Full-stack blueprint, page by page: 20 screens with screenshots, API calls, frontend behaviour, CSS classes, database changes, permissions, compliance checklist, sprint plan | Everyone |
| `sunbird-pmr-openapi-v1.0.yaml` | API contract (OpenAPI 3.0, 29 operations, 55 schemas) — the single source of truth | Zeina (generate interfaces), Mohammad (generate client, Prism mock) |
| `sunbird-patient-plate.css` | Stylesheet v0.6 — tokens and BEM classes for every screen | Mohammad |
| `screens/` | PNG screenshots of all 20 screens (S01–S20) | Everyone |
| `mockups/` | Static HTML mockups that produced the screenshots (`build.py` regenerates them) | Mohammad (reference markup) |

## API-first workflow

1. Review `sunbird-pmr-openapi-v1.0.yaml` in a pull request; change the contract before any code.
2. Freeze it with tag `pmr-api-v1.0`.
3. Backend: `openapi-generator` (Spring, `interfaceOnly=true`).
4. Frontend: `openapi-typescript` + `openapi-fetch`; mock with `prism mock sunbird-pmr-openapi-v1.0.yaml`.
5. CI contract tests fail the build when a response does not match the contract.

## Viewing the mockups

Open any file in `mockups/screens/` in a browser. They load `../sunbird-patient-plate.css`, the fonts in `mockups/fonts/` and the flags in `mockups/flags/`.

## Third-party assets

- Flags: [flag-icons](https://github.com/lipis/flag-icons) (MIT), 1x1 SVGs.
- Fonts: Inter, Barlow Condensed, Noto Sans Arabic (SIL Open Font License), via Fontsource.

## Online versions

- Blueprint (editable doc): https://claude.ai/artifact/1qBi9pg24wBHwjF5tSVTu5
- Design canvas (board, panel layouts, list options): https://claude.ai/artifact/1utZ6Y2XKw7ECzc27kofnt
