# Memory Layers — Five-Layer Memory System

[中文](./README.md) | English

Transform every experience into continuously appreciating wisdom assets.

## What Is This

A wisdom system that gradually elevates scattered experiences into actionable principles and core identity — starting from concrete events and working upward:

| Layer | Name | Question | Output |
|-------|------|----------|--------|
| L1 | Event | What happened? | Raw record |
| L2 | Experience | What did I learn? | Lessons & insights |
| L3 | Pattern | What are the rules? | Cross-event patterns |
| L4 | Principle | What are the guiding rules? | Actionable guidelines |
| L5 | Identity | Who am I? | Core identity positioning |

**Core philosophy**: Knowledge must be compiled once and maintained continuously. Not re-derived every time, but elevated layer by layer.

## v2.0 New Features (2026-04-10)

Four major capabilities added:

1. **Auto-distill** — AI automatically judges whether content is worth preserving at end of conversation, distills and saves silently. Zero burden.
2. **FTS5 Full-text Search** — Search across all memories instantly.
3. **Periodic Reminders** — AI periodically reminds you to review past memories and validate if they still hold.
4. **Skill Auto-generation** — When a pattern/principle is referenced 5 times, AI proactively proposes generating a reusable skill.

## Comparison with Hermes Agent

| Dimension | Hermes Agent | Five-Layer Memory |
|-----------|-------------|-------------------|
| **Design Goal** | Memory storage & retrieval for AI agents | Gradual distillation from experience to wisdom |
| **Core Mechanism** | Memory storage + search + skill reuse | Event→Experience→Pattern→Principle→Identity pipeline |
| **Memory Type** | Programmatic memory (skills) | Compiled wisdom assets (principles) |
| **Automation** | Manual trigger required | **Fully automatic** — AI judges, distills, and saves |
| **Unique Value** | Multi-platform, cross-session search | **Knowledge compiler**: memory becomes actionable principles |

**Why Five-Layer Memory is superior:**

Hermes's skills are "programmatic memory units" — they solve *what to remember*, but not *how memory becomes wisdom*. The Five-Layer Memory's unique value is its **knowledge compiler** role: it's not just storage, but a distillation pipeline that elevates concrete experiences into abstract, actionable principles. Hermes tells you "remember this"; the Five-Layer Memory tells you "what principle did you learn from this?"

## Quick Start

### First-time Setup

On first use, the AI will ask:

```
Please tell me the folder path where you want to store your memories, e.g.: ~/memory-vault or ~/Desktop/my-memories

(This folder will be created automatically — you just need to decide where and give it a name.)
```

Everything else uses sensible defaults. No manual configuration needed.

### AI Installation (let another AI download this skill)

```bash
# Option 1: Clone the GitHub repository
git clone https://github.com/MelodyTung888/memory-layers-skill.git ~/.claude/skills/memory-layers

# Option 2: Manual download & extract to skills directory
# Download: https://github.com/MelodyTung888/memory-layers-skill/archive/refs/heads/main.zip
```

### Trigger directly in Claude Code

```
沉淀 / distill / 逐层提炼 / complete flow
```

## Workflows

| Trigger | Workflow | Description |
|---------|----------|-------------|
| 五层沉淀、逐层提炼、完整走一遍 | `distill` | Full L1→L5 |
| 发生了什么、事件记录、记一下 | `record-event` | Event only (L1) |
| 从事件提炼经验、从经验找规律 | `ascend` | Single-layer elevation |
| 检查记忆系统、健康检查 | `status` | System health check |
| 生成记忆报告、给我讲讲我的模式 | `report` | Memory report |
| (no keyword, worth distilling) | `auto-distill` | **Auto-distill** |

## Core Constraints (Red Lines)

1. **No skipping layers**: L2 experience must be grounded in specific events
2. **No universal truths**: Every principle must trace back to events or patterns
3. **No one-shot completion**: The five layers are an iterative system
4. **No context-free principles**: Principles must be tied to specific domains/scenarios
5. **No L4 restating L3**: Principles must be more specific and actionable than patterns
6. **No skipping save**: When content is worth distilling, it must be written to vault
7. **No skipping index**: Every save is automatically indexed to the search database

## Standard Vault Structure

```
vault/
├── CLAUDE.md              # Vault self-doc
├── .config.json           # User config (generated on first setup)
├── layers/                # Five-layer memory storage
│   ├── L1-events/        # Event layer
│   ├── L2-experiences/   # Experience layer
│   ├── L3-patterns/       # Pattern layer
│   ├── L4-principles/     # Principle layer
│   ├── L5-identity/       # Identity layer
│   └── .index.json        # Global index
├── search/                # FTS5 search database
├── reminders/             # Periodic reminders
└── inbox/                 # Quick inbox
```

## Example

Input: A product launch that depressed team morale

Output:

```
L1: Event → Team morale dropped after last week's product launch
L2: Experience → Unsynced requirement changes caused rework; communication should come first
L3: Pattern → In cross-team collaboration, information sync timing determines execution quality
L4: Principle → Any cross-team dependency change must be synced to all parties within 24h
L5: Identity → I am a collaborator who values information transparency and drives proactively
```

## Use Cases

- Project retrospectives & experience distillation
- Pattern recognition for recurring problems
- Principle extraction after major decisions
- Team or personal knowledge management

---

*Powered by Claude Code, built on the five-layer memory framework.*
