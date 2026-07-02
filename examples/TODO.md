# 待办清单

> 最后更新：2026-07-02
> 维护规则：会话开始时读，会话结束时按 `references/session-maintenance-protocol.md` 更新

## 🔴 进行中

- [ ] (P1) 实现用户头像上传到 S3 的预签名 URL 流程  源:`src/api/users/upload.ts:42` (2026-07-01)

## 🟡 待处理

- [ ] (P1) 修复登录页在 Safari 17 下的样式错位  源:`src/pages/Login.tsx:78` (2026-07-02)
- [ ] (P1) /api/orders 端点在并发 100 时返回 502，需补 rate limit 中间件  源:`src/api/orders/route.ts:23` (2026-06-30)
- [ ] (P2) 替换 `src/legacy/db.js` 里所有 `var` 为 `const`/`let`  (2026-06-28)
- [ ] (P2) 给 `UserService` 补单元测试  源:`src/services/UserService.ts` (2026-06-25)
- [ ] (P2) 数据库连接超时从 5s 调到 10s，配置文件里搜 `DB_TIMEOUT`  (2026-06-20)

## 🟢 后续

- [ ] 把 `src/utils/strings.ts` 里的 `capitalize` 抽到内部 npm 包
- [ ] 评估迁移到 pnpm workspaces 是否值得
- [ ] 给 README 补架构图
- [ ] 升级 Next.js 14 → 15
- [ ] 拆 `src/pages/dashboard.tsx`（已 800 行）

## ✅ 已完成

- [x] 初始化项目 CLAUDE.md + TODO.md (2026-07-02)
- [x] 配置 ESLint + Prettier (2026-06-20)
- [x] 删除遗留的 `console.log` 调试代码  源:`src/api/auth/route.ts:55` (2026-06-18)
- [x] ~~接入 Sentry~~ 已放弃：决定改用 OpenTelemetry 自建 (2026-06-15)