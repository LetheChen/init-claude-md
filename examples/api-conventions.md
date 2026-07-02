---
paths:
  - "src/api/**"
  - "src/routes/**"
  - "app/api/**"
---

# API conventions

所有 HTTP 路由都在 `src/api/<resource>/route.ts`（Express 项目用 `src/routes/`）。一个 resource 一个文件，一个 HTTP method 一个 handler。

## 规则

- 每个 handler 必须返回**有类型**的响应 —— 成功用 `Response.json<T>`，失败用 `errorResponse(code, message)`。**禁止** `res.send(obj)` 这种无类型返回
- 所有入参在 boundary 处用 `zod` schema 校验。**内部**调用信任类型系统，不再校验
- Auth 检查是**第一句**业务逻辑（在输入校验后）。auth 失败立刻 return，不做其他事
- 所有 DB 调用都走 `src/db/queries/`，**禁止**在 handler 里写裸 SQL
- Error 在 handler 顶层 catch —— helper 里**禁止** `try/catch`（让 error bubble 上来）
- 新增路由必须在 `src/api/__tests__/<resource>.test.ts` 补测试，至少覆盖：happy path、validation failure、auth failure

## Examples

Good: handler 顺序是 validate → auth check → business logic → Response.json
Bad: handler 直接 `res.json({ user })` 跳过了 auth

## Anti-patterns

- **Helper 里的 catch-all `try/catch`** —— 隐藏真实 error，让 handler 的 catch 没用
- **Handler 里 `await db.query(...)`** —— 绕过 query layer，没事务支持
- **GET handler 里改状态** —— 破坏 idempotency，搞坏缓存
- **Response 里塞原始 error 对象** —— 泄漏 stack trace，给攻击者信息