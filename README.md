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

## Preview

Enable GitHub Pages in **Settings → Pages** and select **Deploy from a branch → main → / (root)**.
