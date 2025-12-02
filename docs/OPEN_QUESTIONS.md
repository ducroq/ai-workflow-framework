# Open Questions

## Critical (Blocking Progress)
*No critical blockers*

## Important (Affects Design)
- [ ] **Should hooks invoke agents directly or use external scripts?** - Current hooks are bash scripts. Agent invocation would require Claude Code API support. For now, hooks provide visibility/suggestions only.
- [x] **How should users customize which hooks are active?** - Resolved: Use settings.json hierarchy (user/project/local levels). See `.claude/hooks/README.md` for details.

## Nice to Know (Can Work Around)
- [ ] **Should we support multiple documentation styles?** - Some teams prefer different doc structures (ADRs vs RFCs, different templates)

## Resolved
- [x] **Windows compatibility** - Fixed ASCII output in hooks, documented settings layering (2025-12-02)
- [x] **Hook visibility** - Added status output to all hooks so users can see when they run (2025-12-02)

---

**Last Updated:** 2025-12-02 (auto-maintained)
