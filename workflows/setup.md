# setup — 首次使用配置工作流

**触发条件**：首次使用五层记忆法时自动触发，或用户说"配置五层记忆"

---

## Step 1：询问用户 vault 路径

向用户询问：

```
欢迎使用五层记忆法！

请告诉我你要存放记忆的文件夹路径，例如：
~/记忆库 或 ~/Desktop/我的记忆 或 ~/Vault

这个文件夹会由系统自动创建，你只需告诉我想放在哪里、给它起个名字。
```

**验证**：确保路径不包含敏感信息，不与现有重要文件夹冲突。

---

## Step 2：创建配置文件

在 skill 目录创建 `.config.json`：

```json
{
  "vault_path": "<用户提供的绝对路径>",
  "scripts_path": "$HOME/.claude/scripts",
  "ref_threshold": 5,
  "reminder_days": {
    "L1-L2": 7,
    "L2-L3": 14,
    "L3-L4": 30,
    "L2-review": 30
  },
  "first_setup_at": "<ISO日期>"
}
```

---

## Step 3：自动创建 vault 目录结构

```bash
VAULT="<用户路径>"
mkdir -p "$VAULT"/{layers/{L1-events,L2-experiences,L3-patterns,L4-principles,L5-identity},search,reminders/{pending,done},inbox,skills}
touch "$VAULT/layers/.index.json"
```

---

## Step 4：复制脚本到 ~/.claude/scripts/

```bash
mkdir -p "$HOME/.claude/scripts"
cp "$HOME/.claude/skills/memory-layers/scripts/"* "$HOME/.claude/scripts/"
chmod +x "$HOME/.claude/scripts/memory-layers-"*.sh
```

---

## Step 5：初始化 FTS5 数据库

```bash
"$HOME/.claude/scripts/memory-layers-index.sh" init
```

---

## Step 6：验证配置

运行状态检查：

```bash
"$HOME/.claude/scripts/memory-layers-search.sh" ""
```

应该返回"暂无记忆"或空结果，而非报错。

---

## Step 7：告知用户完成

```
✅ 五层记忆法配置完成！

你的记忆 vault：<vault路径>
搜索脚本：已安装

现在开始使用：
- "沉淀" — 完整走五层沉淀
- "发生了什么" — 记录一个事件
- "搜索记忆 <关键词>" — 搜索记忆

更多信息见：~/.claude/skills/memory-layers/SKILL.md
```
