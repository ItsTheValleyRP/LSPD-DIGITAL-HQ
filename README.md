# LSPD Digital HQ

A separate department-wide headquarters portal for the Los Santos Police Department.

**This repository is independent from LSPD Nightfall Intelligence. Nightfall remains detective-only and is not modified by this project.**

## Current stage

The initial responsive frontend is in place:
- Department headquarters landing page and seven division cards: Air One, MCU, HEAT, Detectives, K-9, SWAT, and Internal Affairs.
- Division access screen UI.
- Division-specific dashboard preview layouts.
- Department resource navigation for directory, two separate chat areas, SOPs, training, reports, and administration.
- Mobile-friendly layout.

## Security and backend status

This is a frontend preview only. It does **not** authenticate users, verify division passwords, store personnel data, or provide live chat yet. Do not enter real passwords into this preview.

The next phase is a separate Supabase project with:
- User authentication and department membership.
- Server-side authorization and Row Level Security (RLS).
- Division membership and Division Head-scoped management.
- Separate department rank, division role, certifications, and system permissions.
- Protected Super Administrator ownership and immutable audit history.
- Secure division access checks; a shared division password alone will not grant access.

Division applications remain in Discord and are intentionally not part of this website.

## Deployment

A GitHub Actions workflow is included at `.github/workflows/deploy.yml`. It runs on pushes to `main` and can also be started manually from the repository's **Actions** tab. It validates the HTML entry point and inline JavaScript, then deploys the repository to GitHub Pages.

One-time repository setup:
1. Open **Settings → Pages**.
2. Under **Build and deployment**, set **Source** to **GitHub Actions**.
3. Open the **Actions** tab and check the latest **Deploy LSPD Digital HQ to GitHub Pages** run.

The public site is not confirmed live until the Actions run succeeds and the Pages URL opens successfully.
