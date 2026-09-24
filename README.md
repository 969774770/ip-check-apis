# IP Check APIs

精选 **21 个**公开的「查询访问者出口 IP」API，全部经过真实环境实测验证（`HTTP 200` 且成功解析出访问 IP）。

> 验证日期：**2026-09-24** · 验证方式：`curl`（超时 12s，两轮以上复验） · 网络：住宅/IDC 混合出口链路

## 快速开始

```bash
# 只要一个纯文本 IP
curl -s https://icanhazip.com

# 简单 JSON
curl -s https://api.ipify.org?format=json

# 富 JSON（含归属地 / ASN / ISP）
curl -s https://ipinfo.io/json

# 中文结果
curl -s https://myip.ipip.net
```

## API 列表

### 1. 极简（纯文本，只返回 IP）

| # | URL | 实测返回示例 |
|---|-----|--------------|
| 1 | https://icanhazip.com | `203.0.113.7` |
| 2 | https://ipecho.net/plain | `203.0.113.7` |
| 3 | https://ident.me | `203.0.113.7` |
| 4 | https://checkip.amazonaws.com | `203.0.113.7`（AWS 官方，极稳定） |

### 2. 简单 JSON（只有 ip 字段）

| # | URL | 实测返回示例 |
|---|-----|--------------|
| 5 | https://api.ipify.org?format=json | `{"ip":"203.0.113.7"}` |
| 6 | https://api64.ipify.org?format=json | 同上（v4/v6 双栈出口） |
| 7 | https://jsonip.com | `{"ip":"203.0.113.7"}` |
| 8 | https://httpbin.org/ip | `{"origin":"203.0.113.7"}` |
| 9 | https://api.ip.sb/jsonip | `{"ip":"203.0.113.7"}` |
| 10 | https://api.iplocation.net/?cmd=get-ip | `{"ip":"203.0.113.7","response_code":200,...}` |
| 11 | https://check.torproject.org/api/ip | `{"IsTor":false,"IP":"203.0.113.7"}`（附带 Tor 出口判断） |

### 3. 富 JSON（IP + 归属地 / ASN / ISP）

| # | URL | 返回要点 |
|---|-----|----------|
| 12 | https://ipinfo.io/json | `ip` `hostname` `city` `org` `timezone`，最常用 |
| 13 | https://ipwho.is/ | `success` `type` `country` `city` `connection.isp`，字段全 |
| 14 | https://ifconfig.co/json | `country` `city` `asn` + 是否数据中心 IP 判定 |
| 15 | https://ifconfig.me/all.json | `ip_addr` + `user_agent` + 请求头回显 |
| 16 | https://api.ip.sb/geoip | `region` `isp` `asn` `country_code` |
| 17 | https://ipleak.net/json/ | `isp_name` `as_number` `country_code` |
| 18 | https://get.geojs.io/v1/ip/geo.json | `asn` `city` `country`，准确度高 |
| 19 | https://api.ipquery.io/?format=json | `isp` / `asn` / 风险信息分层返回 |

### 4. 中文返回

| # | URL | 实测返回示例 |
|---|-----|--------------|
| 20 | https://myip.ipip.net | `当前 IP：203.0.113.7 来自于：xx 国家/运营商`（文本格式） |

### 5. 附赠：分流验证探针

| # | URL | 说明 |
|---|-----|------|
| 21 | https://reallyfreegeoip.org/json/ | 富 JSON；在代理分流场景下本身就是很好的「规则命中」探针 |

## 结构化数据

全部 API 的机器可读清单见 [apis.json](apis.json)。

## 验证脚本

仓库自带一键体检脚本，随时复验这些 API 的可用性：

```powershell
# Windows PowerShell
./scripts/check-apis.ps1
```

```bash
# Linux / macOS
bash scripts/check-apis.sh
```

输出示例：

```
 1 [OK] 200  ip=203.0.113.7  https://api.ipify.org?format=json
 2 [OK] 200  ip=203.0.113.7  https://ipinfo.io/json
 ...
SUMMARY: 21/21 OK
```

## 已淘汰名单（实测不过关，避免踩坑）

| URL | 淘汰原因 |
|-----|----------|
| ipapi.co | Cloudflare 403 挑战页 |
| api.myip.com | 连接失败 |
| ip.useragentinfo.com | 连接失败 |
| qifu-api.baidubce.com | 404 |
| api.vore.top | 服务端 500（Redis 配置错误） |
| ip-fast.com / freeipapi.com | 302 重定向不返回内容 |
| api.my-ip.io | 多轮测试中一轮超时，不稳定 |

## 说明

- 各站点均有自己的速率限制与配额，请勿高频轮询；生产环境建议本地缓存结果。
- 免费接口的归属地精度不保证，金融级场景请使用付费地理 IP 服务。
- 本清单仅收录「无需注册、无需 API Key」的公开接口。
- 欢迎提交 PR 补充新接口：请附上你的实测输出。

## License

[MIT](LICENSE)
