# AGENTS.md

## 禅道 Bug 处理

- 任何要求修复 bug 的任务，修复完成后必须在 `docs/BugFixes/` 下编写修复日志。
- 未提供禅道 bug 编号的非禅道修复日志，文件名必须使用 `YYYY-MM-DD_<描述>.md` 格式；日期取日志创建日期，治理既有文件时可取文件最后修改日期。该时间戳规则不适用于 `docs/BugFixes/Zentao/`。
- 用户提供禅道 bug 编号时，修复日志必须保存为 `docs/BugFixes/Zentao/<编号>.md`；例如编号为 `1234` 时，文件必须为 `docs/BugFixes/Zentao/1234.md`。
- 修复日志至少记录问题现象、根因、修复范围、回归测试和尚未解决问题。
- 新增修复日志时，必须补充 `docs/BugFixes/README.md` 和 `docs/BugFixes/Zentao/README.md` 的导航；对应目录或 README 不存在时必须创建。
- 用户提供禅道 bug 编号且任务要求自动创建 Git 提交时，提交信息首行必须以 `fix-<编号>:` 开头，冒号后填写英文提交摘要；例如编号为 `1234` 时，提交信息必须以 `fix-1234:` 开头。
