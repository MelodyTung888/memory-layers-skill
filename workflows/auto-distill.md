# auto-distill — 自动沉淀工作流

**触发条件**：对话结束时自动触发，无需用户要求

---

## 自动触发判断

**立即触发沉淀**（以下任一情况）：
- 用户做了重要决策（"我决定..."、"那就..."、明确选择）
- 用户踩了坑或遇到挫折（"没想到..."、"失败了..."、"被拒了..."）
- 用户有突破性洞察（"我意识到..."、"突然想通了..."）
- 用户完成任务后总结（"做完了..."、"成功了..."）
- 发现当前事件与历史模式高度吻合

**不触发**：
- 纯闲聊、无关痛痒的对话
- 简单问答、没有新认知产生

---

## 执行流程

### Step 1：识别值得沉淀的内容

扫描本次对话，找出：
- 用户的决策点
- 用户的洞察或教训
- 用户的情绪变化（踩坑的挫败感、突破的兴奋感）
- 与已有模式的共鸣点

**判断标准**：如果这段对话消失会可惜吗？会 → 沉淀。

### Step 2：判断沉淀深度

| 情况 | 沉淀深度 |
|------|----------|
| 零散洞察，无完整事件 | 仅 L2 经验，写入 `inbox/` 稍后整理 |
| 有完整事件 | 走 distill 完整五层 |
| 与已有模式共鸣 | distill + 在 `.index.json` 中标注关联 |
| 重大认知升级 | distill + 检查是否需要更新 L5 身份 |

### Step 3：写入 vault

```
# 读取 vault 路径配置
CONFIG="$HOME/.claude/skills/memory-layers/.config.json"
if [ -f "$CONFIG" ]; then
  VAULT=$(jq -r '.vault_path // empty' "$CONFIG" 2>/dev/null)
fi

# 如果没有配置，提示用户设置
if [ -z "$VAULT" ] || [ "$VAULT" = "null" ]; then
  echo "SETUP_REQUIRED"
  exit 1
fi

# 确定输出路径
case $沉淀深度 in
  inbox)   OUT="$VAULT/inbox/$(date +%Y%m%d-%H%M%S).md" ;;
  distill) OUT="$VAULT/layers/L1-events/$(date +%Y%m%d-%H%M%S).md" ;;
esac

# 写入文件
cat > "$OUT" << 'EOF'
[沉淀内容]
EOF

# 索引到 FTS5
SCRIPTS_PATH=$(jq -r '.scripts_path // "$HOME/.claude/scripts"' "$CONFIG" 2>/dev/null)
"$SCRIPTS_PATH/memory-layers-index.sh" "$LAYER" "$TITLE" "$CONTENT" "$OUT" "$(date +%Y-%m-%d)"
```

### Step 4：自动 L3→L4 提炼

如果沉淀深度达到 distill，且 L3 模式置信度高：
- **自动触发 L4 提炼**，不等待，不打扰
- L4 生成后自动索引到 FTS5

### Step 5：注册提醒

根据沉淀深度，在 `reminders/pending/` 中注册回看提醒：

```json
{
  "id": "reminder-$(date +%Y%m%d%H%M%S)",
  "type": "L2-review",
  "source": "layers/L1-events/xxx.md",
  "created_at": "$(date +%Y-%m-%d)",
  "due_at": "$(date -v+30d +%Y-%m-%d)",
  "status": "pending"
}
```

### Step 6：追踪引用计数

如果沉淀涉及 L3 模式或 L4 原则：
- 在 `layers/.index.json` 中更新 `skill_candidates`
- 引用计数 +1
- **达到 5 次时，提示 Melody 准备生成 skill**

```
skill_candidates 格式：
{
  "pattern-id-xxx": {
    "title": "压力决策模式",
    "ref_count": 3,
    "path": "layers/L3-patterns/xxx.md"
  }
}
```

### Step 5：静默完成

自动沉淀**不打断用户**，静默完成。如果沉淀过程中发现需要用户确认，才主动提示。

---

## 约束

1. **自动判断**：不依赖用户输入，自动判断是否值得沉淀
2. **最小阻力**：如果不确定，放到 inbox，不阻塞流程
3. **可回滚**：inbox 内容稍后可被合并或丢弃
4. **不打扰**：除非重大认知升级，不主动告知用户沉淀完成
5. **L3→L4 自动**：置信度高的 L3 模式自动向 L4 提炼，无需等待
6. **引用追踪**：每次调用 L3/L4 时计数，达到 5 次时通知 Melody
