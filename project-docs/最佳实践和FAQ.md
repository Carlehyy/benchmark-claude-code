# 最佳实践和常见问题

## 最佳实践

### 1. TDD 开发流程

#### 标准流程

```
1. 写测试（RED）
   ↓
2. 实现代码（GREEN）
   ↓
3. 重构优化（REFACTOR）
   ↓
4. 代码审查
   ↓
5. 提交代码
```

#### 实际示例

**需求**：实现题目列表筛选功能

**Step 1：写测试（RED）**

```typescript
// tests/unit/services/question.service.test.ts
import { QuestionService } from '@/services/question.service';

describe('QuestionService', () => {
  let service: QuestionService;
  
  beforeEach(() => {
    service = new QuestionService();
  });
  
  describe('getQuestions', () => {
    it('应该返回所有题目', async () => {
      const questions = await service.getQuestions();
      expect(questions).toBeDefined();
      expect(questions.length).toBeGreaterThan(0);
    });
    
    it('应该按难度筛选题目', async () => {
      const questions = await service.getQuestions({ difficulty: 'easy' });
      expect(questions.every(q => q.difficulty === 'easy')).toBe(true);
    });
    
    it('应该按分类筛选题目', async () => {
      const questions = await service.getQuestions({ category: 'reasoning' });
      expect(questions.every(q => q.category === 'reasoning')).toBe(true);
    });
  });
});
```

运行测试：`npm test` → ❌ 失败（因为还没实现）

**Step 2：实现代码（GREEN）**

```typescript
// miniprogram/services/question.service.ts
export interface QuestionFilter {
  difficulty?: 'easy' | 'medium' | 'hard';
  category?: string;
}

export class QuestionService {
  /**
   * 获取题目列表
   * @param filter 筛选条件
   * @returns 题目列表
   */
  async getQuestions(filter?: QuestionFilter): Promise<Question[]> {
    const db = wx.cloud.database();
    let query = db.collection('questions');
    
    // 应用筛选条件
    if (filter?.difficulty) {
      query = query.where({ difficulty: filter.difficulty });
    }
    
    if (filter?.category) {
      query = query.where({ category: filter.category });
    }
    
    const { data } = await query.get();
    return data as Question[];
  }
}
```

运行测试：`npm test` → ✅ 通过

**Step 3：重构优化（REFACTOR）**

```typescript
// 提取查询构建逻辑
private buildQuery(filter?: QuestionFilter) {
  const db = wx.cloud.database();
  let query = db.collection('questions');
  
  if (filter) {
    const conditions = {};
    if (filter.difficulty) conditions.difficulty = filter.difficulty;
    if (filter.category) conditions.category = filter.category;
    
    if (Object.keys(conditions).length > 0) {
      query = query.where(conditions);
    }
  }
  
  return query;
}

async getQuestions(filter?: QuestionFilter): Promise<Question[]> {
  const query = this.buildQuery(filter);
  const { data } = await query.get();
  return data as Question[];
}
```

运行测试：`npm test` → ✅ 仍然通过

**Step 4：代码审查**

在 Claude Code 中：

```
/code-review

请审查这段代码：

[粘贴代码]

重点检查：
1. 代码质量
2. 性能问题
3. 边界情况处理
```

**Step 5：提交代码**

```bash
git add .
git commit -m "feat(question): 实现题目列表筛选功能

- 支持按难度筛选
- 支持按分类筛选
- 添加单元测试
- 测试覆盖率 100%"
```

---

### 2. 使用 Claude Code 的最佳实践

#### 规划阶段

```
# 开始新功能前，先规划
/plan

功能需求：[详细描述]
技术要求：[列出要求]
预期时间：[估算时间]
```

**示例**：

```
/plan

功能需求：实现表达训练模块

核心功能：
1. 提供多种表达模板（总分总、递进式、并列式）
2. 引导用户按结构填写
3. 实时保存草稿
4. 提交后显示 AI 评估

技术要求：
- 使用组件化开发
- 支持离线草稿保存
- 集成 LLM API 进行评估

预期时间：3 天

请创建详细的实施计划。
```

