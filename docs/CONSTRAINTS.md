# Constraints

## Non-Negotiable
- **Zero manual work:** Documentation system must be fully automatic - developers should never need to manually update docs
- **Claude Code native:** Must work seamlessly within Claude Code ecosystem (agents, skills, hooks, MCP)
- **Project agnostic:** Framework must work for any type of project (web, mobile, ML, data science, etc.)

## Technical Limitations
- **Platform:** Claude Code CLI environment (Windows/Linux/macOS)
- **Performance:** Documentation updates must be fast (< 1 second) to not disrupt workflow
- **Compatibility:** Must work with existing project structures (not require specific folder layouts)
- **Context window:** Must use progressive disclosure to stay within Claude's context limits

## Resource Constraints
- **Time:** Solo developer, time-boxed development
- **Budget:** Open source project, no budget for external services
- **Team:** Single developer with AI assistance

## Self-Imposed Principles
- **Dogfooding:** Framework must use its own features (agents, auto-docs, hooks)
- **Progressive disclosure:** Load only needed context, never dump entire codebase
- **Pragmatic over dogmatic:** Create files only when they add value, not "just because"
- **Lean documentation:** Keep docs concise and focused (1-2 screens max for overviews)
- **Living documentation:** Docs must stay fresh automatically, never become stale
- **Developer trust:** System should feel magical, not intrusive or noisy
- **Reusability:** Every component should be reusable across projects
- **Clear patterns:** Follow established conventions (ADRs, component docs, etc.)

---

**Last Updated:** 2025-11-15 (auto-maintained)
