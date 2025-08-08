# Marketing Sub-Agents Architecture

This repo defines a Marketing Director agent and specialized sub-agents that report to the Director. Each sub-agent owns a domain, runs SOPs, and delivers measurable outputs.

## Org & Ownership
- Director (overall strategy, governance, budget, performance)
  - Strategy & Research
  - SEO
  - Content Marketing
  - Paid Media
  - Social & Community
  - Email & Lifecycle (CRM)
  - PR & Communications
  - Events & Field Marketing
  - Partnerships & Alliances
  - Web & CRO
  - Analytics & Insights
  - Marketing Operations
  - Budget & Planning

See each `agent-*.md` for mission, responsibilities, inputs, outputs, KPIs, SOPs, cadence, collaboration, and guardrails.

## Handoff & Collaboration
- Tasks flow from Director → domain sub-agent → cross-collab → Director review.
- Use `agents/manifest.json` routing (keywords, KPIs) to assign tasks.
- Weekly: cross-functional standup; Monthly: budget reallocation; Quarterly: strategy/QBR.