#### 开发阶段

```
# 使用 TDD 开发
/tdd

功能需求：[描述]
验收标准：[列出标准]
```

**示例**：

```
/tdd

功能需求：答题功能

验收标准：
1. 用户可以输入答案
2. 提交后显示是否正确
3. 显示正确答案和解析
4. 记录答题历史

请指导 TDD 开发。
```

#### 审查阶段

```
# 完成功能后审查
/code-review

请审查今天完成的代码，重点检查：
1. 代码质量
2. 性能问题
3. 安全隐患
```

#### 重构阶段

```
# 定期清理代码
/refactor-clean

请清理项目中的：
1. 未使用的代码
2. 重复代码
3. 过时的注释
```

---

### 3. 代码组织最佳实践

#### 服务层设计

```typescript
// services/base.service.ts
export abstract class BaseService {
  protected db = wx.cloud.database();
  
  protected handleError(error: any): never {
    console.error(error);
    wx.showToast({
      title: '操作失败',
      icon: 'none'
    });
    throw error;
  }
}

// services/question.service.ts
export class QuestionService extends BaseService {
  private collection = this.db.collection('questions');
  
  async getQuestions(filter?: QuestionFilter): Promise<Question[]> {
    try {
      const query = this.buildQuery(filter);
      const { data } = await query.get();
      return data as Question[];
    } catch (error) {
      return this.handleError(error);
    }
  }
}
```

#### 组件设计

```typescript
// components/question-card/question-card.ts
Component({
  properties: {
    question: {
      type: Object,
      value: null
    }
  },
  
  data: {
    // 组件内部数据
  },
  
  methods: {
    onTap() {
      this.triggerEvent('tap', { question: this.data.question });
    }
  }
});
```

#### 页面设计

```typescript
// pages/question-list/question-list.ts
import { QuestionService } from '@/services/question.service';

Page({
  data: {
    questions: [] as Question[],
    loading: false,
    filter: {
      difficulty: undefined,
      category: undefined
    }
  },
  
  questionService: new QuestionService(),
  
  async onLoad() {
    await this.loadQuestions();
  },
  
  async loadQuestions() {
    this.setData({ loading: true });
    
    try {
      const questions = await this.questionService.getQuestions(this.data.filter);
      this.setData({ questions });
    } catch (error) {
      console.error('加载题目失败', error);
    } finally {
      this.setData({ loading: false });
    }
  },
  
  onFilterChange(e: any) {
    this.setData({
      filter: { ...this.data.filter, ...e.detail }
    });
    this.loadQuestions();
  }
});
```

---

### 4. 性能优化最佳实践

#### 避免频繁 setData

❌ **不好的做法**：

```typescript
for (let i = 0; i < 100; i++) {
  this.setData({
    [`items[${i}]`]: data[i]
  });
}
```

✅ **好的做法**：

```typescript
this.setData({
  items: data
});
```

#### 使用防抖和节流

```typescript
// utils/debounce.ts
export function debounce<T extends (...args: any[]) => any>(
  func: T,
  wait: number
): (...args: Parameters<T>) => void {
  let timeout: number | null = null;
  
  return function(this: any, ...args: Parameters<T>) {
    if (timeout) clearTimeout(timeout);
    
    timeout = setTimeout(() => {
      func.apply(this, args);
    }, wait);
  };
}

// 使用
const debouncedSearch = debounce(this.onSearch, 300);
```

#### 图片懒加载

```xml
<image 
  src="{{item.image}}" 
  lazy-load="{{true}}"
  mode="aspectFill"
/>
```

#### 列表优化

```xml
<!-- 使用虚拟滚动 -->
<recycle-view 
  batch="{{batchSetRecycleData}}" 
  id="recycleId"
>
  <recycle-item wx:for="{{recycleList}}" wx:key="id">
    <view>{{item.title}}</view>
  </recycle-item>
</recycle-view>
```

