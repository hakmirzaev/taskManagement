# Task Management – Research-Grade SwiftUI & SwiftData Demo
Created by **Bekhruzjon Hakmirzaev** · Apple Developer Academy Naples (Cohort 2024-25)

A calendar-first task-tracking app that explores three new iOS 17 APIs in a single, focused codebase:

| Area | Frameworks / Tech | Why it matters for ARTE |
| ---- | ---------------- | ----------------------- |
| **Modern persistence** | **SwiftData** (model-container, @Query) | Evaluates Apple’s new Core Data successor in a non-trivial CRUD scenario. |
| **Natural language interaction** | **App Intents** + custom **`AddTaskIntent`** | Lets users add tasks via Siri / Shortcuts, demonstrating intent parametrisation and on-device NLP. |
| **Data visualisation** | **Charts** (+ animated interactivity) | Shows how behavioural metrics can be surfaced rapidly for user-centred research loops. |

---

## 1. Features
- **Week-slider calendar** with smooth paging and animated selection.  
- **Priority-based colour coding** (`low`, `medium`, `high`) and custom tints.  
- **Progress dashboard** &nbsp;→&nbsp; *daily / weekly / monthly* completion charts.  
- **Siri Shortcut** &nbsp;→&nbsp; “*Add task…*” invokes `AddTaskIntent`, stores to SwiftData, and refreshes UI instantly.  
- **100 % SwiftUI** (no storyboards), built with Swift Concurrency best-practices.

## 2. Research Hooks
| Question | Example experiment you can run |
| -------- | ----------------------------- |
| *SwiftData energy profile* | Benchmark write/read latency vs. Core Data on identical hardware. |
| *On-device LLM for task autocompletion* | Swap the description `TextField` for a Core ML transformer that suggests verbs. |
| *Privacy-respectful telemetry* | Attach “research-mode” toggles that log de-identified usage to App Intents, measuring shortcut adoption. |

## 3. Build & Run
```bash
git clone https://github.com/hakmirzaev/taskManagement-demo.git   # or drop the unzipped folder
open "Task Management.xcodeproj"

# Requirements
# • Xcode 15.3+
# • iOS 17 runtime
# • Swift 5.9
# No external dependencies – pure Apple frameworks.