---

### 5. 安全最佳实践

#### 输入验证

```typescript
// utils/validator.ts
export class Validator {
  /**
   * 验证用户输入
   */
  static validateAnswer(answer: string): boolean {
    if (!answer || answer.trim().length === 0) {
      wx.showToast({ title: '请输入答案', icon: 'none' });
      return false;
    }
    
    if (answer.length > 1000) {
      wx.showToast({ title: '答案过长', icon: 'none' });
      return false;
    }
    
    return true;
  }
  
  /**
   * 过滤敏感词
   */
  static filterSensitiveWords(text: string): string {
    // 实现敏感词过滤
    return text;
  }
}
```

#### 数据加密

```typescript
// utils/crypto.ts
export class CryptoUtil {
  /**
   * 加密敏感数据
   */
  static encrypt(data: string): string {
    // 使用微信提供的加密 API
    return wx.cloud.callFunction({
      name: 'encrypt',
      data: { text: data }
    });
  }
}
```

#### 权限检查

```typescript
// utils/auth.ts
export class AuthUtil {
  /**
   * 检查用户权限
   */
  static async checkPermission(permission: string): Promise<boolean> {
    const { authSetting } = await wx.getSetting();
    return authSetting[permission] === true;
  }
  
  /**
   * 请求用户授权
   */
  static async requestPermission(permission: string): Promise<boolean> {
    const { authSetting } = await wx.authorize({ scope: permission });
    return authSetting[permission] === true;
  }
}
```

---

## 常见问题（FAQ）

### Q1：如何在 Claude Code 中使用中文化配置？

**A**：安装后，所有命令和代理都支持中文。直接使用中文描述需求即可。

```
/plan

我要实现题库列表功能，请帮我规划。
```

### Q2：TDD 开发会不会很慢？

**A**：初期可能会慢一些，但长期来看会更快：

- ✅ 减少 bug，节省调试时间
- ✅ 重构更安全，不怕改坏代码
- ✅ 文档化代码行为
- ✅ 提高代码质量

**建议**：从核心功能开始使用 TDD，逐步扩展。

### Q3：测试覆盖率要达到多少？

**A**：建议标准：

- 核心业务逻辑：> 90%
- 服务层：> 80%
- 工具函数：> 90%
- UI 组件：> 60%

**不需要测试的**：
- 第三方库
- 简单的 getter/setter
- 纯 UI 展示（无逻辑）

### Q4：如何集成 LLM API？

**A**：使用云函数调用：

```typescript
// cloudfunctions/evaluateLogic/index.ts
import { OpenAI } from 'openai';

export async function main(event: any) {
  const { userAnswer, question } = event;
  
  const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY
  });
  
  const response = await openai.chat.completions.create({
    model: 'gpt-4',
    messages: [
      {
        role: 'system',
        content: '你是一位逻辑表达专家...'
      },
      {
        role: 'user',
        content: `题目：${question}\n答案：${userAnswer}`
      }
    ]
  });
  
  return response.choices[0].message.content;
}
```

**注意**：
- API Key 存储在云函数环境变量中
- 不要在前端暴露 API Key
- 做好错误处理和重试机制

### Q5：如何优化小程序包体积？

**A**：

1. **分包加载**

```json
{
  "pages": ["pages/index/index"],
  "subpackages": [
    {
      "root": "packageA",
      "pages": ["pages/question-list/question-list"]
    }
  ]
}
```

2. **图片优化**
   - 使用 WebP 格式
   - 压缩图片
   - 使用云存储 CDN

3. **代码压缩**
   - 开启代码压缩
   - 移除 console.log
   - Tree Shaking

4. **按需加载**
   - 懒加载组件
   - 异步加载数据

### Q6：如何处理云函数超时？

**A**：

1. **优化云函数性能**
   - 减少数据库查询
   - 使用缓存
   - 异步处理

2. **设置合理的超时时间**

```typescript
wx.cloud.callFunction({
  name: 'evaluateLogic',
  data: { ... },
  timeout: 60000 // 60 秒
});
```

3. **使用队列处理长任务**
   - 提交任务到队列
   - 轮询查询结果
   - 使用 WebSocket 推送结果

### Q7：如何调试云函数？

**A**：

1. **本地调试**

```bash
# 安装云函数调试工具
npm install -g @cloudbase/cli

# 本地运行云函数
tcb functions:run evaluateLogic --params '{"userAnswer":"..."}'
```

2. **云端日志**

```typescript
// 在云函数中添加日志
console.log('输入参数:', event);
console.log('处理结果:', result);
```

在微信开发者工具中查看云函数日志。

### Q8：如何实现离线功能？

**A**：

1. **使用本地存储**

```typescript
// utils/storage.ts
export class StorageUtil {
  static set(key: string, value: any): void {
    wx.setStorageSync(key, value);
  }
  
  static get<T>(key: string): T | null {
    return wx.getStorageSync(key) || null;
  }
}
```

2. **缓存策略**

```typescript
async getQuestions(): Promise<Question[]> {
  // 先从缓存读取
  const cached = StorageUtil.get<Question[]>('questions');
  if (cached) return cached;
  
  // 从服务器获取
  const questions = await this.fetchFromServer();
  
  // 更新缓存
  StorageUtil.set('questions', questions);
  
  return questions;
}
```

### Q9：如何处理用户反馈？

**A**：

1. **内置反馈功能**

```typescript
// pages/feedback/feedback.ts
Page({
  data: {
    content: '',
    contact: ''
  },
  
  async onSubmit() {
    await wx.cloud.callFunction({
      name: 'submitFeedback',
      data: {
        content: this.data.content,
        contact: this.data.contact,
        timestamp: Date.now()
      }
    });
    
    wx.showToast({ title: '提交成功' });
  }
});
```

2. **使用第三方服务**
   - 微信客服消息
   - 表单收集工具
   - 用户反馈平台

### Q10：如何准备小程序审核？

**A**：

**必备材料**：

1. **隐私政策**
   - 说明收集的用户信息
   - 说明信息使用方式
   - 说明信息保护措施

2. **用户协议**
   - 服务条款
   - 免责声明
   - 争议解决

3. **功能说明**
   - 核心功能描述
   - 使用流程说明
   - 截图和视频

4. **测试账号**（如果需要登录）
   - 提供测试账号
   - 说明测试流程

**审核要点**：

- ✅ 功能完整可用
- ✅ 无违规内容
- ✅ 隐私政策完整
- ✅ 用户协议清晰
- ✅ 信息真实准确

**常见拒绝原因**：

- ❌ 功能不完整
- ❌ 缺少隐私政策
- ❌ 内容违规
- ❌ 诱导分享
- ❌ 虚假宣传

---

## 资源推荐

### 官方文档
- [微信小程序官方文档](https://developers.weixin.qq.com/miniprogram/dev/framework/)
- [云开发文档](https://developers.weixin.qq.com/miniprogram/dev/wxcloud/basis/getting-started.html)
- [TypeScript 文档](https://www.typescriptlang.org/docs/)

### 学习资源
- [微信小程序最佳实践](https://developers.weixin.qq.com/community/develop/article/doc/000c4e433707c072c1793e56f5c813)
- [小程序性能优化](https://developers.weixin.qq.com/miniprogram/dev/framework/performance/)

### 工具推荐
- [微信开发者工具](https://developers.weixin.qq.com/miniprogram/dev/devtools/download.html)
- [Vant Weapp](https://youzan.github.io/vant-weapp/)（UI 组件库）
- [miniprogram-ci](https://www.npmjs.com/package/miniprogram-ci)（CI/CD 工具）

---

**记住：保持代码整洁，定期审查，持续改进！** 🚀
